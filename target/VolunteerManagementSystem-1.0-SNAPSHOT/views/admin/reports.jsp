<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session == null || session.getAttribute("role") == null ||
            !session.getAttribute("role").equals("admin")) {
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

        .badge {
            display: inline-block; padding: 4px 10px; border-radius: 20px;
            font-size: 11px; font-weight: 600; text-transform: uppercase;
        }
        .badge-active   { background: #e8f5ee; color: #1a6b3c; }
        .badge-open     { background: #e3f0fb; color: #185fa5; }
        .badge-pending  { background: #fff8e1; color: #ba7517; }
        .badge-approved { background: #ede9ff; color: #534ab7; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="sidebar-brand">🤝 VolunteerBridge</div>
    <nav class="sidebar-nav">
        <a href="<%= request.getContextPath() %>/AdminServlet?action=dashboard" class="nav-item">📊 Dashboard</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=manageUsers" class="nav-item">👥 Manage Users</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=pendingUsers" class="nav-item">⏳ Pending Approvals</a>
        <a href="<%= request.getContextPath() %>/AdminServlet?action=reports" class="nav-item active">📈 Reports</a>
    </nav>
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="nav-item logout">🚪 Logout</a>
    </div>
</div>

<main class="main-content">
    <div class="page-header">
        <h1>System Reports</h1>
        <p class="page-subtitle">Summary overview of the entire platform</p>
    </div>

    <div class="stats-grid">
        <div class="stat-card stat-green">
            <div class="stat-icon">🙋</div>
            <div><div class="stat-number"><%= totalVolunteers %></div><div class="stat-label">Total Volunteers</div></div>
        </div>
        <div class="stat-card stat-blue">
            <div class="stat-icon">🏢</div>
            <div><div class="stat-number"><%= totalOrganizations %></div><div class="stat-label">Total Organizations</div></div>
        </div>
        <div class="stat-card stat-amber">
            <div class="stat-icon">📋</div>
            <div><div class="stat-number"><%= totalOpportunities %></div><div class="stat-label">Total Opportunities</div></div>
        </div>
        <div class="stat-card stat-purple">
            <div class="stat-icon">📝</div>
            <div><div class="stat-number"><%= totalApplications %></div><div class="stat-label">Total Applications</div></div>
        </div>
    </div>

    <div class="table-card">
        <div class="table-card-header">
            <h2>📊 Platform Summary</h2>
        </div>
        <div class="table-wrapper">
            <table>
                <thead>
                <tr><th>Metric</th><th>Count</th><th>Description</th></tr>
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
                    <td><span class="badge badge-active">
                        <%= totalOpportunities > 0 ? String.format("%.1f", (double) totalApplications / totalOpportunities) : "0.0" %>
                    </span></td>
                    <td>Average applications per opportunity</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</main>

</body>
</html>