<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volunteer Dashboard | VolunteerBridge</title>
    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS -->
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

    <!-- Main Content -->
    <main class="main-content">
        <!-- Top Header -->
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

        <!-- Dashboard Widgets -->
        <div class="dashboard-cards">
            <div class="card">
                <div class="card-icon icon-blue"><i class="fa-solid fa-clock"></i></div>
                <div class="card-info">
                    <h3>24</h3>
                    <p>Hours Volunteered</p>
                </div>
            </div>
            
            <div class="card">
                <div class="card-icon icon-green"><i class="fa-solid fa-calendar-check"></i></div>
                <div class="card-info">
                    <h3>3</h3>
                    <p>Upcoming Events</p>
                </div>
            </div>

            <div class="card">
                <div class="card-icon icon-purple"><i class="fa-solid fa-award"></i></div>
                <div class="card-info">
                    <h3>Top 5%</h3>
                    <p>Impact Score</p>
                </div>
            </div>

            <div class="card">
                <div class="card-icon icon-orange"><i class="fa-solid fa-hand-holding-heart"></i></div>
                <div class="card-info">
                    <h3>12</h3>
                    <p>Organizations Helped</p>
                </div>
            </div>
        </div>

        <!-- Recent Activity -->
        <section class="recent-activity">
            <div class="section-header">
                <h2>Recent Activity</h2>
                <a href="#" class="btn-view-all">View All</a>
            </div>
            
            <div class="activity-list">
                <div class="activity-item">
                    <div class="activity-icon"><i class="fa-solid fa-check"></i></div>
                    <div class="activity-details">
                        <h4>Application Approved</h4>
                        <p>Your application for "Community Food Drive" was accepted.</p>
                    </div>
                    <div class="activity-time">2 hours ago</div>
                </div>
                
                <div class="activity-item">
                    <div class="activity-icon" style="color: #e67e22; background: rgba(230,126,34,0.1);"><i class="fa-solid fa-heart"></i></div>
                    <div class="activity-details">
                        <h4>Saved Opportunity</h4>
                        <p>You saved "Park Cleanup Initiative" to your wishlist.</p>
                    </div>
                    <div class="activity-time">1 day ago</div>
                </div>
                
                <div class="activity-item">
                    <div class="activity-icon" style="color: #3498db; background: rgba(52,152,219,0.1);"><i class="fa-solid fa-certificate"></i></div>
                    <div class="activity-details">
                        <h4>Certificate Earned</h4>
                        <p>You received a certificate for completing 20 hours.</p>
                    </div>
                    <div class="activity-time">3 days ago</div>
                </div>
            </div>
        </section>
    </main>

</body>
</html>
