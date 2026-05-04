package com.volunteermanagementsystem.filter;

import com.volunteermanagementsystem.util.SessionUtil;
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
        String path = requestURI.substring(contextPath.length());

        // ── Allow public pages without login ──
        boolean isPublicPage =
                path.endsWith("/login.jsp")                          ||
                        path.endsWith("/index.jsp")                          ||
                        path.contains("/volunteer/register.jsp")             ||
                        path.contains("/organization/register.jsp")           ||
                        path.contains("/extra/about.jsp")                    ||
                        path.contains("/extra/contact.jsp")                  ||
                        path.equals("/LoginServlet")                         ||
                        path.equals("/org/register")                         ||
                        path.equals("/org/login")                            ||
                        path.contains(".css")                                ||
                        path.contains(".js")                                 ||
                        path.contains(".png")                                ||
                        path.contains(".jpg");

        if (isPublicPage) {
            chain.doFilter(request, response);
            return;
        }

        // Organization routes use organization session keys (not userId/role).
        if (path.startsWith("/org/")) {
            if (!SessionUtil.isOrgLoggedIn(req)) {
                res.sendRedirect(contextPath + "/org/login");
                return;
            }
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
            res.sendRedirect(contextPath + "/AdminServlet?action=dashboard");
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