<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.volunteermanagementsystem.dao.VolunteerDAO" %>
<%@ page import="com.volunteermanagementsystem.model.Wishlist" %>
<%@ page import="com.volunteermanagementsystem.model.Volunteer" %>
<%@ page import="java.util.List" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    VolunteerDAO volunteerDAO = new VolunteerDAO();
    Volunteer volunteer = volunteerDAO.getVolunteerByUserId(userId);
    List<Wishlist> wishlist = null;
    if(volunteer != null) {
        wishlist = volunteerDAO.getWishlist(volunteer.getId());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist | VolunteerBridge</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/volunteer.css">
</head>
<body>

    <aside class="sidebar">
        <div class="sidebar-header">
            <a href="#" class="brand">
                <i class="fa-solid fa-handshake-angle brand-icon"></i>
                VolunteerBridge
            </a>
            <div class="portal-text">Volunteer Portal</div>
        </div>

        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/views/volunteer/dashboard.jsp"><i class="fa-solid fa-house"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/views/volunteer/profile.jsp"><i class="fa-regular fa-user"></i> My Profile</a></li>
            <li><a href="${pageContext.request.contextPath}/views/volunteer/browseOpportunities.jsp"><i class="fa-solid fa-magnifying-glass"></i> Browse Opportunities</a></li>
            <li><a href="${pageContext.request.contextPath}/views/volunteer/applicationHistory.jsp"><i class="fa-solid fa-file-lines"></i> My Applications</a></li>
            <li><a href="${pageContext.request.contextPath}/views/volunteer/wishlist.jsp" class="active"><i class="fa-solid fa-heart"></i> Wishlist</a></li>
        </ul>

        <div class="logout-container">
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-btn">
                <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
            </a>
        </div>
    </aside>

    <main class="main-content">
        <header class="top-header">
            <div class="welcome-text">
                <h1>My Wishlist ❤️</h1>
                <p>Opportunities you have saved for later.</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar">
                    <i class="fa-solid fa-user"></i>
                </div>
            </div>
        </header>

        <% if ("true".equals(request.getParameter("removed"))) { %>
            <div style="color: #e74c3c; background: rgba(231, 76, 60, 0.1); padding: 10px; border-radius: 8px; margin-bottom: 20px;">
                <i class="fa-solid fa-trash"></i> Successfully removed from wishlist!
            </div>
        <% } %>

        <% if (wishlist == null || wishlist.isEmpty()) { %>
            <div class="empty-state">
                <i class="fa-solid fa-heart-crack empty-icon"></i>
                <h3>Your wishlist is empty</h3>
                <p>Browse opportunities and save the ones you like!</p>
                <a href="${pageContext.request.contextPath}/views/volunteer/browseOpportunities.jsp" class="btn btn-primary">
                    <i class="fa-solid fa-search"></i> Browse Opportunities
                </a>
            </div>
        <% } else { %>
            <div class="opportunities-grid">
                <% for(Wishlist w : wishlist) { %>
                <div class="opp-card">
                    <div class="opp-header"></div>
                    <div class="opp-body">
                        <h3 class="opp-title"><%= w.getOpportunityTitle() %></h3>
                        <div class="opp-org"><i class="fa-solid fa-building-ngo"></i> <%= w.getOrganizationName() %></div>
                        <p class="opp-desc">Location: <%= w.getLocation() %><br>Starts: <%= w.getStartDate() %></p>
                        <div class="opp-footer">
                            <button class="btn btn-primary btn-sm">Apply Now</button>
                            <form action="${pageContext.request.contextPath}/VolunteerServlet" method="post" style="margin:0;">
                                <input type="hidden" name="action" value="removeFromWishlist">
                                <input type="hidden" name="opportunityId" value="<%= w.getOpportunityId() %>">
                                <button type="submit" class="btn-icon" title="Remove from Wishlist" style="background:#e74c3c; color:white;"><i class="fa-solid fa-trash"></i></button>
                            </form>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>

    </main>

</body>
</html>
