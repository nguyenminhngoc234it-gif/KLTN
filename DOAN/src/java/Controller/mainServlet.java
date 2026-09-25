/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Model.Config;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author pvbmi
 */
@WebServlet(name = "mainServlet", urlPatterns = {"/mainServlet"})
public class mainServlet extends HttpServlet {

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
            out.println("<title>Servlet mainServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet mainServlet at " + request.getContextPath() + "</h1>");
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

    response.setContentType("text/event-stream;charset=UTF-8");
    response.setHeader("Cache-Control", "no-cache");

    PrintWriter out = response.getWriter();

    String url = request.getParameter("url");

    String userId = "0";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie c : cookies) {
            if (c.getName().equals("user_id")) {
                userId = c.getValue();
            }
        }
    }

    String scriptPath = getServletContext().getRealPath("/AI/d.py");
    if (scriptPath == null || !new java.io.File(scriptPath).exists()) {
        scriptPath = Config.PYTHON_SCRIPTS_DIR + "/d.py";
    }

    ProcessBuilder pb = new ProcessBuilder(
        "python",
        scriptPath,
        url,
        userId
    );

    pb.redirectErrorStream(true);

    Process process = pb.start();

    BufferedReader reader = new BufferedReader(
        new InputStreamReader(process.getInputStream(), "UTF-8")
    );

    String line;
    while ((line = reader.readLine()) != null) {
        out.print(line + "\n");
        out.flush();
    }

    try {
        process.waitFor();
    } catch (InterruptedException e) {
        out.print("ERROR|" + e.getMessage());
        out.flush();
    }

    reader.close();
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
