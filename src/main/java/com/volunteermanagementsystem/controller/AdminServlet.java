package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.model.Organization;
import com.volunteermanagementsystem.model.User;
import com.volunteermanagementsystem.service.AdminService;
import com.volunteermanagementsystem.util.SessionUtil;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

public class AdminServlet extends HttpServlet {

    private AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!SessionUtil.hasRole(request, "admin")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {

            case "dashboard":
                request.setAttribute("totalVolunteers",    adminService.getTotalVolunteers());
                request.setAttribute("totalOrganizations", adminService.getTotalOrganizations());
                request.setAttribute("totalOpportunities", adminService.getTotalOpportunities());
                request.setAttribute("totalApplications",  adminService.getTotalApplications());
                request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
                break;

            case "manageUsers":
                List<User> allUsers = adminService.getAllUsers();
                request.setAttribute("users", allUsers);
                request.setAttribute("viewMode", "manageUsers");
                request.getRequestDispatcher("/views/admin/manageUsers.jsp").forward(request, response);
                break;

            case "pendingUsers":
                List<User> pendingUsers = adminService.getPendingUsers();
                List<Organization> pendingOrganizations = adminService.getPendingOrganizations();
                request.setAttribute("pendingUsers", pendingUsers);
                request.setAttribute("pendingOrganizations", pendingOrganizations);
                request.setAttribute("viewMode", "pendingUsers");
                request.getRequestDispatcher("/views/admin/manageUsers.jsp").forward(request, response);
                break;

            case "reports":
                request.setAttribute("totalVolunteers",    adminService.getTotalVolunteers());
                request.setAttribute("totalOrganizations", adminService.getTotalOrganizations());
                request.setAttribute("totalOpportunities", adminService.getTotalOpportunities());
                request.setAttribute("totalApplications",  adminService.getTotalApplications());
                request.getRequestDispatcher("/views/admin/reports.jsp").forward(request, response);
                break;

            case "manageOpportunities":
                request.setAttribute("opportunities", adminService.getAllOpportunities());
                request.getRequestDispatcher("/views/admin/manageOpportunities.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/views/admin/dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!SessionUtil.hasRole(request, "admin")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/AdminServlet?action=dashboard");
            return;
        }

        switch (action) {

            case "approveUser": {
                int userId = Integer.parseInt(request.getParameter("userId"));
                adminService.approveUser(userId);
                response.sendRedirect(request.getContextPath() + "/AdminServlet?action=manageUsers&message=User+approved+successfully");
                break;
            }

            case "rejectUser": {
                int userId = Integer.parseInt(request.getParameter("userId"));
                adminService.rejectUser(userId);
                response.sendRedirect(request.getContextPath() + "/AdminServlet?action=manageUsers&message=User+rejected+successfully");
                break;
            }

            case "deactivateUser": {
                int userId = Integer.parseInt(request.getParameter("userId"));
                int adminId = SessionUtil.getUserId(request);
                String deactivateError = adminService.deactivateUser(userId, adminId);
                if (deactivateError != null) {
                    redirectManageUsers(response, request, "error", deactivateError);
                } else {
                    redirectManageUsers(response, request, "message", "User deactivated successfully. They can no longer sign in.");
                }
                break;
            }

            case "activateUser": {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String activateError = adminService.activateUser(userId);
                if (activateError != null) {
                    redirectManageUsers(response, request, "error", activateError);
                } else {
                    redirectManageUsers(response, request, "message", "User activated successfully. They can sign in again.");
                }
                break;
            }

            case "deleteUser": {
                int userId = Integer.parseInt(request.getParameter("userId"));
                int adminId = SessionUtil.getUserId(request);
                String deleteError = adminService.deleteUser(userId, adminId);
                if (deleteError != null) {
                    redirectManageUsers(response, request, "error", deleteError);
                } else {
                    redirectManageUsers(response, request, "message", "User deleted permanently.");
                }
                break;
            }

            case "approveOrganization": {
                int orgId = Integer.parseInt(request.getParameter("orgId"));
                adminService.approveOrganization(orgId);
                response.sendRedirect(request.getContextPath() + "/AdminServlet?action=pendingUsers&message=Organization+approved+successfully");
                break;
            }

            case "rejectOrganization": {
                int orgId = Integer.parseInt(request.getParameter("orgId"));
                adminService.rejectOrganization(orgId);
                response.sendRedirect(request.getContextPath() + "/AdminServlet?action=pendingUsers&message=Organization+rejected+successfully");
                break;
            }

            case "flagOpportunity": {
                int oppId = Integer.parseInt(request.getParameter("oppId"));
                String error = adminService.flagOpportunity(oppId);
                if (error != null) {
                    redirectManageOpportunities(response, request, "error", error);
                } else {
                    redirectManageOpportunities(response, request, "message", "Opportunity flagged successfully.");
                }
                break;
            }

            case "unflagOpportunity": {
                int oppId = Integer.parseInt(request.getParameter("oppId"));
                String error = adminService.unflagOpportunity(oppId);
                if (error != null) {
                    redirectManageOpportunities(response, request, "error", error);
                } else {
                    redirectManageOpportunities(response, request, "message", "Opportunity unflagged successfully.");
                }
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/AdminServlet?action=dashboard");
        }
    }

    private void redirectManageUsers(HttpServletResponse response, HttpServletRequest request,
                                     String param, String text) throws IOException {
        String encoded = URLEncoder.encode(text, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath()
                + "/AdminServlet?action=manageUsers&" + param + "=" + encoded);
    }

    private void redirectManageOpportunities(HttpServletResponse response, HttpServletRequest request,
                                     String param, String text) throws IOException {
        String encoded = URLEncoder.encode(text, StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath()
                + "/AdminServlet?action=manageOpportunities&" + param + "=" + encoded);
    }
}