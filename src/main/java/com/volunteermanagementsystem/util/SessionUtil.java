package com.volunteermanagementsystem.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * SessionUtil - Handles session management
 * Author: Kaushal Adhikari
 * Group: The GOAT
 */
public class SessionUtil {

    // Private constructor — utility class
    private SessionUtil() {}

    /**
     * Creates a session and stores user details after login
     */
    public static void createSession(HttpServletRequest request, int userId, String email, String role) {
        HttpSession session = request.getSession(true);
        session.setAttribute("userId", userId);
        session.setAttribute("email", email);
        session.setAttribute("role", role);
        session.setMaxInactiveInterval(30 * 60); // session expires after 30 minutes
    }

    /**
     * Returns the logged in user's role from session
     */
    public static String getUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute("role");
        }
        return null;
    }

    /**
     * Returns the logged in user's ID from session
     */
    public static int getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            return (int) session.getAttribute("userId");
        }
        return -1;
    }

    /**
     * Returns the logged in user's email from session
     */
    public static String getUserEmail(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute("email");
        }
        return null;
    }

    /**
     * Checks if a user is currently logged in
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("userId") != null;
    }

    /**
     * Checks if the logged in user has a specific role
     */
    public static boolean hasRole(HttpServletRequest request, String role) {
        return role.equals(getUserRole(request));
    }

    /**
     * Destroys the session on logout
     */
    public static void destroySession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}