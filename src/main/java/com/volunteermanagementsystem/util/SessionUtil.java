package com.volunteermanagementsystem.util;

import com.volunteermanagementsystem.model.Organization;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * SessionUtil - Handles session management for ALL roles
 * Author: Kaushal Adhikari + Sneha
 * Group: The GOAT
 */
public class SessionUtil {

    private SessionUtil() {}

    // Organization session keys (Sneha)
    public static final String ORG_KEY      = "loggedOrg";
    public static final String ORG_ID_KEY   = "loggedOrgId";
    public static final String ORG_NAME_KEY = "loggedOrgName";

    // KAUSHAL'S METHODS
    public static void createSession(HttpServletRequest request, int userId, String email, String role) {
        HttpSession session = request.getSession(true);
        session.setAttribute("userId", userId);
        session.setAttribute("email", email);
        session.setAttribute("role", role);
        session.setMaxInactiveInterval(30 * 60);
    }

    public static String getUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) return (String) session.getAttribute("role");
        return null;
    }

    public static int getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null)
            return (int) session.getAttribute("userId");
        return -1;
    }

    public static String getUserEmail(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) return (String) session.getAttribute("email");
        return null;
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("userId") != null;
    }

    public static boolean hasRole(HttpServletRequest request, String role) {
        return role.equals(getUserRole(request));
    }

    public static void destroySession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
    }

    // SNEHA'S METHODS
    public static void setOrganization(HttpServletRequest request, Organization org) {
        HttpSession session = request.getSession();
        session.setAttribute(ORG_KEY,      org);
        session.setAttribute(ORG_ID_KEY,   org.getOrgId());
        session.setAttribute(ORG_NAME_KEY, org.getOrgName());
    }

    public static Organization getOrganization(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (Organization) session.getAttribute(ORG_KEY);
    }

    public static int getOrgId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return -1;
        Object id = session.getAttribute(ORG_ID_KEY);
        return (id != null) ? (int) id : -1;
    }

    public static boolean isOrgLoggedIn(HttpServletRequest request) {
        return getOrganization(request) != null;
    }

    public static void invalidate(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
    }
}