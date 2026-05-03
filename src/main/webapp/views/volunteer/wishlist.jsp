<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.volunteermanagementsystem.model.Volunteer" %>
<%@ page import="com.volunteermanagementsystem.model.Wishlist" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Wishlist | VolunteerBridge</title>
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
        .wishlist-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; }
        .wish-card { background: #fff; border-radius: 12px; padding: 22px; box-shadow: 0 1px 6px rgba(0,0,0,0.06); display: flex; flex-direction: column; gap: 10px; }
        .wish-card h3 { font-size: 15px; color: #1a2e1a; margin: 0; }
        .wish-card .org { font-size: 13px; color: #1a6b3c; font-weight: 500; }
        .wish-meta { display: flex; flex-wrap: wrap; gap: 8px; }
        .wish-meta span { font-size: 12px; color: #666; background: #f4f6f9; padding: 3px 10px; border-radius: 20px; }
        .wish-actions { display: flex; gap: 10px; margin-top: 6px; }
        .btn-apply { flex: 1; padding: 9px; background: #1a6b3c; color: #fff; border: none; border-radius: 8px; cursor: pointer; font-size: 13px; font-weight: 600; }
        .btn-apply:hover { background: #145530; }
        .btn-remove { padding: 9px 14px; background: #fff; color: #a32d2d; border: 1.5px solid #a32d2d; border-radius: 8px; cursor: pointer; font-size: 13px; font-weight: 600; }
        .btn-remove:hover { background: #fdecea; }
        .empty-msg { color: #aaa; font-size: 15px; padding: 40px; text-align: center; background: #fff; border-radius: 12px; }
        .empty-msg a { color: #1a6b3c; }
    </style>
</head>
<body>
<%
    Volunteer volunteer = (Volunteer) request.getAttribute("volunteer");
    List<Wishlist> wishlist = (List<Wishlist>) request.getAttribute("wishlist");
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
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=applicationHistory"><span class="icon">📋</span>My Applications</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=wishlist" class="active"><span class="icon">❤️</span>Wishlist</a>
        </nav>
        <div class="logout">
            <a href="${pageContext.request.contextPath}/LogoutServlet">🚪 Logout</a>
        </div>
    </aside>

    <main class="main">
        <div class="page-header">
            <h1>My Wishlist ❤️</h1>
        </div>

        <% if ("true".equals(request.getParameter("added"))) { %>
        <div class="alert alert-success">Opportunity saved to wishlist!</div>
        <% } %>
        <% if ("true".equals(request.getParameter("removed"))) { %>
        <div class="alert alert-success">Removed from wishlist.</div>
        <% } %>

        <% if (wishlist == null || wishlist.isEmpty()) { %>
        <div class="empty-msg">
            Your wishlist is empty. <a href="${pageContext.request.contextPath}/VolunteerServlet?action=browseOpportunities">Browse opportunities</a> and save ones you like!
        </div>
        <% } else { %>
        <div class="wishlist-grid">
            <% for (Wishlist w : wishlist) { %>
            <div class="wish-card">
                <h3><%= w.getOpportunityTitle() %></h3>
                <div class="org">🏢 <%= w.getOrganizationName() %></div>
                <div class="wish-meta">
                    <% if (w.getLocation() != null && !w.getLocation().isEmpty()) { %><span>📍 <%= w.getLocation() %></span><% } %>
                    <% if (w.getStartDate() != null) { %><span>📅 <%= w.getStartDate() %></span><% } %>
                </div>
                <div class="wish-actions">
                    <form action="${pageContext.request.contextPath}/VolunteerServlet" method="post" style="flex:1;">
                        <input type="hidden" name="action" value="applyOpportunity"/>
                        <input type="hidden" name="opportunityId" value="<%= w.getOpportunityId() %>"/>
                        <button type="submit" class="btn-apply">Apply Now</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/VolunteerServlet" method="post">
                        <input type="hidden" name="action" value="removeWishlist"/>
                        <input type="hidden" name="opportunityId" value="<%= w.getOpportunityId() %>"/>
                        <button type="submit" class="btn-remove">🗑️ Remove</button>
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