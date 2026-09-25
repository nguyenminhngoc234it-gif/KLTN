package Controller;

import Model.User;
import Model.UserDAO;
import javax.servlet.ServletException;
import java.io.IOException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Cookie[] cookies = request.getCookies();
        String userId = null;

        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals("user_id")) {
                    userId = c.getValue();
                }
            }
        }

        if (userId != null) {
            try {
                UserDAO dao = new UserDAO();
                User user = dao.getUserById(Integer.parseInt(userId));

                if (user != null) {
                    request.getSession().setAttribute("user", user);
                    response.sendRedirect(request.getContextPath() + "/View/main.jsp");
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.getRequestDispatcher("/View/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // 🔥 Cookie
            Cookie cookie = new Cookie("user_id", String.valueOf(user.getId()));
            cookie.setMaxAge(7 * 24 * 60 * 60);
            cookie.setPath("/");
            response.addCookie(cookie);

            response.sendRedirect(request.getContextPath() + "/View/main.jsp");

        } else {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("/View/Login.jsp").forward(request, response);
        }
    }
}
