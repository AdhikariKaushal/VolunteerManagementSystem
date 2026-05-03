<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.volunteermanagementsystem.model.Volunteer" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications | VolunteerBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background: #f4f6f9; }
        .layout { display: flex; min-height: 100vh; }
        .sidebar { width: 240px; background: #1a6b3c; color: #fff; padding: 28px 0; flex-shrink: 0; }
        .sidebar .brand { padding: 0 24px 28px; border-bottom: 1px solid rgba(255,255,255,0.15); }
        .sidebar .brand h2 { font-size: 18px; font-weight: 700; }
        .sidebar .brand span { font-size: 12px; opacity: 0.7; }
        .sidebar nav { padding-top: 16px; }
        .sidebar nav a { display: block; padding: 11px 24px; color: rgba(255,255,255,0.85); text-decoration: none; font-size: 14px; transition: background 0.2s; }
        .sidebar nav a:hover, .sidebar nav a.active { background: rgba(255,255,255,0.12); color: #fff; }
        .sidebar nav a .icon { margin-right: 10px; }
        .sidebar .logout { position: absolute; bottom: 24px; width: 240px; }
        .sidebar .logout a { display: block; padding: 11px 24px; color: rgba(255,255,255,0.7); text-decoration: none; font-size: 14px; }
        .main { flex: 1; padding: 32px; }
        .page-header { margin-bottom: 24px; }
        .page-header h1 { font-size: 22px; color: #1a2e1a; }
        .section { background: #fff; border-radius: 12px; padding: 24px; box-shadow: 0 1px 6px rgba(0,0,0,0.06); }
        .empty-msg { color: #aaa; font-size: 14px; padding: 20px 0; }
        .empty-msg a { color: #1a6b3c; }
    </style>
</head>
<body>
<%
    Volunteer volunteer = (Volunteer) request.getAttribute("volunteer");
    List<Object[]> applications = (List<Object[]>) request.getAttribute("applications");
%>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <h2>🤝 VolunteerBridge</h2>
            <span>Volunteer Portal</span>
        </div>
        <nav>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=dashboard"><span class="icon">🏠</span>Dashboard</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=profile"><span class="icon">👤</span>My Profile</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=browseOpportunities"><span class="icon">🔍</span>Browse Opportunities</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=applicationHistory" class="active"><span class="icon">📋</span>My Applications</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=wishlist"><span class="icon">❤️</span>Wishlist</a>
        </nav>
        <div class="logout">
            <a href="${pageContext.request.contextPath}/LogoutServlet">🚪 Logout</a>
        </div>
    </aside>

    <main class="main">
        <div class="page-header">
            <h1>My Applications</h1>
        </div>

        <% if ("true".equals(request.getParameter("applied"))) { %>
        <div class="alert alert-success">Application submitted successfully!</div>
        <% } %>

        <div class="section">
            <% if (applications == null || applications.isEmpty()) { %>
            <p class="empty-msg">You haven't applied to any opportunities yet. <a href="${pageContext.request.contextPath}/VolunteerServlet?action=browseOpportunities">Browse opportunities</a> to get started.</p>
            <% } else { %>
            <div class="table-wrapper">
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Opportunity</th>
                        <th>Organization</th>
                        <th>Status</th>
                        <th>Applied On</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% int i = 1; for (Object[] app : applications) {
                        String status = (String) app[3];
                    %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><%= app[1] %></td>
                        <td><%= app[2] %></td>
                        <td><span class="badge badge-<%= status.toLowerCase() %>"><%= status %></span></td>
                        <td><%= app[4] %></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <% } %>
        </div>
    </main>
</div>
</body>
</html>