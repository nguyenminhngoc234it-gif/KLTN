/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import com.mysql.cj.protocol.Resultset;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

/**
 *
 * @author pvbmi
 */
@WebServlet(name = "CheckPlanServlet", urlPatterns = {"/api/check-plan"})
public class CheckPlanServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CheckPlanServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CheckPlanServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    // 1. Lấy tham số (Chú ý hoa thường: PT_id)
    String ptId = request.getParameter("PT_id");
    boolean exists = false;
    int count = 0;

    System.out.println("====== CHECK PLAN START ======");
    System.out.println("ID nhận được: " + ptId);

    try {
        // 2. Kiểm tra Driver
        Class.forName("org.sqlite.JDBC");

        // 3. Dùng đường dẫn từ file Config của bạn
        // Đảm bảo bạn đã: import Model.Config;
        String dbPath = Model.Config.POSTS_DB_PATH; 
        System.out.println("Đường dẫn DB từ Config: " + dbPath);

        // 4. Kết nối
        Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        
        // 5. Truy vấn (Nên dùng COUNT để check tồn tại)
        String sql = "SELECT COUNT(*) FROM posts WHERE PT_id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, ptId);
        
        ResultSet rs = pstmt.executeQuery();
        if (rs.next()) {
            count = rs.getInt(1);
            if (count > 0) {
                exists = true;
            }
        }
        
        // 6. IN KẾT QUẢ LOG
        System.out.println("Kết quả truy vấn - Count: " + count + " | Exists: " + exists);

        rs.close();
        pstmt.close();
        conn.close();

    } catch (ClassNotFoundException e) {
        System.out.println("LỖI: Thiếu thư viện SQLite JDBC (Check WEB-INF/lib)");
        e.printStackTrace();
    } catch (SQLException e) {
        System.out.println("LỖI SQL: Có thể bảng 'posts' hoặc cột 'PT_id' không tồn tại");
        e.printStackTrace();
    } catch (Exception e) {
        System.out.println("LỖI CHUNG: " + e.getMessage());
        e.printStackTrace();
    }

    // 7. Trả về JSON cho JavaScript xử lý
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    response.getWriter().write("{\"exists\": " + exists + "}");
    System.out.println("====== CHECK PLAN END ======");
}

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
