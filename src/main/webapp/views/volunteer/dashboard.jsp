<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.volunteermanagementsystem.model.Volunteer" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | VolunteerBridge</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        body { margin: 0; font-family: 'Segoe UI', sans-serif; background: #f4f6f9; }
        .layout { display: flex; min-height: 100vh; }

        /* Sidebar */
        .sidebar {
            width: 240px;
            background: #1a6b3c;
            color: #fff;
            padding: 28px 0;
            position: relative;
        }
        .sidebar .brand {
            padding: 0 24px 28px;
            border-bottom: 1px solid rgba(255,255,255,0.15);
        }
        .sidebar nav { padding-top: 16px; }
        .sidebar nav a {
            display: block;
            padding: 11px 24px;
            color: rgba(255,255,255,0.85);
            text-decoration: none;
        }
        .sidebar nav a:hover,
        .sidebar nav a.active {
            background: rgba(255,255,255,0.12);
            color: #fff;
        }

        /* Main */
        .main {
            flex: 1;
            padding: 32px;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
        }

        .section {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        table th, table td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
    </style>
</head>

<body>

<%
    Volunteer volunteer = (Volunteer) request.getAttribute("volunteer");
    Integer totalHoursObj = (Integer) request.getAttribute("totalHours");
    int totalHours = (totalHoursObj != null) ? totalHoursObj : 0;

    List<Object[]> recentApps = (List<Object[]>) request.getAttribute("recentApplications");
%>

<div class="layout">

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="brand">
            <h2>🤝 VolunteerBridge</h2>
        </div>

        <nav>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=dashboard" class="active">🏠 Dashboard</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=profile">👤 Profile</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=browseOpportunities">🔍 Opportunities</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=applicationHistory">📋 Applications</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=wishlist">❤️ Wishlist</a>
        </nav>

        <div style="position:absolute; bottom:20px; width:100%;">
            <a href="${pageContext.request.contextPath}/LogoutServlet" style="color:white; padding:10px 24px; display:block;">🚪 Logout</a>
        </div>
    </aside>

    <!-- Main -->
    <main class="main">

        <div class="topbar">
            <h2>
                Welcome,
                <%= (volunteer != null) ? volunteer.getFullName() : "User" %>
            </h2>
            <span>
                <%= (volunteer != null) ? volunteer.getEmail() : "" %>
            </span>
        </div>

        <!-- Success Message -->
        <% if ("true".equals(request.getParameter("registered"))) { %>
        <p style="color:green;">Profile created successfully!</p>
        <% } %>

        <!-- Stats -->
        <div class="stats">
            <div class="stat-card">
                <h4>Total Hours</h4>
                <p><%= totalHours %></p>
            </div>

            <div class="stat-card">
                <h4>Total Applications</h4>
                <p><%= (recentApps != null) ? recentApps.size() : 0 %></p>
            </div>
        </div>

        <!-- Recent Applications -->
        <div class="section">
            <h3>Recent Applications</h3>

            <% if (recentApps == null || recentApps.isEmpty()) { %>
            <p>No applications yet.</p>
            <% } else { %>

            <table>
                <thead>
                <tr>
                    <th>Opportunity</th>
                    <th>Organization</th>
                    <th>Status</th>
                    <th>Date</th>
                </tr>
                </thead>

                <tbody>
                <% for (Object[] app : recentApps) { %>
                <tr>
                    <td><%= app[1] %></td>
                    <td><%= app[2] %></td>
                    <td><%= app[3] %></td>
                    <td><%= app[4] %></td>
                </tr>
                <% } %>
                </tbody>
            </table>

            <% } %>
        </div>

    </main>
</div>

</body>
</html>