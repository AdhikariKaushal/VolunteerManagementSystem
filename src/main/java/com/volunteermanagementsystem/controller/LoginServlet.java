package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.model.User;
import com.volunteermanagementsystem.service.AuthService;
import com.volunteermanagementsystem.util.SessionUtil;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

/**
 * LoginServlet - Handles login form submission
 * Author: Kaushal Adhikari
 * Group: The GOAT
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private AuthService authService = new AuthService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // Step 1 — basic validation
        if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Step 2 — authenticate
        User user = authService.login(email.trim(), password.trim());

        if (user == null) {
            request.setAttribute("error", "Invalid email or password. Please try again.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Step 3 — create session
        SessionUtil.createSession(request, user.getUserId(), user.getEmail(), user.getRole());

        // Step 4 — redirect based on role
        String contextPath = request.getContextPath();
        switch (user.getRole()) {
            case "admin":
                response.sendRedirect(contextPath + "/views/admin/dashboard.jsp");
                break;
            case "volunteer":
                response.sendRedirect(contextPath + "/views/volunteer/dashboard.jsp");
                break;
            case "organization":
                response.sendRedirect(contextPath + "/views/organization/dashboard.jsp");
                break;
            default:
                response.sendRedirect(contextPath + "/login.jsp");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // If already logged in redirect to dashboard
        if (SessionUtil.isLoggedIn(request)) {
            String role = SessionUtil.getUserRole(request);
            String contextPath = request.getContextPath();
            switch (role) {
                case "admin":        response.sendRedirect(contextPath + "/views/admin/dashboard.jsp"); break;
                case "volunteer":    response.sendRedirect(contextPath + "/views/volunteer/dashboard.jsp"); break;
                case "organization": response.sendRedirect(contextPath + "/views/organization/dashboard.jsp"); break;
                default:             response.sendRedirect(contextPath + "/login.jsp");
            }
        } else {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}