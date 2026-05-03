<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.volunteermanagementsystem.model.Volunteer" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Opportunities | VolunteerBridge</title>
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
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
        .page-header h1 { font-size: 22px; color: #1a2e1a; }
        .search-bar { display: flex; gap: 10px; margin-bottom: 24px; }
        .search-bar input { flex: 1; padding: 10px 16px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; }
        .search-bar input:focus { outline: none; border-color: #1a6b3c; }
        .search-bar button { padding: 10px 20px; background: #1a6b3c; color: #fff; border: none; border-radius: 8px; cursor: pointer; font-size: 14px; font-weight: 500; }
        .search-bar button:hover { background: #145530; }
        .search-bar a { padding: 10px 16px; background: #f0f0f0; color: #555; border-radius: 8px; text-decoration: none; font-size: 14px; }

        .opp-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .opp-card { background: #fff; border-radius: 12px; padding: 22px; box-shadow: 0 1px 6px rgba(0,0,0,0.06); display: flex; flex-direction: column; gap: 10px; }
        .opp-card h3 { font-size: 15px; color: #1a2e1a; margin: 0; }
        .opp-card .org { font-size: 13px; color: #1a6b3c; font-weight: 500; }
        .opp-meta { display: flex; flex-wrap: wrap; gap: 8px; }
        .opp-meta span { font-size: 12px; color: #666; background: #f4f6f9; padding: 3px 10px; border-radius: 20px; }
        .opp-actions { display: flex; gap: 10px; margin-top: 6px; }
        .btn-apply { flex: 1; padding: 9px; background: #1a6b3c; color: #fff; border: none; border-radius: 8px; cursor: pointer; font-size: 13px; font-weight: 600; }
        .btn-apply:hover { background: #145530; }
        .btn-wishlist { padding: 9px 14px; background: #fff; color: #1a6b3c; border: 1.5px solid #1a6b3c; border-radius: 8px; cursor: pointer; font-size: 13px; font-weight: 600; }
        .btn-wishlist:hover { background: #e8f5ee; }
        .empty-msg { color: #aaa; font-size: 15px; padding: 40px; text-align: center; background: #fff; border-radius: 12px; }
    </style>
</head>
<body>
<%
    Volunteer volunteer = (Volunteer) request.getAttribute("volunteer");
    List<Object[]> opportunities = (List<Object[]>) request.getAttribute("opportunities");
    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) keyword = "";
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
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=browseOpportunities" class="active"><span class="icon">🔍</span>Browse Opportunities</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=applicationHistory"><span class="icon">📋</span>My Applications</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=wishlist"><span class="icon">❤️</span>Wishlist</a>
        </nav>
        <div class="logout">
            <a href="${pageContext.request.contextPath}/LogoutServlet">🚪 Logout</a>
        </div>
    </aside>

    <main class="main">
        <div class="page-header">
            <h1>Browse Opportunities</h1>
        </div>

        <% if ("true".equals(request.getParameter("alreadyApplied"))) { %>
        <div class="alert alert-error">You have already applied for this opportunity.</div>
        <% } %>

        <!-- Search -->
        <form action="${pageContext.request.contextPath}/VolunteerServlet" method="get">
            <input type="hidden" name="action" value="browseOpportunities"/>
            <div class="search-bar">
                <input type="text" name="keyword" placeholder="Search by title, location or category..." value="<%= keyword %>"/>
                <button type="submit">🔍 Search</button>
                <% if (!keyword.isEmpty()) { %>
                <a href="${pageContext.request.contextPath}/VolunteerServlet?action=browseOpportunities">Clear</a>
                <% } %>
            </div>
        </form>

        <% if (opportunities == null || opportunities.isEmpty()) { %>
        <div class="empty-msg">
            <% if (!keyword.isEmpty()) { %>
            No opportunities found for "<strong><%= keyword %></strong>".
            <% } else { %>
            No open opportunities available right now. Check back soon!
            <% } %>
        </div>
        <% } else { %>
        <div class="opp-grid">
            <% for (Object[] opp : opportunities) {
                int oppId       = (int)    opp[0];
                String title    = (String) opp[1];
                String orgName  = (String) opp[2];
                String location = (String) opp[3];
                String startDate= (String) opp[4];
                String endDate  = (String) opp[5];
                String category = (String) opp[6];
            %>
            <div class="opp-card">
                <h3><%= title %></h3>
                <div class="org">🏢 <%= orgName %></div>
                <div class="opp-meta">
                    <% if (location != null && !location.isEmpty()) { %><span>📍 <%= location %></span><% } %>
                    <% if (category != null && !category.isEmpty()) { %><span>🏷️ <%= category %></span><% } %>
                    <% if (startDate != null) { %><span>📅 <%= startDate %></span><% } %>
                    <% if (endDate != null) { %><span>⏳ Until <%= endDate %></span><% } %>
                </div>
                <div class="opp-actions">
                    <form action="${pageContext.request.contextPath}/VolunteerServlet" method="post" style="flex:1;">
                        <input type="hidden" name="action" value="applyOpportunity"/>
                        <input type="hidden" name="opportunityId" value="<%= oppId %>"/>
                        <button type="submit" class="btn-apply">Apply Now</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/VolunteerServlet" method="post">
                        <input type="hidden" name="action" value="addWishlist"/>
                        <input type="hidden" name="opportunityId" value="<%= oppId %>"/>
                        <button type="submit" class="btn-wishlist">❤️</button>
                    </form>
                </div>
            </div>
            <% } %>
        </div>
        <% } %>
    </main>
</div>
</body>
</html>