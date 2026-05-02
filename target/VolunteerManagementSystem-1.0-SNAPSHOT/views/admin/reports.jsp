<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.volunteermanagementsystem.util.SessionUtil" %>
<%
    // Security check — only admin can access
    if (!SessionUtil.hasRole(request, "admin")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

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
    <title>Reports | VolunteerBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
</head>
<body>

<div class="admin-wrapper">

    <!-- ── Sidebar ── -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <span class="brand-icon">🤝</span>
            <span class="brand-name">VolunteerBridge</span>
        </div>
        <nav class="sidebar-nav">
            <a href="${pageContext.request.contextPath}/AdminServlet?action=dashboard" class="nav-item">
                <span class="nav-icon">📊</span> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=manageUsers" class="nav-item">
                <span class="nav-icon">👥</span> Manage Users
            </a>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=pendingUsers" class="nav-item">
                <span class="nav-icon">⏳</span> Pending Approvals
            </a>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=reports" class="nav-item active">
                <span class="nav-icon">📈</span> Reports
            </a>
            <a href="${pageContext.request.contextPath}/views/admin/manageOpportunities.jsp" class="nav-item">
                <span class="nav-icon">📋</span> Opportunities
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

        <div class="page-header">
            <div>
                <h1>System Reports</h1>
                <p class="page-subtitle">Summary overview of the entire platform</p>
            </div>
        </div>

        <!-- ── Summary Stats ── -->
        <div class="stats-grid">
            <div class="stat-card stat-green">
                <div class="stat-icon">🙋</div>
                <div class="stat-info">
                    <div class="stat-number"><%= totalVolunteers %></div>
                    <div class="stat-label">Total Volunteers</div>
                </div>
            </div>
            <div class="stat-card stat-blue">
                <div class="stat-icon">🏢</div>
                <div class="stat-info">
                    <div class="stat-number"><%= totalOrganizations %></div>
                    <div class="stat-label">Total Organizations</div>
                </div>
            </div>
            <div class="stat-card stat-amber">
                <div class="stat-icon">📋</div>
                <div class="stat-info">
                    <div class="stat-number"><%= totalOpportunities %></div>
                    <div class="stat-label">Total Opportunities</div>
                </div>
            </div>
            <div class="stat-card stat-purple">
                <div class="stat-icon">📝</div>
                <div class="stat-info">
                    <div class="stat-number"><%= totalApplications %></div>
                    <div class="stat-label">Total Applications</div>
                </div>
            </div>
        </div>

        <!-- ── Detailed Report Table ── -->
        <div class="table-card">
            <div class="table-card-header">
                <h2>📊 Platform Summary</h2>
            </div>
            <div class="table-wrapper">
                <table>
                    <thead>
                    <tr>
                        <th>Metric</th>
                        <th>Count</th>
                        <th>Description</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td><strong>🙋 Volunteers</strong></td>
                        <td><span class="badge badge-active"><%= totalVolunteers %></span></td>
                        <td>Total registered volunteers on the platform</td>
                    </tr>
                    <tr>
                        <td><strong>🏢 Organizations</strong></td>
                        <td><span class="badge badge-open"><%= totalOrganizations %></span></td>
                        <td>Total registered community organizations</td>
                    </tr>
                    <tr>
                        <td><strong>📋 Opportunities</strong></td>
                        <td><span class="badge badge-pending"><%= totalOpportunities %></span></td>
                        <td>Total volunteer opportunities posted</td>
                    </tr>
                    <tr>
                        <td><strong>📝 Applications</strong></td>
                        <td><span class="badge badge-approved"><%= totalApplications %></span></td>
                        <td>Total applications submitted by volunteers</td>
                    </tr>
                    <tr>
                        <td><strong>📈 Avg Applications</strong></td>
                        <td>
                                <span class="badge badge-active">
                                    <%= totalOpportunities > 0 ? String.format("%.1f", (double) totalApplications / totalOpportunities) : "0.0" %>
                                </span>
                        </td>
                        <td>Average applications per opportunity</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

</body>
</html>