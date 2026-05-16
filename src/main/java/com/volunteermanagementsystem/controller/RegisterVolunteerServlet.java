package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.dao.UserDAO;
import com.volunteermanagementsystem.dao.VolunteerDAO;
import com.volunteermanagementsystem.model.User;
import com.volunteermanagementsystem.model.Volunteer;
import com.volunteermanagementsystem.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/RegisterVolunteerServlet")
public class RegisterVolunteerServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private VolunteerDAO volunteerDAO = new VolunteerDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        // Simple validation
        if (fullName == null || email == null || password == null || fullName.trim().isEmpty() || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
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
            // 2. Create and insert Volunteer Profile
            Volunteer volunteer = new Volunteer();
            volunteer.setUserId(userId);
            volunteer.setFullName(fullName);
            volunteer.setEmail(email);
            volunteer.setPhone(phone != null ? phone : "");
            volunteer.setAddress(""); 
            volunteer.setSkills("");
            volunteer.setGender("");
            volunteer.setBio("");
            volunteer.setDateOfBirth(null);

            try {
                volunteerDAO.registerVolunteer(volunteer);
                // Success! Redirect to login
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
