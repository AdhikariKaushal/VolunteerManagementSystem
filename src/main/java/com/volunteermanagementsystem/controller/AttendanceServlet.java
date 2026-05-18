package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.service.AttendaceService;

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

    private final AttendaceService attendaceService =
            new AttendaceService();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String action =
                request.getParameter("action");

        if (action == null) {
            action = "";
        }

        if (action.equals("viewByOpportunity")) {

            int oppId =
                    Integer.parseInt(
                            request.getParameter("opportunityId")
                    );

            request.setAttribute(
                    "attendanceList",
                    attendaceService.getAttendanceByOpportunity(oppId)
            );

            request.setAttribute(
                    "opportunityId",
                    oppId
            );

            request.getRequestDispatcher(
                    "/views/organization/attendance.jsp"
            ).forward(request, response);

        } else {

            response.sendRedirect(
                    request.getContextPath() +
                            "/views/organization/attendance.jsp"
            );
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action =
                request.getParameter("action");

        if (action == null) {
            action = "";
        }

        if (action.equals("log")) {

            try {

                int appId =
                        Integer.parseInt(
                                request.getParameter("applicationId")
                        );

                int volId =
                        Integer.parseInt(
                                request.getParameter("volunteerId")
                        );

                int oppId =
                        Integer.parseInt(
                                request.getParameter("opportunityId")
                        );

                String status =
                        request.getParameter("status");

                double hours =
                        Double.parseDouble(
                                request.getParameter("hoursLogged")
                        );

                String error =
                        attendaceService.logAttendance(
                                appId,
                                volId,
                                oppId,
                                status,
                                hours
                        );

                if (error == null) {

                    response.getWriter().println(
                            "Attendance Logged Successfully!"
                    );

                } else {

                    response.getWriter().println(
                            error
                    );
                }

            } catch (Exception e) {

                e.printStackTrace();

                response.getWriter().println(
                        "Failed to Log Attendance!"
                );
            }

        } else {

            response.getWriter().println(
                    "Invalid Action"
            );
        }
    }
}