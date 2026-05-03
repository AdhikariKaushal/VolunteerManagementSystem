package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.service.OrganizationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/org/register")
public class OrgRegisterServlet extends HttpServlet {

    private final OrganizationService orgService = new OrganizationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/views/organization/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String orgName         = req.getParameter("orgName");
        String email           = req.getParameter("email");
        String password        = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String orgType         = req.getParameter("orgType");
        String description     = req.getParameter("description");
        String website         = req.getParameter("website");
        String phone           = req.getParameter("phone");
        String address         = req.getParameter("address");

        String error = orgService.register(
                orgName, email, password, confirmPassword,
                orgType, description, website, phone, address);

        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("orgName", orgName);
            req.setAttribute("email", email);
            req.setAttribute("orgType", orgType);
            req.setAttribute("description", description);
            req.setAttribute("website", website);
            req.setAttribute("phone", phone);
            req.setAttribute("address", address);
            req.getRequestDispatcher("/views/organization/register.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/org/login?success=registered");
        }
    }
}