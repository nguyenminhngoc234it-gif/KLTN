
package Controller;

import Model.Config;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.json.JSONObject;

@WebServlet("/api/create-plan")
public class CreatePlanServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        resp.setContentType("application/json; charset=UTF-8");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        // ================= BODY =================
        String body = req.getReader().lines().collect(Collectors.joining());
        JSONObject input = new JSONObject(body);

        String platform = input.getString("platform");
        String url = input.optString("url", "");
        String PT_id = input.optString("PT_id", "");

        if (url.isEmpty()) {
            out.print(new JSONObject().put("status", "error").put("message", "URL trống"));
            return;
        }

        if (PT_id.isEmpty()) {
            out.print(new JSONObject().put("status", "error").put("message", "Thiếu PT_id"));
            return;
        }

        // ================= COOKIE =================
        String userId = null;
        Cookie[] cookies = req.getCookies();

        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("user_id")) {
                    userId = c.getValue();
                }
            }
        }

        if (userId == null) {
            out.print(new JSONObject()
                .put("status", "error")
                .put("message", "Chưa đăng nhập")
            );
            return;
        }

        // ================= SCHEDULE =================
        String schedule = "{}";
        if (input.has("schedule")) {
            schedule = input.getJSONObject("schedule").toString();
        }

        // fix escape để truyền tham số vào terminal an toàn
        schedule = schedule.replace("\"", "\\\"");

        // ================= SCRIPT =================
        File script = new File(Config.CREATE_PLAN_SCRIPT);
        if (!script.exists()) {
            out.print(new JSONObject()
                .put("status", "error")
                .put("message", "Không tìm thấy script")
            );
            return;
        }

        try {
            ProcessBuilder pb = new ProcessBuilder(
                Config.PYTHON_EXEC,
                Config.CREATE_PLAN_SCRIPT,
                platform,
                url,
                userId,
                PT_id,
                schedule
            );

            pb.directory(new File(Config.PYTHON_SCRIPTS_DIR));
            pb.redirectErrorStream(true);

            Process process = pb.start();

            // ================= READ OUTPUT =================
            StringBuilder outputBuilder = new StringBuilder();
            StringBuilder errorLog = new StringBuilder(); // 🔥 Biến mới dùng để chứa log lỗi của python

            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {

                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println("Python Log: " + line);
                    
                    String trimmedLine = line.trim();
                    // 🔥 THUẬT TOÁN LỌC: Chỉ lấy dòng nào thực sự là chuỗi JSON
                    if (trimmedLine.startsWith("{") && trimmedLine.endsWith("}")) {
                        outputBuilder.append(trimmedLine);
                    } else {
                        // Những dòng chữ như D:\KLTH_AI... sẽ bị ném vào biến errorLog này
                        errorLog.append(trimmedLine).append(" \n ");
                    }
                }
            }

            // ================= WAIT =================
            boolean finished = process.waitFor(180, TimeUnit.SECONDS);

            if (finished) {
                int exitCode = process.exitValue();
                String result = outputBuilder.toString();

                // Nếu có JSON trả về và Python không bị Crash
                if (exitCode == 0 && !result.isEmpty()) {
                    out.print(result);
                } else {
                    // Nếu Python Crash, trả về 1 chuỗi JSON thông báo lỗi chứa cái errorLog ở trên
                    out.print(new JSONObject()
                        .put("status", "error")
                        .put("message", "Lỗi Python: " + errorLog.toString())
                    );
                }

            } else {
                process.destroyForcibly();

                out.print(new JSONObject()
                    .put("status", "error")
                    .put("message", "Timeout (>180s). Quá trình chạy AI quá lâu.")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();

            out.print(new JSONObject()
                .put("status", "error")
                .put("message", "Java lỗi: " + e.getMessage())
            );
        }
    }
}