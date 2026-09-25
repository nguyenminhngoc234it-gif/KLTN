/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

/**
 *
 * @author pvbmi
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnect {
    public Connection getConnection() throws ClassNotFoundException, SQLException {
        // Khai báo driver của SQLite
        Class.forName("org.sqlite.JDBC");
        
        // Đường dẫn đến file database. 
        // Lưu ý: Nên dùng đường dẫn tuyệt đối hoặc để trong thư mục dự án
        String url = "jdbc:sqlite:"+ Config.POSTS_DB_PATH;
         
        return DriverManager.getConnection(url);
    }
}
