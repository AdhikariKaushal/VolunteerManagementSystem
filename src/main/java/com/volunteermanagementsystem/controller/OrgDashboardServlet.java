package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.model.Organization;
import com.volunteermanagementsystem.model.Opportunity;
import com.volunteermanagementsystem.service.OpportunityService;
import com.volunteermanagementsystem.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class OrgDashboardServlet extends HttpServlet {

    private final OpportunityService oppService = new OpportunityService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Organization org = SessionUtil.getOrganization(req);

        // Redirect to login if session expired or org not found
        if (org == null) {
            resp.sendRedirect(req.getContextPath() + "/org/login");
            return;
        }

        List<Opportunity> opportunities = oppService.getByOrg(org.getOrgId());
        req.setAttribute("org", org);
        req.setAttribute("opportunities", opportunities);
        req.getRequestDispatcher("/views/organization/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if ("logout".equals(action)) {
            SessionUtil.invalidate(req);
            resp.sendRedirect(req.getContextPath() + "/org/login");
        } else {
            resp.sendRedirect(req.getContextPath() + "/org/dashboard");
        }
    }
}