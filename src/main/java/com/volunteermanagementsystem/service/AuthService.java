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
     * Checks if an email is already registered
     * Used during registration to prevent duplicates
     */
    public boolean isEmailTaken(String email) {
        return userDAO.emailExists(email);
    }
}