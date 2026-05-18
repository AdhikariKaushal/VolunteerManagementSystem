package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.dao.UserDAO;
import com.volunteermanagementsystem.dao.VolunteerDAO;
import com.volunteermanagementsystem.model.User;
import com.volunteermanagementsystem.model.Volunteer;
import com.volunteermanagementsystem.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;

public class RegisterVolunteerServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private VolunteerDAO volunteerDAO = new VolunteerDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        String phone    = request.getParameter("phone");
        String address  = request.getParameter("address");
        String skills   = request.getParameter("skills");
        String bio      = request.getParameter("bio");
        String gender   = request.getParameter("gender");
        String dobStr   = request.getParameter("dateOfBirth");

        // Simple validation
        if (fullName == null || email == null || password == null
                || fullName.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Full name, email and password are required.");
            request.getRequestDispatcher("/views/volunteer/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email is already registered. Please login.");
            request.getRequestDispatcher("/views/volunteer/register.jsp").forward(request, response);
            return;
        }

        // 1. Create and insert User
        User user = new User();
        user.setEmail(email);
        user.setPassword(PasswordUtil.hashPassword(password));
        user.setRole("volunteer");
        user.setStatus("active");

        int userId = userDAO.insertUser(user);

        if (userId > 0) {
            // 2. Create and insert Volunteer Profile with all fields
            Volunteer volunteer = new Volunteer();
            volunteer.setUserId(userId);
            volunteer.setFullName(fullName.trim());
            volunteer.setEmail(email.trim());
            volunteer.setPhone(phone != null ? phone.trim() : "");
            volunteer.setAddress(address != null ? address.trim() : "");
            volunteer.setSkills(skills != null ? skills.trim() : "");
            volunteer.setBio(bio != null ? bio.trim() : "");
            volunteer.setGender(gender != null ? gender : "");

            // Parse date of birth if provided
            if (dobStr != null && !dobStr.trim().isEmpty()) {
                try {
                    volunteer.setDateOfBirth(LocalDate.parse(dobStr));
                } catch (Exception e) {
                    volunteer.setDateOfBirth(null);
                }
            } else {
                volunteer.setDateOfBirth(null);
            }

            try {
                volunteerDAO.registerVolunteer(volunteer);
                response.sendRedirect(request.getContextPath() + "/login.jsp?registered=true");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error creating volunteer profile.");
                request.getRequestDispatcher("/views/volunteer/register.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Error creating user account.");
            request.getRequestDispatcher("/views/volunteer/register.jsp").forward(request, response);
        }
    }
}
