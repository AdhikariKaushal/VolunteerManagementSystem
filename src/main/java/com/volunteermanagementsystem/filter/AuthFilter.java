package com.volunteermanagementsystem.filter;

import com.volunteermanagementsystem.util.SessionUtil;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter(urlPatterns = {"/org/*", "/opportunity/*", "/application/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();

        boolean isPublic = uri.endsWith("/org/login")
                || uri.endsWith("/org/register")
                || uri.endsWith("/orgLogin.jsp")
                || uri.endsWith("/orgRegister.jsp");

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        if (!SessionUtil.isOrgLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/org/login");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}