package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.dao.VolunteerDAO;
import com.volunteermanagementsystem.model.Volunteer;
import com.volunteermanagementsystem.model.Wishlist;
import com.volunteermanagementsystem.util.SessionUtil;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * VolunteerServlet - Handles all volunteer actions
 * Author: Darpan Ghimire
 */
@WebServlet("/VolunteerServlet")
public class VolunteerServlet extends HttpServlet {

    private VolunteerDAO volunteerDAO = new VolunteerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!SessionUtil.hasRole(request, "volunteer")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        int userId = SessionUtil.getUserId(request);

        try {
            Volunteer volunteer = volunteerDAO.getVolunteerByUserId(userId);

            // If no profile yet, send to register page (except when registering)
            if (volunteer == null && !action.equals("showRegister")) {
                response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=showRegister");
                return;
            }

            switch (action) {
                case "showRegister":
                    request.getRequestDispatcher("/views/volunteer/register.jsp").forward(request, response);
                    break;

                case "dashboard":
                    int totalHours = volunteerDAO.getTotalHours(volunteer.getId());
                    List<Object[]> appHistory = volunteerDAO.getApplicationHistory(volunteer.getId());
                    request.setAttribute("volunteer", volunteer);
                    request.setAttribute("totalHours", totalHours);
                    request.setAttribute("recentApplications", appHistory);
                    request.getRequestDispatcher("/views/volunteer/dashboard.jsp").forward(request, response);
                    break;

                case "profile":
                    request.setAttribute("volunteer", volunteer);
                    request.getRequestDispatcher("/views/volunteer/profile.jsp").forward(request, response);
                    break;

                case "browseOpportunities":
                    String keyword = request.getParameter("keyword");
                    List<Object[]> opportunities;
                    if (keyword != null && !keyword.trim().isEmpty()) {
                        opportunities = volunteerDAO.searchOpportunities(keyword.trim());
                        request.setAttribute("keyword", keyword.trim());
                    } else {
                        opportunities = volunteerDAO.getAllOpenOpportunities();
                    }
                    request.setAttribute("volunteer", volunteer);
                    request.setAttribute("opportunities", opportunities);
                    request.getRequestDispatcher("/views/volunteer/browseOpportunities.jsp").forward(request, response);
                    break;

                case "applicationHistory":
                    List<Object[]> history = volunteerDAO.getApplicationHistory(volunteer.getId());
                    request.setAttribute("volunteer", volunteer);
                    request.setAttribute("applications", history);
                    request.getRequestDispatcher("/views/volunteer/applicationHistory.jsp").forward(request, response);
                    break;

                case "wishlist":
                    List<Wishlist> wishlist = volunteerDAO.getWishlist(volunteer.getId());
                    request.setAttribute("volunteer", volunteer);
                    request.setAttribute("wishlist", wishlist);
                    request.getRequestDispatcher("/views/volunteer/wishlist.jsp").forward(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=dashboard");
            }

        } catch (Exception e) {
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!SessionUtil.hasRole(request, "volunteer")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "";
        int userId = SessionUtil.getUserId(request);

        try {
            switch (action) {
                case "register":
                    handleRegister(request, response, userId);
                    break;
                case "updateProfile":
                    handleUpdateProfile(request, response, userId);
                    break;
                case "applyOpportunity":
                    handleApply(request, response, userId);
                    break;
                case "addWishlist":
                    handleAddWishlist(request, response, userId);
                    break;
                case "removeWishlist":
                    handleRemoveWishlist(request, response, userId);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=dashboard");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Something went wrong: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response, int userId)
            throws Exception {
        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");
        String address  = request.getParameter("address");
        String skills   = request.getParameter("skills");
        String dob      = request.getParameter("dateOfBirth");
        String gender   = request.getParameter("gender");
        String bio      = request.getParameter("bio");

        if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Full name and email are required.");
            request.getRequestDispatcher("/views/volunteer/register.jsp").forward(request, response);
            return;
        }

        Volunteer v = new Volunteer();
        v.setUserId(userId);
        v.setFullName(fullName.trim());
        v.setEmail(email.trim());
        v.setPhone(phone != null ? phone.trim() : "");
        v.setAddress(address != null ? address.trim() : "");
        v.setSkills(skills != null ? skills.trim() : "");
        v.setGender(gender != null ? gender.trim() : "");
        v.setBio(bio != null ? bio.trim() : "");
        if (dob != null && !dob.trim().isEmpty()) {
            v.setDateOfBirth(LocalDate.parse(dob.trim()));
        }

        int newId = volunteerDAO.registerVolunteer(v);
        if (newId > 0) {
            response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=dashboard&registered=true");
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/views/volunteer/register.jsp").forward(request, response);
        }
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, int userId)
            throws Exception {
        Volunteer v = volunteerDAO.getVolunteerByUserId(userId);
        if (v == null) {
            response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=showRegister");
            return;
        }
        v.setFullName(request.getParameter("fullName").trim());
        v.setPhone(request.getParameter("phone") != null ? request.getParameter("phone").trim() : "");
        v.setAddress(request.getParameter("address") != null ? request.getParameter("address").trim() : "");
        v.setSkills(request.getParameter("skills") != null ? request.getParameter("skills").trim() : "");
        v.setGender(request.getParameter("gender") != null ? request.getParameter("gender").trim() : "");
        v.setBio(request.getParameter("bio") != null ? request.getParameter("bio").trim() : "");
        String dob = request.getParameter("dateOfBirth");
        if (dob != null && !dob.trim().isEmpty()) {
            v.setDateOfBirth(LocalDate.parse(dob.trim()));
        }
        boolean updated = volunteerDAO.updateVolunteer(v);
        if (updated) {
            response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=profile&updated=true");
        } else {
            request.setAttribute("error", "Update failed. Please try again.");
            request.setAttribute("volunteer", v);
            request.getRequestDispatcher("/views/volunteer/profile.jsp").forward(request, response);
        }
    }

    private void handleApply(HttpServletRequest request, HttpServletResponse response, int userId)
            throws Exception {
        Volunteer v = volunteerDAO.getVolunteerByUserId(userId);
        if (v == null) {
            response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=showRegister");
            return;
        }
        String oppIdStr = request.getParameter("opportunityId");
        if (oppIdStr == null || oppIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=browseOpportunities&error=invalid");
            return;
        }
        int oppId = Integer.parseInt(oppIdStr.trim());
        boolean applied = volunteerDAO.applyForOpportunity(v.getId(), oppId);
        if (applied) {
            response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=applicationHistory&applied=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=browseOpportunities&alreadyApplied=true");
        }
    }

    private void handleAddWishlist(HttpServletRequest request, HttpServletResponse response, int userId)
            throws Exception {
        Volunteer v = volunteerDAO.getVolunteerByUserId(userId);
        if (v == null) { response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=showRegister"); return; }
        int oppId = Integer.parseInt(request.getParameter("opportunityId").trim());
        volunteerDAO.addToWishlist(v.getId(), oppId);
        response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=wishlist&added=true");
    }

    private void handleRemoveWishlist(HttpServletRequest request, HttpServletResponse response, int userId)
            throws Exception {
        Volunteer v = volunteerDAO.getVolunteerByUserId(userId);
        if (v == null) { response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=showRegister"); return; }
        int oppId = Integer.parseInt(request.getParameter("opportunityId").trim());
        volunteerDAO.removeFromWishlist(v.getId(), oppId);
        response.sendRedirect(request.getContextPath() + "/VolunteerServlet?action=wishlist&removed=true");
    }
}