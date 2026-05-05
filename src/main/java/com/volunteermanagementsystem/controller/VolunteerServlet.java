package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.dao.VolunteerDAO;
import com.volunteermanagementsystem.model.Volunteer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/VolunteerServlet")
public class VolunteerServlet extends HttpServlet {
    private VolunteerDAO volunteerDAO = new VolunteerDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");

        try {
            Volunteer volunteer = volunteerDAO.getVolunteerByUserId(userId);
            if (volunteer == null) {
                 response.sendRedirect(request.getContextPath() + "/login.jsp");
                 return;
            }

            if ("addToWishlist".equals(action)) {
                int oppId = Integer.parseInt(request.getParameter("opportunityId"));
                volunteerDAO.addToWishlist(volunteer.getId(), oppId);
                response.sendRedirect(request.getContextPath() + "/views/volunteer/browseOpportunities.jsp?added=true");
            } else if ("removeFromWishlist".equals(action)) {
                int oppId = Integer.parseInt(request.getParameter("opportunityId"));
                volunteerDAO.removeFromWishlist(volunteer.getId(), oppId);
                response.sendRedirect(request.getContextPath() + "/views/volunteer/wishlist.jsp?removed=true");
            } else if ("updateProfile".equals(action)) {
                volunteer.setFullName(request.getParameter("fullName"));
                volunteer.setPhone(request.getParameter("phone"));
                volunteer.setAddress(request.getParameter("address"));
                volunteer.setSkills(request.getParameter("skills"));
                volunteer.setBio(request.getParameter("bio"));
                volunteerDAO.updateVolunteer(volunteer);
                response.sendRedirect(request.getContextPath() + "/views/volunteer/profile.jsp?updated=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/volunteer/dashboard.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/views/volunteer/dashboard.jsp?error=true");
        }
    }
}
