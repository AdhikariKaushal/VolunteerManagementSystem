<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>About | VolunteerBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .nav-bar { background:#fff; padding:16px 32px; display:flex; align-items:center; justify-content:space-between; box-shadow:0 1px 4px rgba(0,0,0,0.06); position:sticky; top:0; z-index:50; }
        .nav-bar .brand { font-size:18px; font-weight:700; color:#1a6b3c; text-decoration:none; }
        .nav-links a { color:#444; text-decoration:none; margin-left:24px; font-size:14px; }
        .nav-links a:hover { color:#1a6b3c; }
        .wrapper { max-width:960px; margin:0 auto; padding:60px 24px; }
        .page-header { text-align:center; margin-bottom:48px; }
        .page-header .icon { font-size:56px; margin-bottom:16px; }
        .page-header h1 { font-size:36px; color:#1a6b3c; margin-bottom:10px; }
        .page-header p { color:#666; font-size:15px; max-width:580px; margin:0 auto; line-height:1.7; }
        .mission { background:linear-gradient(135deg,#1a6b3c,#0f4a28); color:#fff; border-radius:16px; padding:48px; margin-bottom:40px; text-align:center; }
        .mission h2 { font-size:22px; margin-bottom:14px; }
        .mission p { font-size:15px; line-height:1.8; opacity:.92; max-width:680px; margin:0 auto; }
        .grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:20px; margin-bottom:40px; }
        .card { background:#fff; border-radius:12px; padding:24px; box-shadow:0 1px 4px rgba(0,0,0,0.08); border-top:3px solid #1a6b3c; }
        .card .icon { font-size:28px; margin-bottom:10px; }
        .card h3 { font-size:15px; color:#1a6b3c; margin-bottom:6px; }
        .card p { font-size:13px; color:#666; line-height:1.6; }
        .team-grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr)); gap:16px; margin-bottom:40px; }
        .team-card { background:#fff; border-radius:12px; padding:20px 16px; text-align:center; box-shadow:0 1px 4px rgba(0,0,0,0.08); }
        .avatar { width:52px; height:52px; background:#1a6b3c; color:#fff; border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:20px; font-weight:700; margin:0 auto 10px; }
        .team-card h4 { font-size:13px; color:#333; margin-bottom:4px; }
        .team-card p { font-size:12px; color:#888; }
        h2.section { font-size:22px; color:#1a6b3c; margin-bottom:20px; }
    </style>
</head>
<body>
<nav class="nav-bar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="brand">🤝 VolunteerBridge</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/views/extra/about.jsp">About</a>
        <a href="${pageContext.request.contextPath}/views/extra/contact.jsp">Contact</a>
        <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
    </div>
</nav>
<div class="wrapper">
    <div class="page-header">
        <div class="icon">🤝</div>
        <h1>About VolunteerBridge</h1>
        <p>Connecting passionate volunteers with meaningful opportunities — making community impact easier for everyone.</p>
    </div>

    <div class="mission">
        <h2>🌱 Our Mission</h2>
        <p>VolunteerBridge simplifies the connection between individuals who want to make a difference and organizations that need dedicated help. We believe volunteering should be easy to find, easy to manage, and rewarding for everyone involved.</p>
    </div>

    <div class="grid">
        <div class="card"><div class="icon">🔍</div><h3>Browse Opportunities</h3><p>Search and filter open opportunities by location, category, and date.</p></div>
        <div class="card"><div class="icon">📅</div><h3>Attendance Tracking</h3><p>Organizations log volunteer attendance and participation hours in one place.</p></div>
        <div class="card"><div class="icon">📊</div><h3>Admin Oversight</h3><p>Admins manage users, approve accounts, and monitor platform activity.</p></div>
        <div class="card"><div class="icon">❤️</div><h3>Wishlist & Apply</h3><p>Save opportunities to your wishlist and apply whenever you're ready.</p></div>
    </div>

    <h2 class="section">👥 The Team</h2>
    <div class="team-grid">
        <div class="team-card"><div class="avatar">K</div><h4>Kaushal Adhikari</h4><p>Auth & Admin Panel</p></div>
        <div class="team-card"><div class="avatar">D</div><h4>Darpan Ghimire</h4><p>Volunteer Module</p></div>
        <div class="team-card"><div class="avatar">O</div><h4>Oshan</h4><p>Attendance, Testing & UI</p></div>
    </div>

    <div style="text-align:center;">
        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary">Get Started →</a>
    </div>
</div>
</body>
</html>