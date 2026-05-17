package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.dao.ApplicationDAO;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class ApplicationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        int applicationId =
                Integer.parseInt(
                        request.getParameter("applicationId")
                );

        String status =
                request.getParameter("status");

        ApplicationDAO dao =
                new ApplicationDAO();

        boolean updated =
                dao.updateApplicationStatus(
                        applicationId,
                        status
                );

        if (updated) {

            response.getWriter().println(
                    "Application Status Updated Successfully!"
            );

        } else {

            response.getWriter().println(
                    "Failed to Update Application!"
            );

        }
    }
}