package com.volunteermanagementsystem.service;

import com.volunteermanagementsystem.dao.UserDAO;
import com.volunteermanagementsystem.model.User;
import com.volunteermanagementsystem.util.PasswordUtil;

/**
 * AuthService - Handles authentication business logic
 * Author: Kaushal Adhikari
 * Group: The GOAT
 */
public class AuthService {

    private UserDAO userDAO = new UserDAO();

    /**
     * Validates login credentials
     * Returns the User object if login is successful, null if not
     */
    public User login(String email, String password) {

        // Step 1 — check if email exists
        User user = userDAO.getUserByEmail(email);
        if (user == null) {
            return null; // email not found
        }

        // Step 2 — check if password matches
        if (!PasswordUtil.verifyPassword(password, user.getPassword())) {
            return null; // wrong password
        }

        // Step 3 — check if account is active
        String status = user.getStatus() == null ? "" : user.getStatus().trim();
        if (!status.equalsIgnoreCase("active")) {
            return null; // account pending or deactivated
        }

        return user; // login successful
    }

    /**
     * Returns a specific login error message (wrong password, pending, deactivated, etc.)
     */
    public String getLoginError(String email, String password) {
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            return "Email and password are required.";
        }

        User user = userDAO.getUserByEmail(email.trim());
        if (user == null) {
            return "No account found with this email.";
        }
        if (!PasswordUtil.verifyPassword(password, user.getPassword())) {
            return "Incorrect password.";
        }

        String status = user.getStatus() == null ? "" : user.getStatus().trim();
        if ("pending".equalsIgnoreCase(status)) {
            return "Your account is awaiting admin approval.";
        }
        if ("deactivated".equalsIgnoreCase(status)) {
            return "Your account has been deactivated. Contact support if you need access restored.";
        }
        if (!"active".equalsIgnoreCase(status)) {
            return "Your account is not active. Contact support.";
        }
        return "Login failed. Please try again.";
    }

    /**
     * Checks if an email is already registered
     * Used during registration to prevent duplicates
     */
    public boolean isEmailTaken(String email) {
        return userDAO.emailExists(email);
    }
}