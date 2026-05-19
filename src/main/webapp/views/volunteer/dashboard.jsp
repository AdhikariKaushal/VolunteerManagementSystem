<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.volunteermanagementsystem.dao.VolunteerDAO" %>
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

    int totalHours = 0;
    int totalApplications = 0;
    int approvedApplications = 0;

    if (volunteer != null) {
        totalHours = volunteerDAO.getTotalHours(volunteer.getId());
        List<Object[]> apps = volunteerDAO.getApplicationHistory(volunteer.getId());
        totalApplications = apps.size();
        for (Object[] app : apps) {
            if ("approved".equalsIgnoreCase((String) app[3])) {
                approvedApplications++;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volunteer Dashboard | VolunteerBridge</title>
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
        <li><a href="${pageContext.request.contextPath}/views/volunteer/dashboard.jsp" class="active"><i class="fa-solid fa-house"></i> Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/views/volunteer/profile.jsp"><i class="fa-regular fa-user"></i> My Profile</a></li>
        <li><a href="${pageContext.request.contextPath}/views/volunteer/browseOpportunities.jsp"><i class="fa-solid fa-magnifying-glass"></i> Browse Opportunities</a></li>
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
            <h1>Welcome back, ${sessionScope.email != null ? sessionScope.email.split('@')[0] : 'Volunteer'}! 👋</h1>
            <p>Here is what's happening with your volunteer journey today.</p>
        </div>
        <div class="user-profile">
            <div class="user-avatar">
                <i class="fa-solid fa-user"></i>
            </div>
        </div>
    </header>

    <div class="dashboard-cards">
        <div class="card">
            <div class="card-icon icon-blue"><i class="fa-solid fa-clock"></i></div>
            <div class="card-info">
                <h3><%= totalHours %></h3>
                <p>Hours Volunteered</p>
            </div>
        </div>

        <div class="card">
            <div class="card-icon icon-green"><i class="fa-solid fa-file-lines"></i></div>
            <div class="card-info">
                <h3><%= totalApplications %></h3>
                <p>Total Applications</p>
            </div>
        </div>

        <div class="card">
            <div class="card-icon icon-purple"><i class="fa-solid fa-circle-check"></i></div>
            <div class="card-info">
                <h3><%= approvedApplications %></h3>
                <p>Approved Applications</p>
            </div>
        </div>
    </div>

    <div class="section-header">
        <h2>Recent Applications</h2>
        <a href="${pageContext.request.contextPath}/views/volunteer/applicationHistory.jsp" class="btn-view-all">View All</a>
    </div>

    <table class="data-table">
        <thead>
        <tr>
            <th>Opportunity</th>
            <th>Organization</th>
            <th>Applied Date</th>
            <th>Status</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (volunteer != null) {
                List<Object[]> recentApps = volunteerDAO.getApplicationHistory(volunteer.getId());
                int count = 0;
                for (Object[] app : recentApps) {
                    if (count >= 3) break;
                    String title   = (String) app[1];
                    String orgName = (String) app[2];
                    String status  = (String) app[3];
                    java.sql.Timestamp appliedAt = (java.sql.Timestamp) app[4];
                    String statusClass = "approved".equalsIgnoreCase(status) ? "status-approved" :
                            "rejected".equalsIgnoreCase(status) ? "status-rejected" : "status-pending";
        %>
        <tr>
            <td><strong><%= title %></strong></td>
            <td><%= orgName %></td>
            <td><%= appliedAt != null ? appliedAt.toString().substring(0, 10) : "—" %></td>
            <td><span class="status-badge <%= statusClass %>"><%= status %></span></td>
        </tr>
        <%
                count++;
            }
            if (recentApps.isEmpty()) {
        %>
        <tr>
            <td colspan="4" style="text-align:center;">No applications yet. Browse opportunities to get started!</td>
        </tr>
        <% } } %>
        </tbody>
    </table>

</main>

</body>
</html>