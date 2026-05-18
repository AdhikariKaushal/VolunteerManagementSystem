package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.model.Organization;
import com.volunteermanagementsystem.service.OrganizationService;
import com.volunteermanagementsystem.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class OrgLoginServlet extends HttpServlet {

    private final OrganizationService orgService = new OrganizationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (SessionUtil.isOrgLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/org/dashboard");
            return;
        }

        // Check for success message from registration
        String success = req.getParameter("success");
        if ("registered".equals(success)) {
            req.setAttribute("success", "Registration successful! You can now log in.");
        }

        // Check for session-based success message
        String sessionSuccess = (String) req.getSession().getAttribute("success");
        if (sessionSuccess != null) {
            req.setAttribute("success", sessionSuccess);
            req.getSession().removeAttribute("success");
        }

        req.getRequestDispatcher("/views/organization/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        Organization org = orgService.login(email, password);

        if (org != null) {
            req.getSession().invalidate();    // destroy old session
            req.getSession(true);             // create fresh session
            SessionUtil.setOrganization(req, org);
            resp.sendRedirect(req.getContextPath() + "/org/dashboard");
        } else {
            req.setAttribute("error", orgService.getLoginError(email, password));
            req.setAttribute("email", email);
            req.getRequestDispatcher("/views/organization/login.jsp").forward(req, resp);
        }
    }
}