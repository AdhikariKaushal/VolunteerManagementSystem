package com.volunteermanagementsystem.controller;

import com.volunteermanagementsystem.dao.UserDAO;
import com.volunteermanagementsystem.dao.VolunteerDAO;
import com.volunteermanagementsystem.model.User;
import com.volunteermanagementsystem.model.Volunteer;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/RegisterVolunteerServlet")
public class RegisterVolunteerServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private VolunteerDAO volunteerDAO = new VolunteerDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String skills = request.getParameter("skills");
        String dob = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String bio = request.getParameter("bio");

        // Basic validation
        if (fullName == null || fullName.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Full name, email, and password are required.");
            request.getRequestDispatcher("/views/volunteer/register.jsp").forward(request, response);
            return;
        }

        try {
            // Check if email already exists
            if (userDAO.emailExists(email.trim())) {
                request.setAttribute("error", "An account with this email already exists.");
                request.getRequestDispatcher("/views/volunteer/register.jsp").forward(request, response);
                return;
            }

            // Create User account
            User newUser = new User();
            newUser.setEmail(email.trim());
            newUser.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            newUser.setRole("volunteer");
            newUser.setStatus("active");

            int userId = userDAO.insertUser(newUser);

            if (userId > 0) {
                // Create Volunteer Profile
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

                int volId = volunteerDAO.registerVolunteer(v);
                
                if (volId > 0) {
                    // Registration successful, redirect to login
                    response.sendRedirect(request.getContextPath() + "/login.jsp?message=Registration successful! Please log in.");
                } else {
                    request.setAttribute("error", "Failed to save volunteer profile. Please contact support.");
                    request.getRequestDispatcher("/views/volunteer/register.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Failed to create user account. Please try again.");
                request.getRequestDispatcher("/views/volunteer/register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/views/volunteer/register.jsp").forward(request, response);
        }
    }
}
