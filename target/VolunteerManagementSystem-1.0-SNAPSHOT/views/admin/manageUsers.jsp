<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.volunteermanagementsystem.util.SessionUtil" %>
<%@ page import="com.volunteermanagementsystem.model.User" %>
<%@ page import="java.util.List" %>
<%
    // Security check — only admin can access
    if (!SessionUtil.hasRole(request, "admin")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<User> users        = (List<User>) request.getAttribute("users");
    List<User> pendingUsers = (List<User>) request.getAttribute("pendingUsers");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users | VolunteerBridge</title>
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
            <a href="${pageContext.request.contextPath}/AdminServlet?action=manageUsers" class="nav-item active">
                <span class="nav-icon">👥</span> Manage Users
            </a>
            <a href="${pageContext.request.contextPath}/AdminServlet?action=pendingUsers" class="nav-item">
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

        <div class="page-header">
            <div>
                <h1>Manage Users</h1>
                <p class="page-subtitle">View, approve, reject and deactivate user accounts</p>
            </div>
        </div>

        <!-- Messages -->
        <% if (request.getParameter("message") != null) { %>
        <div class="alert alert-success"><%= request.getParameter("message") %></div>
        <% } %>

        <!-- ── Pending Approvals ── -->
        <% if (pendingUsers != null && !pendingUsers.isEmpty()) { %>
        <div class="table-card">
            <div class="table-card-header">
                <h2>⏳ Pending Registrations (<%= pendingUsers.size() %>)</h2>
            </div>
            <div class="table-wrapper">
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Registered</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% int i = 1;
                        for (User u : pendingUsers) { %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><%= u.getEmail() %></td>
                        <td><span class="badge badge-open"><%= u.getRole() %></span></td>
                        <td><span class="badge badge-pending"><%= u.getStatus() %></span></td>
                        <td><%= u.getCreatedAt() %></td>
                        <td>
                            <!-- Approve -->
                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="approveUser"/>
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                                <button type="submit" class="btn btn-primary" style="padding:6px 12px; font-size:12px;">
                                    ✅ Approve
                                </button>
                            </form>
                            <!-- Reject -->
                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="rejectUser"/>
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                                <button type="submit" class="btn btn-danger" style="padding:6px 12px; font-size:12px;"
                                        onclick="return confirm('Are you sure you want to reject this user?')">
                                    ❌ Reject
                                </button>
                            </form>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } %>

        <!-- ── All Users ── -->
        <div class="table-card">
            <div class="table-card-header">
                <h2>👥 All Users</h2>
            </div>
            <div class="table-wrapper">
                <table>
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Registered</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (users != null && !users.isEmpty()) {
                        int j = 1;
                        for (User u : users) {
                            if ("admin".equals(u.getRole())) continue; // skip admin accounts
                    %>
                    <tr>
                        <td><%= j++ %></td>
                        <td><%= u.getEmail() %></td>
                        <td><span class="badge badge-open"><%= u.getRole() %></span></td>
                        <td>
                                <span class="badge
                                    <%= "active".equals(u.getStatus()) ? "badge-active" :
                                        "pending".equals(u.getStatus()) ? "badge-pending" :
                                        "badge-deactivated" %>">
                                    <%= u.getStatus() %>
                                </span>
                        </td>
                        <td><%= u.getCreatedAt() %></td>
                        <td>
                            <% if ("active".equals(u.getStatus())) { %>
                            <!-- Deactivate -->
                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="deactivateUser"/>
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                                <button type="submit" class="btn btn-warning" style="padding:6px 12px; font-size:12px;"
                                        onclick="return confirm('Deactivate this user?')">
                                    🚫 Deactivate
                                </button>
                            </form>
                            <% } else if ("pending".equals(u.getStatus())) { %>
                            <!-- Approve -->
                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="approveUser"/>
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                                <button type="submit" class="btn btn-primary" style="padding:6px 12px; font-size:12px;">
                                    ✅ Approve
                                </button>
                            </form>
                            <% } else { %>
                            <span style="color:#999; font-size:13px;">No actions</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="6" style="text-align:center; color:#999; padding:30px;">
                            No users found.
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