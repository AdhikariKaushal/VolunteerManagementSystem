package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.util.SessionUtil;

import jakarta.servlet.http.*;
import java.io.IOException;


public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        SessionUtil.destroySession(request);
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}