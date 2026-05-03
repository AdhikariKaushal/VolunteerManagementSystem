package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.model.User;
import com.volunteermanagementsystem.service.AdminService;
import com.volunteermanagementsystem.util.SessionUtil;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
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
                request.getRequestDispatcher("/views/admin/manageUsers.jsp").forward(request, response);
                break;

            case "pendingUsers":
                List<User> pendingUsers = adminService.getPendingUsers();
                request.setAttribute("pendingUsers", pendingUsers);
                request.getRequestDispatcher("/views/admin/manageUsers.jsp").forward(request, response);
                break;

            case "reports":
                request.setAttribute("totalVolunteers",    adminService.getTotalVolunteers());
                request.setAttribute("totalOrganizations", adminService.getTotalOrganizations());
                request.setAttribute("totalOpportunities", adminService.getTotalOpportunities());
                request.setAttribute("totalApplications",  adminService.getTotalApplications());
                request.getRequestDispatcher("/views/admin/reports.jsp").forward(request, response);
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
                adminService.deactivateUser(userId);
                response.sendRedirect(request.getContextPath() + "/AdminServlet?action=manageUsers&message=User+deactivated+successfully");
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/AdminServlet?action=dashboard");
        }
    }
}