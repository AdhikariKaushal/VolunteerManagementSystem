<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.volunteermanagementsystem.model.Opportunity" %>
<%@ page import="java.util.List" %>
<%
    if (session == null || session.getAttribute("role") == null ||
            !session.getAttribute("role").equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<Opportunity> opportunities = (List<Opportunity>) request.getAttribute("opportunities");
    String message = request.getParameter("message");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Opportunities | VolunteerBridge</title>
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

        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; }
        .alert-success { background: #e8f5ee; color: #1a6b3c; border: 1px solid #c3e6cb; }
        .alert-error { background: #fde8e8; color: #a32d2d; border: 1px solid #f5c6cb; }

        .filter-bar {
            display: flex; gap: 16px; margin-bottom: 24px;
        }
        .filter-bar select, .filter-bar input {
            padding: 10px 14px; border: 1px solid #e2e8f0; border-radius: 8px;
            font-size: 14px; outline: none;
        }
        .filter-bar input { flex: 1; }

        .table-card {
            background: #fff; border-radius: 14px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 28px; overflow: hidden;
        }
        .table-card-header { padding: 18px 24px; border-bottom: 1px solid #f0f0f0; }
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
        .badge-open   { background: #e8f5ee; color: #1a6b3c; }
        .badge-closed { background: #e2e8f0; color: #4a5568; }
        .badge-flagged { background: #fde8e8; color: #a32d2d; }

        .btn-action {
            padding: 6px 12px; border: none; border-radius: 6px; cursor: pointer;
            font-size: 12px; font-weight: 600; transition: background 0.2s;
        }
        .btn-flag { background: #fee2e2; color: #991b1b; }
        .btn-flag:hover { background: #fecaca; }
        .btn-unflag { background: #dcfce7; color: #166534; }
        .btn-unflag:hover { background: #bbf7d0; }
        
        .org-name { font-size: 12px; color: #666; display: block; margin-top: 4px; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand">🤝 VolunteerBridge</div>
    <nav class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/AdminServlet?action=dashboard" class="nav-item">📊 Dashboard</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=manageUsers" class="nav-item">👥 Manage Users</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=pendingUsers" class="nav-item">⏳ Pending Approvals</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=reports" class="nav-item">📈 Reports</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=manageOpportunities" class="nav-item active">📋 Opportunities</a>
    </nav>
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="nav-item logout">🚪 Logout</a>
    </div>
</div>

<main class="main-content">
    <div class="page-header">
        <h1>Volunteer Opportunities</h1>
        <p class="page-subtitle">Monitor and oversee all opportunities posted by organizations</p>
    </div>

    <% if (message != null) { %><div class="alert alert-success"><%= message %></div><% } %>
    <% if (error != null) { %><div class="alert alert-error"><%= error %></div><% } %>

    <div class="filter-bar">
        <input type="text" id="searchInput" placeholder="Search by title, description or organization..." onkeyup="filterTable()">
        <select id="statusFilter" onchange="filterTable()">
            <option value="all">All Statuses</option>
            <option value="open">Active (Open)</option>
            <option value="closed">Filled (Closed)</option>
            <option value="flagged">Flagged</option>
        </select>
    </div>

    <div class="table-card">
        <div class="table-card-header">
            <h2>📋 All Opportunities (<%= opportunities != null ? opportunities.size() : 0 %>)</h2>
        </div>
        <div class="table-wrapper">
            <table id="opportunitiesTable">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Title & Organization</th>
                    <th>Location & Date</th>
                    <th>Slots</th>
                    <th>Category</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% if (opportunities != null && !opportunities.isEmpty()) {
                    int i = 1;
                    for (Opportunity o : opportunities) { 
                        String badgeClass = "badge-closed";
                        if ("open".equalsIgnoreCase(o.getStatus())) badgeClass = "badge-open";
                        else if ("flagged".equalsIgnoreCase(o.getStatus())) badgeClass = "badge-flagged";
                %>
                <tr>
                    <td><%= i++ %></td>
                    <td>
                        <strong><%= o.getTitle() %></strong>
                        <span class="org-name">By: <%= o.getOrgName() != null ? o.getOrgName() : "Unknown Org" %></span>
                    </td>
                    <td>
                        <div style="font-size:13px;"><%= o.getLocation() != null ? o.getLocation() : "—" %></div>
                        <div style="font-size:12px; color:#666;"><%= o.getDeadline() != null ? o.getDeadline() : "—" %></div>
                    </td>
                    <td><%= o.getSlots() %></td>
                    <td><%= o.getCategory() != null ? o.getCategory() : "—" %></td>
                    <td class="status-cell">
                        <span class="badge <%= badgeClass %>" data-status="<%= o.getStatus().toLowerCase() %>">
                            <%= o.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <% if (!"flagged".equalsIgnoreCase(o.getStatus())) { %>
                        <form action="<%= request.getContextPath() %>/AdminServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="flagOpportunity">
                            <input type="hidden" name="oppId" value="<%= o.getOppId() %>">
                            <button type="submit" class="btn-action btn-flag" title="Flag as inappropriate">🚩 Flag</button>
                        </form>
                        <% } else { %>
                        <form action="<%= request.getContextPath() %>/AdminServlet" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="unflagOpportunity">
                            <input type="hidden" name="oppId" value="<%= o.getOppId() %>">
                            <button type="submit" class="btn-action btn-unflag">✅ Unflag</button>
                        </form>
                        <% } %>
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

<script>
    function filterTable() {
        const searchText = document.getElementById('searchInput').value.toLowerCase();
        const statusFilter = document.getElementById('statusFilter').value.toLowerCase();
        const table = document.getElementById('opportunitiesTable');
        const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');

        for (let i = 0; i < rows.length; i++) {
            // Skip the "no opportunities" row if it exists
            if (rows[i].getElementsByTagName('td').length === 1) continue;
            
            const titleOrgText = rows[i].getElementsByTagName('td')[1].textContent.toLowerCase();
            const badgeSpan = rows[i].querySelector('.badge');
            const status = badgeSpan ? badgeSpan.getAttribute('data-status') : '';

            const matchesSearch = titleOrgText.includes(searchText);
            const matchesStatus = (statusFilter === 'all') || (status === statusFilter);

            if (matchesSearch && matchesStatus) {
                rows[i].style.display = '';
            } else {
                rows[i].style.display = 'none';
            }
        }
    }
</script>

</body>
</html>