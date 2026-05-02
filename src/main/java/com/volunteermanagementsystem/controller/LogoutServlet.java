package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.util.SessionUtil;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * LogoutServlet - Destroys session and redirects to login
 * Author: Kaushal Adhikari
 * Group: The GOAT
 */
@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        SessionUtil.destroySession(request);
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}