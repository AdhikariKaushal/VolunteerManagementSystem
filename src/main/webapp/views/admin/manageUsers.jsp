<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.volunteermanagementsystem.model.User" %>
<%@ page import="com.volunteermanagementsystem.model.Organization" %>
<%@ page import="java.util.List" %>
<%
    if (session == null || session.getAttribute("role") == null ||
            !session.getAttribute("role").equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<User> users        = (List<User>) request.getAttribute("users");
    List<Organization> pendingOrganizations = (List<Organization>) request.getAttribute("pendingOrganizations");
    String viewMode = (String) request.getAttribute("viewMode");
    if (viewMode == null || viewMode.trim().isEmpty()) {
        viewMode = "manageUsers";
    }
    boolean isPendingView = "pendingUsers".equals(viewMode);
    boolean hasPendingOrganizations = pendingOrganizations != null && !pendingOrganizations.isEmpty();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isPendingView ? "Pending Approvals" : "Manage Users" %> | VolunteerBridge</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f4f6f9; display: flex; min-height: 100vh; }

        .sidebar {
            width: 240px; background: #1a1a2e; color: #fff;
            display: flex; flex-direction: column;
            position: fixed; top: 0; left: 0; height: 100vh;
        }
        .sidebar-brand {
            display: flex; align-items: center; gap: 10px;
            padding: 24px 20px; border-bottom: 1px solid rgba(255,255,255,0.08);
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

        .main-content { margin-left: 240px; flex: 1; padding: 32px; background: #f4f6f9; min-height: 100vh; }
        .page-header { margin-bottom: 28px; }
        .page-header h1 { font-size: 24px; font-weight: 700; color: #1a1a1a; }
        .page-subtitle { font-size: 14px; color: #777; margin-top: 4px; }

        .alert-success {
            background: #e8f5ee; color: #085041; border: 1px solid #b7dfca;
            padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 14px;
        }

        .table-card {
            background: #fff; border-radius: 14px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 28px; overflow: hidden;
        }
        .table-card-header {
            padding: 18px 24px; border-bottom: 1px solid #f0f0f0;
        }
        .table-card-header h2 { font-size: 16px; font-weight: 600; color: #1a1a1a; }
        .table-wrapper { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th {
            background: #f8f9fa; padding: 12px 16px;
            text-align: left; font-size: 12px; font-weight: 600;
            color: #666; text-transform: uppercase; letter-spacing: 0.5px;
        }
        td { padding: 14px 16px; font-size: 14px; color: #333; border-bottom: 1px solid #f5f5f5; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fafafa; }

        .badge {
            display: inline-block; padding: 4px 10px; border-radius: 20px;
            font-size: 11px; font-weight: 600; text-transform: uppercase;
        }
        .badge-active     { background: #e8f5ee; color: #1a6b3c; }
        .badge-pending    { background: #fff8e1; color: #ba7517; }
        .badge-open       { background: #e3f0fb; color: #185fa5; }
        .badge-deactivated { background: #fde8e8; color: #a32d2d; }

        .btn {
            display: inline-block; padding: 6px 12px; border-radius: 6px;
            font-size: 12px; font-weight: 500; cursor: pointer;
            border: none; text-decoration: none; margin-right: 4px;
        }
        .btn-primary { background: #1a6b3c; color: #fff; }
        .btn-primary:hover { background: #155c32; }
        .btn-danger  { background: #a32d2d; color: #fff; }
        .btn-danger:hover { background: #8c2626; }
        .btn-warning { background: #ba7517; color: #fff; }
        .btn-warning:hover { background: #a06312; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand">🤝 VolunteerBridge</div>
    <nav class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/AdminServlet?action=dashboard" class="nav-item">📊 Dashboard</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=manageUsers" class="nav-item <%= !isPendingView ? "active" : "" %>">👥 Manage Users</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=pendingUsers" class="nav-item <%= isPendingView ? "active" : "" %>">⏳ Pending Approvals</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=reports" class="nav-item">📈 Reports</a>
    </nav>
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="nav-item logout">🚪 Logout</a>
    </div>
</div>

<main class="main-content">
    <div class="page-header">
        <h1><%= isPendingView ? "Pending Approvals" : "Manage Users" %></h1>
        <p class="page-subtitle">
            <%= isPendingView ? "Review and approve pending registrations" : "View, approve, deactivate and reactivate user accounts" %>
        </p>
    </div>

    <% if (request.getParameter("message") != null) { %>
    <div class="alert-success"><%= request.getParameter("message") %></div>
    <% } %>

    <% if (hasPendingOrganizations) { %>
    <div class="table-card">
        <div class="table-card-header">
            <h2>🏢 Pending Organizations (<%= pendingOrganizations.size() %>)</h2>
        </div>
        <div class="table-wrapper">
            <table>
                <thead>
                <tr>
                    <th>#</th><th>Organization</th><th>Email</th><th>Phone</th><th>Type</th><th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% int k = 1; for (Organization org : pendingOrganizations) { %>
                <tr>
                    <td><%= k++ %></td>
                    <td><%= org.getOrgName() %></td>
                    <td><%= org.getEmail() %></td>
                    <td><%= org.getPhone() %></td>
                    <td><span class="badge badge-open"><%= org.getOrgType() %></span></td>
                    <td>
                        <form action="<%= request.getContextPath() %>/AdminServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="approveOrganization"/>
                            <input type="hidden" name="orgId" value="<%= org.getOrgId() %>"/>
                            <button type="submit" class="btn btn-primary">✅ Approve</button>
                        </form>
                        <form action="<%= request.getContextPath() %>/AdminServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="rejectOrganization"/>
                            <input type="hidden" name="orgId" value="<%= org.getOrgId() %>"/>
                            <button type="submit" class="btn btn-danger"
                                    onclick="return confirm('Reject this organization?')">❌ Reject</button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>
    <% if (isPendingView && !hasPendingOrganizations) { %>
    <div class="table-card">
        <div class="table-card-header">
            <h2>⏳ Pending Approvals (0)</h2>
        </div>
        <div class="table-wrapper">
            <table>
                <tbody>
                <tr>
                    <td style="text-align:center; color:#999; padding:30px;">No pending approvals found.</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>

    <!-- All Users -->
    <% if (!isPendingView) { %>
    <div class="table-card">
        <div class="table-card-header">
            <h2>👥 All Users</h2>
        </div>
        <div class="table-wrapper">
            <table>
                <thead>
                <tr>
                    <th>#</th><th>Email</th><th>Role</th>
                    <th>Status</th><th>Registered</th><th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% if (users != null && !users.isEmpty()) {
                    int j = 1;
                    for (User u : users) {
                        if ("admin".equals(u.getRole())) continue;
                %>
                <tr>
                    <td><%= j++ %></td>
                    <td><%= u.getEmail() %></td>
                    <td><span class="badge badge-open"><%= u.getRole() %></span></td>
                    <td>
                        <span class="badge <%= "active".equals(u.getStatus()) ? "badge-active" :
                                              "pending".equals(u.getStatus()) ? "badge-pending" :
                                              "badge-deactivated" %>">
                            <%= u.getStatus() %>
                        </span>
                    </td>
                    <td><%= u.getCreatedAt() %></td>
                    <td>
                        <% if ("active".equals(u.getStatus())) { %>
                        <form action="<%= request.getContextPath() %>/AdminServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="deactivateUser"/>
                            <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                            <button type="submit" class="btn btn-warning"
                                    onclick="return confirm('Deactivate this user?')">🚫 Deactivate</button>
                        </form>
                        <% } else if ("pending".equals(u.getStatus())) { %>
                        <form action="<%= request.getContextPath() %>/AdminServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="approveUser"/>
                            <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                            <button type="submit" class="btn btn-primary">✅ Approve</button>
                        </form>
                        <% } else if ("deactivated".equals(u.getStatus())) { %>
                        <form action="<%= request.getContextPath() %>/AdminServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="activateUser"/>
                            <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                            <button type="submit" class="btn btn-primary"
                                    onclick="return confirm('Activate this user? They will be able to sign in again.')">✅ Activate</button>
                        </form>
                        <% } else { %>
                        <span style="color:#999; font-size:13px;">No actions</span>
                        <% } %>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="6" style="text-align:center; color:#999; padding:30px;">No users found.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    <% } %>
</main>

</body>
</html>