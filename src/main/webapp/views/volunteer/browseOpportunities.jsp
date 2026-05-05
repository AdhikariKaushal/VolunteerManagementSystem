<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.volunteermanagementsystem.dao.OpportunityDAO" %>
<%@ page import="com.volunteermanagementsystem.model.Opportunity" %>
<%@ page import="java.util.List" %>
<%
    OpportunityDAO oppDAO = new OpportunityDAO();
    List<Opportunity> opps = oppDAO.findAll();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Opportunities | VolunteerBridge</title>
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
            <li><a href="${pageContext.request.contextPath}/views/volunteer/browseOpportunities.jsp" class="active"><i class="fa-solid fa-magnifying-glass"></i> Browse Opportunities</a></li>
            <li><a href="${pageContext.request.contextPath}/views/volunteer/applicationHistory.jsp"><i class="fa-solid fa-file-lines"></i> My Applications</a></li>
            <li><a href="${pageContext.request.contextPath}/views/volunteer/wishlist.jsp"><i class="fa-solid fa-heart"></i> Wishlist</a></li>
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
                <h1>Browse Opportunities 🔍</h1>
                <p>Find the perfect way to give back to your community.</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar">
                    <i class="fa-solid fa-user"></i>
                </div>
            </div>
        </header>

        <% if ("true".equals(request.getParameter("added"))) { %>
            <div style="color: #27ae60; background: rgba(46, 204, 113, 0.15); padding: 10px; border-radius: 8px; margin-bottom: 20px;">
                <i class="fa-solid fa-heart"></i> Opportunity successfully added to your wishlist!
            </div>
        <% } %>

        <div class="opportunities-grid">
            <% if(opps != null && !opps.isEmpty()) { 
                  for(Opportunity o : opps) { 
            %>
            <div class="opp-card">
                <div class="opp-header">
                </div>
                <div class="opp-body">
                    <h3 class="opp-title"><%= o.getTitle() %></h3>
                    <p class="opp-desc"><%= o.getDescription() != null ? (o.getDescription().length() > 80 ? o.getDescription().substring(0, 80) + "..." : o.getDescription()) : "" %></p>
                    <div class="opp-footer">
                        <button class="btn btn-primary btn-sm">Apply Now</button>
                        <form action="${pageContext.request.contextPath}/VolunteerServlet" method="post" style="margin:0;">
                            <input type="hidden" name="action" value="addToWishlist">
                            <input type="hidden" name="opportunityId" value="<%= o.getOppId() %>">
                            <button type="submit" class="btn-icon" title="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                        </form>
                    </div>
                </div>
            </div>
            <%    } 
               } else { 
            %>
            <div style="grid-column: 1/-1; text-align: center; color: #7f8c8d; padding: 40px;">
                <p>No opportunities available right now.</p>
            </div>
            <% } %>
        </div>

    </main>

</body>
</html>
