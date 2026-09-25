package Controller;

import Model.Config;
import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet("/api/check-and-post")
public class CheckAndPostServlet extends HttpServlet {

    private Connection getDBConnection() throws SQLException {
        return DriverManager.getConnection("jdbc:sqlite:" + Config.POSTS_DB_PATH);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        List<Integer> postedIds = new ArrayList<>();

        try (Connection conn = getDBConnection()) {
            // Lấy bài đã đến giờ, chưa đăng, đã được duyệt
            String sql = "SELECT id, platform, content FROM posts " +
                         "WHERE status='pending' AND approved=1 AND scheduled_time <= datetime('now')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String platform = rs.getString("platform");
                String content = rs.getString("content");

                // Gọi Python script post_social.py để đăng bài
                ProcessBuilder pb = new ProcessBuilder(
                    Config.PYTHON_EXEC,
                    Config.POST_SOCIAL_SCRIPT,
                    String.valueOf(id),
                    platform,
                    content
                );
                pb.directory(new File(Config.PYTHON_SCRIPTS_DIR));
                pb.redirectErrorStream(true);
                Process process = pb.start();

                BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
                StringBuilder output = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) output.append(line);
                int exitCode = process.waitFor();

                // Kiểm tra kết quả từ Python (JSON {"success": true/false, "message": "..."})
                boolean success = false;
                if (exitCode == 0 && output.toString().contains("\"success\": true")) {
                    success = true;
                }

                if (success) {
                    PreparedStatement update = conn.prepareStatement("UPDATE posts SET status='posted' WHERE id=?");
                    update.setInt(1, id);
                    update.executeUpdate();
                    postedIds.add(id);
                } else {
                    // Tăng retry_count, nếu >= 3 thì chuyển sang failed
                    PreparedStatement update = conn.prepareStatement(
                        "UPDATE posts SET retry_count = retry_count + 1, " +
                        "status = CASE WHEN retry_count >= 2 THEN 'failed' ELSE 'pending' END " +
                        "WHERE id=?"
                    );
                    update.setInt(1, id);
                    update.executeUpdate();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.print(new JSONObject().put("status", "error").put("message", e.getMessage()).toString());
            return;
        }

        JSONObject result = new JSONObject();
        result.put("status", "success");
        result.put("posted", postedIds);
        out.print(result.toString());
    }
}