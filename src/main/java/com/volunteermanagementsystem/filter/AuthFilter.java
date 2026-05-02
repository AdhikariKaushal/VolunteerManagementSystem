package com.volunteermanagementsystem.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * AuthFilter - Protects pages from unauthorized access
 * Author: Kaushal Adhikari
 * Group: The GOAT
 */
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req     = (HttpServletRequest) request;
        HttpServletResponse res     = (HttpServletResponse) response;
        HttpSession         session = req.getSession(false);

        String requestURI  = req.getRequestURI();
        String contextPath = req.getContextPath();

        // ── Allow public pages without login ──
        boolean isPublicPage =
                requestURI.endsWith("login.jsp")                        ||
                        requestURI.endsWith("index.jsp")                        ||
                        requestURI.contains("/volunteer/register.jsp")          ||
                        requestURI.contains("/organization/register.jsp")       ||
                        requestURI.contains("/extra/about.jsp")                 ||
                        requestURI.contains("/extra/contact.jsp")               ||
                        requestURI.contains("/LoginServlet")                    ||
                        requestURI.contains("/RegisterVolunteerServlet")        ||
                        requestURI.contains("/RegisterOrganizationServlet")     ||
                        requestURI.contains(".css")                             ||
                        requestURI.contains(".js")                              ||
                        requestURI.contains(".png")                             ||
                        requestURI.contains(".jpg");

        if (isPublicPage) {
            chain.doFilter(request, response);
            return;
        }

        // ── If not logged in → redirect to login ──
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        // ── Role based access control ──
        String role = (String) session.getAttribute("role");

        // Admin trying to access volunteer or org pages
        if ("admin".equals(role) &&
                (requestURI.contains("/volunteer/") || requestURI.contains("/organization/"))) {
            res.sendRedirect(contextPath + "/views/admin/dashboard.jsp");
            return;
        }

        // Volunteer trying to access admin or org pages
        if ("volunteer".equals(role) &&
                (requestURI.contains("/admin/") || requestURI.contains("/organization/"))) {
            res.sendRedirect(contextPath + "/views/volunteer/dashboard.jsp");
            return;
        }

        // Organization trying to access admin or volunteer pages
        if ("organization".equals(role) &&
                (requestURI.contains("/admin/") || requestURI.contains("/volunteer/"))) {
            res.sendRedirect(contextPath + "/views/organization/dashboard.jsp");
            return;
        }

        // ── All checks passed → allow through ──
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}