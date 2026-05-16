<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.volunteermanagementsystem.dao.VolunteerDAO" %>
<%@ page import="com.volunteermanagementsystem.model.Volunteer" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    VolunteerDAO volunteerDAO = new VolunteerDAO();
    Volunteer volunteer = volunteerDAO.getVolunteerByUserId(userId);
    if (volunteer == null) volunteer = new Volunteer();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | VolunteerBridge</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/volunteer.css">
</head>
<body>

    <!-- Sidebar -->
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
            <li><a href="${pageContext.request.contextPath}/views/volunteer/profile.jsp" class="active"><i class="fa-regular fa-user"></i> My Profile</a></li>
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

    <!-- Main Content -->
    <main class="main-content">
        <header class="top-header">
            <div class="welcome-text">
                <h1>My Profile 👤</h1>
                <p>Manage your personal information and skills.</p>
            </div>
            <div class="user-profile">
                <div class="user-avatar">
                    <i class="fa-solid fa-user"></i>
                </div>
            </div>
        </header>

        <div class="profile-card">
            <% if ("true".equals(request.getParameter("updated"))) { %>
                <div style="color: #27ae60; background: rgba(46, 204, 113, 0.15); padding: 10px; border-radius: 8px; margin-bottom: 20px;">
                    <i class="fa-solid fa-check"></i> Profile updated successfully!
                </div>
            <% } %>
            <form action="${pageContext.request.contextPath}/VolunteerServlet" method="post">
                <input type="hidden" name="action" value="updateProfile">
                <div class="form-row">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" class="form-control" value="<%= volunteer.getFullName() != null ? volunteer.getFullName() : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" name="email" class="form-control" value="<%= volunteer.getEmail() != null ? volunteer.getEmail() : "" %>" readonly style="background: #f8f9fa;">
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="text" name="phone" class="form-control" value="<%= volunteer.getPhone() != null ? volunteer.getPhone() : "" %>">
                    </div>
                    <div class="form-group">
                        <label>Address</label>
                        <input type="text" name="address" class="form-control" value="<%= volunteer.getAddress() != null ? volunteer.getAddress() : "" %>">
                    </div>
                </div>

                <div class="form-group">
                    <label>Skills & Interests (Comma separated)</label>
                    <input type="text" name="skills" class="form-control" value="<%= volunteer.getSkills() != null ? volunteer.getSkills() : "" %>">
                </div>

                <div class="form-group">
                    <label>Short Bio</label>
                    <textarea name="bio" class="form-control" rows="4"><%= volunteer.getBio() != null ? volunteer.getBio() : "" %></textarea>
                </div>

                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-save"></i> Save Changes</button>
            </form>
        </div>
    </main>

</body>
</html>
