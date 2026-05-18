<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.volunteermanagementsystem.model.Application" %>
<%
    if (session == null || session.getAttribute("role") == null ||
            !session.getAttribute("role").equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<Application> applications = (List<Application>) request.getAttribute("applications");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Applications | VolunteerBridge</title>
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

        .filter-bar {
            background: #fff; border-radius: 12px; padding: 16px 20px;
            display: flex; gap: 12px; align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 24px;
            flex-wrap: wrap;
        }
        .filter-bar input {
            flex: 1; min-width: 200px; padding: 9px 14px;
            border: 1px solid #ddd; border-radius: 8px;
            font-size: 14px; outline: none;
        }
        .filter-bar input:focus { border-color: #1a6b3c; }
        .filter-bar select {
            padding: 9px 14px; border: 1px solid #ddd;
            border-radius: 8px; font-size: 14px; outline: none;
            background: #fff; cursor: pointer;
        }
        .filter-bar select:focus { border-color: #1a6b3c; }

        .table-card {
            background: #fff; border-radius: 14px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06); overflow: hidden;
        }
        .table-card-header {
            padding: 18px 24px; border-bottom: 1px solid #f0f0f0;
            display: flex; justify-content: space-between; align-items: center;
        }
        .table-card-header h2 { font-size: 16px; font-weight: 600; color: #1a1a1a; }
        .record-count { font-size: 13px; color: #777; }
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
        .badge-pending  { background: #fff8e1; color: #ba7517; }
        .badge-approved { background: #e8f5ee; color: #1a6b3c; }
        .badge-rejected { background: #fdecea; color: #a32d2d; }

        .empty-state {
            text-align: center; padding: 60px 20px; color: #999;
        }
        .empty-state .empty-icon { font-size: 48px; margin-bottom: 12px; }
        .empty-state p { font-size: 15px; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand">🤝 VolunteerBridge</div>
    <nav class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/AdminServlet?action=dashboard"           class="nav-item">📊 Dashboard</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=manageUsers"         class="nav-item">👥 Manage Users</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=pendingUsers"        class="nav-item">⏳ Pending Approvals</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=manageOpportunities" class="nav-item">📋 Opportunities</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=applications"        class="nav-item active">📝 Applications</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=reports"             class="nav-item">📈 Reports</a>
    </nav>
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="nav-item logout">🚪 Logout</a>
    </div>
</div>

<main class="main-content">
    <div class="page-header">
        <h1>📝 All Applications</h1>
        <p class="page-subtitle">Read-only overview of all volunteer applications across the platform</p>
    </div>

    <div class="filter-bar">
        <input type="text" id="searchInput" placeholder="🔍 Search by volunteer or opportunity..." onkeyup="filterTable()">
        <select id="statusFilter" onchange="filterTable()">
            <option value="">All Statuses</option>
            <option value="pending">Pending</option>
            <option value="approved">Approved</option>
            <option value="rejected">Rejected</option>
        </select>
    </div>

    <div class="table-card">
        <div class="table-card-header">
            <h2>📝 Applications</h2>
            <span class="record-count" id="recordCount">
                <%= applications != null ? applications.size() : 0 %> total
            </span>
        </div>
        <div class="table-wrapper">
            <table id="applicationsTable">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Volunteer Name</th>
                    <th>Volunteer Email</th>
                    <th>Opportunity</th>
                    <th>Organization</th>
                    <th>Status</th>
                    <th>Applied At</th>
                </tr>
                </thead>
                <tbody>
                <% if (applications == null || applications.isEmpty()) { %>
                <tr>
                    <td colspan="7">
                        <div class="empty-state">
                            <div class="empty-icon">📭</div>
                            <p>No applications found yet. They will appear here once volunteers start applying.</p>
                        </div>
                    </td>
                </tr>
                <% } else {
                    int count = 1;
                    for (Application app : applications) { %>
                <tr>
                    <td><%= count++ %></td>
                    <td><strong><%= app.getVolunteerName() != null ? app.getVolunteerName() : "—" %></strong></td>
                    <td><%= app.getVolunteerEmail() != null ? app.getVolunteerEmail() : "—" %></td>
                    <td><%= app.getOpportunityTitle() != null ? app.getOpportunityTitle() : "—" %></td>
                    <td><%= app.getOrganizationName() != null ? app.getOrganizationName() : "—" %></td>
                    <td>
                        <span class="badge
                            <%= "approved".equals(app.getStatus()) ? "badge-approved" :
                                "rejected".equals(app.getStatus()) ? "badge-rejected" : "badge-pending" %>">
                            <%= app.getStatus() %>
                        </span>
                    </td>
                    <td><%= app.getAppliedAt() != null ? app.getAppliedAt().toString().substring(0, 16) : "—" %></td>
                </tr>
                <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</main>

<script>
    function filterTable() {
        const search = document.getElementById('searchInput').value.toLowerCase();
        const status = document.getElementById('statusFilter').value.toLowerCase();
        const rows   = document.querySelectorAll('#applicationsTable tbody tr');
        let visible  = 0;
        rows.forEach(row => {
            const text       = row.innerText.toLowerCase();
            const statusCell = row.cells[5] ? row.cells[5].innerText.toLowerCase().trim() : '';
            const matchSearch = text.includes(search);
            const matchStatus = status === '' || statusCell.includes(status);
            if (matchSearch && matchStatus) {
                row.style.display = '';
                visible++;
            } else {
                row.style.display = 'none';
            }
        });
        document.getElementById('recordCount').innerText = visible + ' total';
    }
</script>

</body>
</html>