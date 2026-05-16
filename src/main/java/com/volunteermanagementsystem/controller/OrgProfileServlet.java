package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.model.Organization;
import com.volunteermanagementsystem.service.OrganizationService;
import com.volunteermanagementsystem.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

// NOTE: No @WebServlet annotation — registered in web.xml only to avoid duplicate mapping errors
public class OrgProfileServlet extends HttpServlet {

    private final OrganizationService orgService = new OrganizationService();

    /** Show profile page with current data pre-filled. */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int orgId = SessionUtil.getOrgId(req);
        Organization org = orgService.getById(orgId);

        req.setAttribute("org", org);
        // FIX: was "//views/organization/profile.jsp" (double slash — causes 404)
        req.getRequestDispatcher("/views/organization/profile.jsp").forward(req, resp);
    }

    /** Handle profile update form submission. */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int orgId = SessionUtil.getOrgId(req);

        String orgName     = req.getParameter("orgName");
        String orgType     = req.getParameter("orgType");
        String description = req.getParameter("description");
        String website     = req.getParameter("website");
        String phone       = req.getParameter("phone");
        String address     = req.getParameter("address");

        String error = orgService.updateProfile(orgId, orgName, orgType, description, website, phone, address);

        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("org", orgService.getById(orgId));
            // FIX: was "/WEB-INF/views/org/orgProfile.jsp" — wrong path, file is at /views/organization/profile.jsp
            req.getRequestDispatcher("/views/organization/profile.jsp").forward(req, resp);
        } else {
            // Refresh session with updated org data
            Organization updatedOrg = orgService.getById(orgId);
            SessionUtil.setOrganization(req, updatedOrg);
            resp.sendRedirect(req.getContextPath() + "/org/profile?success=updated");
        }
    }
}
