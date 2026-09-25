package Model;

import java.sql.*;

public class UserDAO {

    DbConnect db = new DbConnect();

    // 🔥 LOGIN
    public User login(String email, String password) {
        String sql = "SELECT * FROM user WHERE email = ? AND password = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            System.out.println("Email: " + email);
            System.out.println("Password: " + password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("user_id")); // 🔥 QUAN TRỌNG
                u.setEmail(rs.getString("email"));
                u.setPassword(rs.getString("password"));
                u.setFullName(rs.getString("full_name"));

                System.out.println("✅ Login thành công");
                return u;
            } else {
                System.out.println("❌ Sai tài khoản");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // 🔥 AUTO LOGIN (COOKIE)
    public User getUserById(int id) {
        String sql = "SELECT * FROM user WHERE user_id = ?";

        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setPassword(rs.getString("password"));
                u.setFullName(rs.getString("full_name"));
                return u;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}