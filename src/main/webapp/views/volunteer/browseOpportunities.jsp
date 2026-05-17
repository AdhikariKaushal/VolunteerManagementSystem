<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.volunteermanagementsystem.dao.VolunteerDAO" %>
<%@ page import="java.util.List" %>
<%
    VolunteerDAO vDAO = new VolunteerDAO();
    List<Object[]> opps = vDAO.getAllOpenOpportunities();
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
        <% if ("true".equals(request.getParameter("applied"))) { %>
            <div style="color: #27ae60; background: rgba(46, 204, 113, 0.15); padding: 10px; border-radius: 8px; margin-bottom: 20px;">
                <i class="fa-solid fa-circle-check"></i> Application submitted successfully!
            </div>
        <% } %>
        <% if ("already".equals(request.getParameter("applied"))) { %>
            <div style="color: #f39c12; background: rgba(243, 156, 18, 0.15); padding: 10px; border-radius: 8px; margin-bottom: 20px;">
                <i class="fa-solid fa-circle-info"></i> You have already applied for this opportunity!
            </div>
        <% } %>

        <div class="opportunities-grid">
            <% if(opps != null && !opps.isEmpty()) { 
                  for(Object[] row : opps) { 
                      int oppId = (Integer) row[0];
                      String title = (String) row[1];
                      String orgName = (String) row[2];
                      String location = (String) row[3];
                      String startDate = String.valueOf(row[4]);
                      String category = (String) row[6];
            %>
            <div class="opp-card">
                <div class="opp-header">
                </div>
                <div class="opp-body">
                    <h3 class="opp-title"><%= title %></h3>
                    <p class="opp-desc"><strong>Organization:</strong> <%= orgName %><br>
                       <strong>Location:</strong> <%= location != null ? location : "TBD" %><br>
                       <strong>Date:</strong> <%= startDate %><br>
                       <strong>Category:</strong> <span style="background:#eee; padding:2px 6px; border-radius:4px; font-size:0.8em;"><%= category %></span>
                    </p>
                    <div class="opp-footer" style="display:flex; gap:10px;">
                        <form action="${pageContext.request.contextPath}/VolunteerServlet" method="post" style="margin:0;">
                            <input type="hidden" name="action" value="applyForOpportunity">
                            <input type="hidden" name="opportunityId" value="<%= oppId %>">
                            <button type="submit" class="btn btn-primary btn-sm">Apply Now</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/VolunteerServlet" method="post" style="margin:0;">
                            <input type="hidden" name="action" value="addToWishlist">
                            <input type="hidden" name="opportunityId" value="<%= oppId %>">
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
