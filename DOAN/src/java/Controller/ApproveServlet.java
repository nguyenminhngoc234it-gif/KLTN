package Controller;

import java.io.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import Model.Config;

//@WebServlet("/approve")
//public class ApproveServlet extends HttpServlet {
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
//        int id = Integer.parseInt(req.getParameter("id"));
//        try (Connection conn = DriverManager.getConnection("jdbc:sqlite:" + Config.POSTS_DB_PATH)) {
//            PreparedStatement stmt = conn.prepareStatement("UPDATE posts SET approved=1 WHERE id=?");
//            stmt.setInt(1, id);
//            stmt.executeUpdate();
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        resp.sendRedirect("admin.jsp");
//    }
//}