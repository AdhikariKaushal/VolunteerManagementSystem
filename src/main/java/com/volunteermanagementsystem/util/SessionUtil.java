package com.volunteermanagementsystem.util;

import com.volunteermanagementsystem.model.Organization;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;



public class SessionUtil {

    public static final String ORG_KEY      = "loggedOrg";
    public static final String ORG_ID_KEY   = "loggedOrgId";
    public static final String ORG_NAME_KEY = "loggedOrgName";

    /** Store logged-in org in session. */
    public static void setOrganization(HttpServletRequest request, Organization org) {
        HttpSession session = request.getSession();
        session.setAttribute(ORG_KEY,      org);
        session.setAttribute(ORG_ID_KEY,   org.getOrgId());
        session.setAttribute(ORG_NAME_KEY, org.getOrgName());
    }

    /** Get logged-in org from session. Returns null if not logged in. */
    public static Organization getOrganization(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (Organization) session.getAttribute(ORG_KEY);
    }

    /** Get org ID from session. Returns -1 if not found. */
    public static int getOrgId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return -1;
        Object id = session.getAttribute(ORG_ID_KEY);
        return (id != null) ? (int) id : -1;
    }

    /** Check if an org is currently logged in. */
    public static boolean isOrgLoggedIn(HttpServletRequest request) {
        return getOrganization(request) != null;
    }

    /** Invalidate session (logout). */
    public static void invalidate(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
    }
}