<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.volunteermanagementsystem.util.SessionUtil" %>
<%
    // Security check — only admin can access
    if (!SessionUtil.hasRole(request, "admin")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String adminName = (String) session.getAttribute("email");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | VolunteerBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

<!-- ── Sidebar ── -->
<div class="admin-wrapper">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <span class="brand-icon">🤝</span>
            <span class="brand-name">VolunteerBridge</span>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard" class="nav-item active">
                <span class="nav-icon">📊</span> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=manageUsers" class="nav-item">
                <span class="nav-icon">👥</span> Manage Users
            </a>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=manageUsers&filter=pending" class="nav-item">
                <span class="nav-icon">⏳</span> Pending Approvals
            </a>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=reports" class="nav-item">
                <span class="nav-icon">📈</span> Reports
            </a>
        </nav>
        <div class="sidebar-footer">
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-item logout">
                <span class="nav-icon">🚪</span> Logout
            </a>
        </div>
    </aside>

    <!-- ── Main Content ── -->
    <main class="main-content">

        <!-- Header -->
        <div class="page-header">
            <div>
                <h1>Admin Dashboard</h1>
                <p class="page-subtitle">Welcome back, <%= adminName %>!</p>
            </div>
        </div>

        <!-- Success / Error Messages -->
            <% if (request.getParameter("message") != null) { %>
        <div class="alert alert-success"><%= request.getParameter("message") %></div>
            <% } %>

        <!-- ── Summary Cards ── -->
        <div class="stats-grid">
            <div class="stat-card stat-green">
                <div class="stat-icon">🙋</div>
                <div class="stat-info">
                    <div class="stat-number"><%= request.getAttribute("totalVolunteers") != null ? request.getAttribute("totalVolunteers") : 0 %></div>
                    <div class="stat-label">Total Volunteers</div>
                </div>
            </div>
            <div class="stat-card stat-blue">
                <div class="stat-icon">🏢</div>
                <div class="stat-info">
                    <div class="stat-number"><%= request.getAttribute("totalOrganizations") != null ? request.getAttribute("totalOrganizations") : 0 %></div>
                    <div class="stat-label">Organizations</div>
                </div>
            </div>
            <div class="stat-card stat-amber">
                <div class="stat-icon">📋</div>
                <div class="stat-info">
                    <div class="stat-number"><%= request.getAttribute("totalOpportunities") != null ? request.getAttribute("totalOpportunities") : 0 %></div>
                    <div class="stat-label">Opportunities</div>
                </div>
            </div>
            <div class="stat-card stat-purple">
                <div class="stat-icon">📝</div>
                <div class="stat-info">
                    <div class="stat-number"><%= request.getAttribute("totalApplications") != null ? request.getAttribute("totalApplications") : 0 %></div>
                    <div class="stat-label">Applications</div>
                </div>
            </div>
        </div>

        <!-- ── Quick Actions ── -->
        <div class="section-title">Quick Actions</div>
        <div class="quick-actions">
            <a href="${pageContext.request.contextPath}/AdminServlet?action=manageUsers" class="action-card">
                <span class="action-icon">👥</span>
                <span class="action-label">Manage Us