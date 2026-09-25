/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.DbConnect;
import javax.servlet.ServletException;
import java.io.*;
import java.sql.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 *
 * @author pvbmi
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

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
            out.println("<title>Servlet RegisterServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RegisterServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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

        request.setCharacterEncoding("UTF-8");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (password != null && password.equals(confirmPassword)) {
            Connection conn = null;
            PreparedStatement ps = null;

            try {
                // 1. Kết nối DB
                DbConnect db = new DbConnect();
                conn = db.getConnection();

                // 2. Viết câu lệnh SQL (Bảng user giả định có 3 cột: full_name, email, password)
                String sql = "INSERT INTO user (full_name, email, password) VALUES (?, ?, ?)";
                ps = conn.prepareStatement(sql);
                ps.setString(1, fullName);
                ps.setString(2, email);
                ps.setString(3, password); // Thực tế nên mã hóa password trước khi lưu!

                // 3. Thực thi
                ps.executeUpdate();

                HttpSession session = request.getSession();

                // 2. Lưu Email và Password vào Session
                session.setAttribute("registeredEmail", email);
                session.setAttribute("registeredPass", password);
                // Trong khối try (Thành công)
                response.sendRedirect(request.getContextPath() + "/View/Login.jsp?status=success");

// Trong khối catch (Thất bại)
// Lưu ý: dispatcher thường bắt đầu từ thư mục 'web' nên /View/Register.jsp là đúng nếu file nằm đó.
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Database Error: " + e.getMessage());
                request.getRequestDispatcher("/View/Register.jsp").forward(request, response);
            } finally {
                // Đóng kết nối
                try {
                    if (ps != null) {
                        ps.close();
                    }
                    if (conn != null) {
                        conn.close();
                    }
                } catch (Exception e) {
                }
            }
        } else {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.getRequestDispatcher("/View/Register.jsp").forward(request, response);
        }
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
