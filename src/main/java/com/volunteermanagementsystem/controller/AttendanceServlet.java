package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.service.AttendaceService;
import com.volunteermanagementsystem.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * AttendanceServlet
 * Author: Oshan
 * Group: The GOAT
 */
@WebServlet("/AttendanceServlet")
public class AttendanceServlet extends HttpServlet {

    private final AttendaceService attendaceService = new AttendaceService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        if (action.equals("viewByOpportunity")) {
            if (!SessionUtil.hasRole(request, "organization")) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            int oppId = Integer.parseInt(request.getParameter("opportunityId"));
            request.setAttribute("attendanceList", attendaceService.getAttendanceByOpportunity(oppId));
            request.setAttribute("opportunityId", oppId);
            request.getRequestDispatcher("/views/organization/attendance.jsp").forward(request, response);

        } else if (action.equals("myHistory")) {
            if (!SessionUtil.hasRole(request, "volunteer")) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
            int vid = (int) request.getSession().getAttribute("volunteerId");
            request.setAttribute("attendanceList", attendaceService.getAttendanceByVolunteer(vid));
            request.setAttribute("totalHours", attendaceService.getTotalHours(vid));
            request.getRequestDispatcher("/views/volunteer/applicationHistory.jsp").forward(request, response);

        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!SessionUtil.hasRole(request, "organization")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";

        if (action.equals("log")) {
            try {
                int appId     = Integer.parseInt(request.getParameter("applicationId"));
                int volId     = Integer.parseInt(request.getParameter("volunteerId"));
                int oppId     = Integer.parseInt(request.getParameter("opportunityId"));
                String status = request.getParameter("status");
                double hours  = Double.parseDouble(request.getParameter("hoursLogged"));

                String error = attendaceService.logAttendance(appId, volId, oppId, status, hours);
                if (error == null) {
                    response.sendRedirect(request.getContextPath() +
                            "/AttendanceServlet?action=viewByOpportunity&opportunityId=" + oppId + "&success=logged");
                } else {
                    request.setAttribute("error", error);
                    request.setAttribute("attendanceList", attendaceService.getAttendanceByOpportunity(oppId));
                    request.setAttribute("opportunityId", oppId);
                    request.getRequestDispatcher("/views/organization/attendance.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid input. Check all fields.");
                request.getRequestDispatcher("/views/organization/attendance.jsp").forward(request, response);
            }

        } else if (action.equals("update")) {
            try {
                int attId     = Integer.parseInt(request.getParameter("attendanceId"));
                int oppId     = Integer.parseInt(request.getParameter("opportunityId"));
                String status = request.getParameter("status");
                double hours  = Double.parseDouble(request.getParameter("hoursLogged"));

                String error = attendaceService.updateAttendance(attId, status, hours);
                response.sendRedirect(request.getContextPath() +
                        "/AttendanceServlet?action=viewByOpportunity&opportunityId=" + oppId +
                        (error == null ? "&success=updated" : ""));
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/OrganizationServlet?action=dashboard");
            }

        } else {
            response.sendRedirect(request.getContextPath() + "/OrganizationServlet?action=dashboard");
        }
    }
}