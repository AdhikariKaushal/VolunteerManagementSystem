<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications | VolunteerBridge</title>
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
            <li><a href="${pageContext.request.contextPath}/views/volunteer/applicationHistory.jsp" class="active"><i class="fa-solid fa-file-lines"></i> My Applications</a></li>
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
                <h1>My Applications 📋</h1>
                <p>Track the status of your volunteer applications.</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar">
                    <i class="fa-solid fa-user"></i>
                </div>
            </div>
        </header>

        <table class="data-table">
            <thead>
                <tr>
                    <th>Opportunity</th>
                    <th>Organization</th>
                    <th>Applied Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Community Park Cleanup</strong></td>
                    <td>Green Earth Initiative</td>
                    <td>May 01, 2026</td>
                    <td><span class="status-badge status-approved">Approved</span></td>
                    <td><a href="#" class="btn-view-all">View Details</a></td>
                </tr>
                <tr>
                    <td><strong>Weekend Math Tutoring</strong></td>
                    <td>Bright Future Kids</td>
                    <td>May 02, 2026</td>
                    <td><span class="status-badge status-pending">Pending</span></td>
                    <td><a href="#" class="btn-view-all">View Details</a></td>
                </tr>
                <tr>
                    <td><strong>Web Developer Mentor</strong></td>
                    <td>Code for All Nepal</td>
                    <td>Apr 28, 2026</td>
                    <td><span class="status-badge status-rejected">Rejected</span></td>
                    <td><a href="#" class="btn-view-all">View Details</a></td>
                </tr>
            </tbody>
        </table>

    </main>

</body>
</html>
