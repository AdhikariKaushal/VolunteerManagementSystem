<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.volunteermanagementsystem.util.SessionUtil" %>
<%@ page import="com.volunteermanagementsystem.model.User" %>
<%@ page import="com.volunteermanagementsystem.dao.OpportunityDAO" %>
<%@ page import="com.volunteermanagementsystem.model.Opportunity" %>
<%@ page import="java.util.List" %>
<%
    // Security check — only admin can access
    if (!SessionUtil.hasRole(request, "admin")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Fetch all opportunities directly via DAO
    OpportunityDAO opportunityDAO = new OpportunityDAO();
    List<Opportunity> opportunities = opportunityDAO.getAllOpportunities();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Opportunities | VolunteerBridge</title>
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
            <a href="${pageContext.request.contextPath}/AdminServlet?action=reports" class="nav-item">
                <span class="nav-icon">📈</span> Reports
            </a>
            <a href="${pageContext.request.contextPath}/admin/manageOpportunities.jsp" class="nav-item active">
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
                <h1>Volunteer Opportunities</h1>
                <p class="page-subtitle">View all opportunities posted by organizations</p>
            </div>
        </div>

        <!-- ── Opportunities Table ── -->
        <div class="table-card">
            <div class="table-card-header">
                <h2>📋 All Opportunities
                    (<%= opportunities != null ? opportunities.size() : 0 %>)
                </h2>
            </div>
            <div class="table-wrapper">
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Title</th>
                        <th>Location</th>
                        <th>Event Date</th>
                        <th>Slots</th>
                        <th>Category</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (opportunities != null && !opportunities.isEmpty()) {
                        int i = 1;
                        for (Opportunity o : opportunities) { %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><strong><%= o.getTitle() %></strong>
                            <div style="font-size:12px; color:#999; margin-top:2px;">
                                <%= o.getDescription() != null && o.getDescription().length() > 60
                                        ? o.getDescription().substring(0, 60) + "..."
                                        : o.getDescription() %>
                            </div>
                        </td>
                        <td><%= o.getLocation() != null ? o.getLocation() : "—" %></td>
                        <td><%= o.getEventDate() != null ? o.getEventDate() : "—" %></td>
                        <td><%= o.getSlots() %></td>
                        <td><%= o.getCategory() != null ? o.getCategory() : "—" %></td>
                        <td>
                                <span class="badge <%= "open".equals(o.getStatus()) ? "badge-open" : "badge-closed" %>">
                                    <%= o.getStatus() %>
                                </span>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="7" style="text-align:center; color:#999; padding:30px;">
                            No opportunities found yet.
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </main>
</div>

</body>
</html>