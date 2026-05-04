<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.volunteermanagementsystem.util.SessionUtil" %>
<%
    if (session == null || session.getAttribute("role") == null ||
            !session.getAttribute("role").equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String adminName = (String) session.getAttribute("email");
    int totalVolunteers    = request.getAttribute("totalVolunteers")    != null ? (int) request.getAttribute("totalVolunteers")    : 0;
    int totalOrganizations = request.getAttribute("totalOrganizations") != null ? (int) request.getAttribute("totalOrganizations") : 0;
    int totalOpportunities = request.getAttribute("totalOpportunities") != null ? (int) request.getAttribute("totalOpportunities") : 0;
    int totalApplications  = request.getAttribute("totalApplications")  != null ? (int) request.getAttribute("totalApplications")  : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | VolunteerBridge</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f9; display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar {
            width: 240px; background: #1a1a2e; color: #fff;
            display: flex; flex-direction: column;
            position: fixed; top: 0; left: 0; height: 100vh;
        }
        .sidebar-brand {
            display: flex; align-items: center; gap: 10px;
            padding: 24px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            font-size: 16px; font-weight: 700;
        }
        .sidebar-nav { flex: 1; padding: 16px 0; display: flex; flex-direction: column; gap: 4px; }
        .nav-item {
            display: flex; align-items: center; gap: 12px;
            padding: 12px 20px; color: rgba(255,255,255,0.7);
            text-decoration: none; font-size: 14px; transition: all 0.2s;
        }
        .nav-item:hover, .nav-item.active { background: rgba(255,255,255,0.08); color: #fff; }
        .nav-item.active { border-left: 3px solid #1a6b3c; }
        .nav-item.logout { color: #f87171; }
        .sidebar-footer { padding: 16px 0; border-top: 1px solid rgba(255,255,255,0.08); }

        /* Main */
        .main-content { margin-left: 240px; flex: 1; padding: 32px; background: #f4f6f9; min-height: 100vh; }
        .page-header { margin-bottom: 28px; }
        .page-header h1 { font-size: 24px; font-weight: 700; color: #1a1a1a; }
        .page-subtitle { font-size: 14px; color: #777; margin-top: 4px; }

        /* Stats */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 36px; }
        .stat-card {
            background: #fff; border-radius: 14px; padding: 24px;
            display: flex; align-items: center; gap: 16px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06); border-left: 4px solid transparent;
        }
        .stat-green  { border-left-color: #1a6b3c; }
        .stat-blue   { border-left-color: #185fa5; }
        .stat-amber  { border-left-color: #ba7517; }
        .stat-purple { border-left-color: #534ab7; }
        .stat-icon { font-size: 32px; }
        .stat-number { font-size: 28px; font-weight: 700; color: #1a1a1a; }
        .stat-label { font-size: 13px; color: #777; margin-top: 2px; }

        /* Quick Actions */
        .section-title { font-size: 16px; font-weight: 600; color: #1a1a1a; margin-bottom: 16px; }
        .quick-actions { display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 16px; }
        .action-card {
            background: #fff; border-radius: 12px; padding: 24px 16px;
            display: flex; flex-direction: column; align-items: center; gap: 10px;
            text-decoration: none; color: #1a1a1a;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06); transition: transform 0.2s;
        }
        .action-card:hover { transform: translateY(-3px); }
        .action-icon { font-size: 28px; }
        .action-label { font-size: 13px; font-weight: 500; text-align: center; }
        .action-logout { color: #a32d2d; }

        .alert-success {
            background: #e8f5ee; color: #085041; border: 1px solid #b7dfca;
            padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 14px;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand">🤝 VolunteerBridge</div>
    <nav class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/AdminServlet?action=dashboard" class="nav-item active">📊 Dashboard</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=manageUsers" class="nav-item">👥 Manage Users</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=pendingUsers" class="nav-item">⏳ Pending Approvals</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=reports" class="nav-item">📈 Reports</a>
    </nav>
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="nav-item logout">🚪 Logout</a>
    </div>
</div>

<main class="main-content">
    <div class="page-header">
        <h1>Admin Dashboard</h1>
        <p class="page-subtitle">Welcome back, <%= adminName %>!</p>
    </div>

    <% if (request.getParameter("message") != null) { %>
    <div class="alert-success"><%= request.getParameter("message") %></div>
    <% } %>

    <div class="stats-grid">
        <div class="stat-card stat-green">
            <div class="stat-icon">🙋</div>
            <div><div class="stat-number"><%= totalVolunteers %></div><div class="stat-label">Total Volunteers</div></div>
        </div>
        <div class="stat-card stat-blue">
            <div class="stat-icon">🏢</div>
            <div><div class="stat-number"><%= totalOrganizations %></div><div class="stat-label">Organizations</div></div>
        </div>
        <div class="stat-card stat-amber">
            <div class="stat-icon">📋</div>
            <div><div class="stat-number"><%= totalOpportunities %></div><div class="stat-label">Opportunities</div></div>
        </div>
        <div class="stat-card stat-purple">
            <div class="stat-icon">📝</div>
            <div><div class="stat-number"><%= totalApplications %></div><div class="stat-label">Applications</div></div>
        </div>
    </div>

    <div class="section-title">Quick Actions</div>
    <div class="quick-actions">
        <a href="<%= request.getContextPath() %>/AdminServlet?action=manageUsers" class="action-card">
            <span class="action-icon">👥</span><span class="action-label">Manage Users</span>
        </a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=pendingUsers" class="action-card">
            <span class="action-icon">⏳</span><span class="action-label">Pending Approvals</span>
        </a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=reports" class="action-card">
            <span class="action-icon">📈</span><span class="action-label">View Reports</span>
        </a>
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="action-card action-logout">
            <span class="action-icon">🚪</span><span class="action-label">Logout</span>
        </a>
    </div>
</main>

</body>
</html>
