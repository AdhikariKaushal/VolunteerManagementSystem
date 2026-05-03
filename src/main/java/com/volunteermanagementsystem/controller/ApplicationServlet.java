package com.volunteermanagementsystem.controller;


import com.volunteermanagementsystem.model.Application;
import com.volunteermanagementsystem.model.Opportunity;
import com.volunteermanagementsystem.service.ApplicationService;
import com.volunteermanagementsystem.service.OpportunityService;
import com.volunteermanagementsystem.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;
import java.util.List;

@WebServlet("/application/*")
public class ApplicationServlet extends HttpServlet {

    private final ApplicationService appService = new ApplicationService();
    private final OpportunityService oppService = new OpportunityService();

    /**
     * GET /application/list?oppId= → view all applicants for an opportunity
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        int orgId   = SessionUtil.getOrgId(req);

        if ("/list".equals(path)) {
            int oppId = Integer.parseInt(req.getParameter("oppId"));
            Opportunity opp = oppService.getById(oppId);

            // Security: ensure the opportunity belongs to the logged-in org
            if (opp == null || opp.getOrgId() != orgId) {
                resp.sendRedirect(req.getContextPath() + "/org/dashboard");
                return;
            }

            List<Application> applicants = appService.getByOpportunity(oppId);
            req.setAttribute("opp", opp);
            req.setAttribute("applicants", applicants);
            req.getRequestDispatcher("/views/organization/applicants.jsp").forward(req, resp);

        } else {
            resp.sendRedirect(req.getContextPath() + "/org/dashboard");
        }
    }

    /**
     * POST /application/approve → approve an application
     * POST /application/reject  → reject an application
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        int appId   = Integer.parseInt(req.getParameter("appId"));
        int oppId   = Integer.parseInt(req.getParameter("oppId"));

        if ("/approve".equals(path)) {
            String error = appService.approve(appId, oppId);
            if (error != null) {
                req.getSession().setAttribute("flashError", error);
            } else {
                req.getSession().setAttribute("flashSuccess", "Applicant approved successfully.");
            }

        } else if ("/reject".equals(path)) {
            String error = appService.reject(appId);
            if (error != null) {
                req.getSession().setAttribute("flashError", error);
            } else {
                req.getSession().setAttribute("flashSuccess", "Applicant rejected.");
            }
        }

        resp.sendRedirect(req.getContextPath() + "/application/list?oppId=" + oppId);
    }
}