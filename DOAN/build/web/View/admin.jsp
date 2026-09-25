<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, Model.Config" %>
<%
    String dbPath = Config.POSTS_DB_PATH;
    String url = "jdbc:sqlite:" + dbPath;
    try (Connection conn = DriverManager.getConnection(url)) {
        PreparedStatement stmt = conn.prepareStatement("SELECT id, platform, content, scheduled_time FROM posts WHERE approved=0 AND status='pending'");
        ResultSet rs = stmt.executeQuery();
        // ... hiển thị
    }
%>