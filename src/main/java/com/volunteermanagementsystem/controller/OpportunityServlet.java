package com.volunteermanagementsystem.controller;



import com.volunteermanagementsystem.model.Opportunity;
import com.volunteermanagementsystem.service.OpportunityService;
import com.volunteermanagementsystem.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import java.io.IOException;

@WebServlet("/opportunity/*")
public class OpportunityServlet extends HttpServlet {

    private final OpportunityService oppService = new OpportunityService();

    /**
     * GET /opportunity/create   → show create form
     * GET /opportunity/edit?id= → show edit form pre-filled
     * GET /opportunity/delete?id= → delete and redirect
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path  = req.getPathInfo();   // e.g. "/create", "/edit", "/delete"
        int orgId    = SessionUtil.getOrgId(req);

        if ("/create".equals(path)) {
            // Show blank create form
            req.getRequestDispatcher("/WEB-INF/views/opportunity/opportunityForm.jsp").forward(req, resp);

        } else if ("/edit".equals(path)) {
            int oppId = Integer.parseInt(req.getParameter("id"));
            Opportunity opp = oppService.getById(oppId);

            if (opp == null || opp.getOrgId() != orgId) {
                resp.sendRedirect(req.getContextPath() + "/org/dashboard");
                return;
            }
            req.setAttribute("opp", opp);
            req.setAttribute("editMode", true);
            req.getRequestDispatcher("/WEB-INF/views/opportunity/opportunityForm.jsp").forward(req, resp);

        } else if ("/delete".equals(path)) {
            int oppId = Integer.parseInt(req.getParameter("id"));
            oppService.delete(oppId, orgId);
            resp.sendRedirect(req.getContextPath() + "/org/dashboard?msg=deleted");

        } else {
            resp.sendRedirect(req.getContextPath() + "/org/dashboard");
        }
    }

    /**
     * POST /opportunity/create → save new opportunity
     * POST /opportunity/edit   → update existing opportunity
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        int orgId   = SessionUtil.getOrgId(req);

        String title       = req.getParameter("title");
        String description = req.getParameter("description");
        String location    = req.getParameter("location");
        String category    = req.getParameter("category");
        String slots       = req.getParameter("slots");
        String deadline    = req.getParameter("deadline");

        if ("/create".equals(path)) {
            String error = oppService.create(orgId, title, description, location, category, slots, deadline);

            if (error != null) {
                req.setAttribute("error", error);
                req.getRequestDispatcher("//views/organization/postOpportunity.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/org/dashboard?msg=created");
            }

        } else if ("/edit".equals(path)) {
            int oppId  = Integer.parseInt(req.getParameter("oppId"));
            String status = req.getParameter("status");

            String error = oppService.update(oppId, orgId, title, description, location, category, slots, deadline, status);

            if (error != null) {
                Opportunity opp = oppService.getById(oppId);
                req.setAttribute("opp", opp);
                req.setAttribute("editMode", true);
                req.setAttribute("error", error);
                req.getRequestDispatcher("//views/organization/postOpportunity.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/org/dashboard?msg=updated");
            }

        } else {
            resp.sendRedirect(req.getContextPath() + "/org/dashboard");
        }
    }
}