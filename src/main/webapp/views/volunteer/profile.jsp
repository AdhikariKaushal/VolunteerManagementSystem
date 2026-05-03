<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.volunteermanagementsystem.model.Volunteer" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | VolunteerBridge</title>
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
        .page-header { margin-bottom: 28px; }
        .page-header h1 { font-size: 22px; color: #1a2e1a; }
        .card { background: #fff; border-radius: 12px; box-shadow: 0 1px 6px rgba(0,0,0,0.06); padding: 32px; max-width: 700px; }
        .card h3 { font-size: 16px; color: #1a2e1a; margin-bottom: 20px; border-bottom: 1px solid #f0f0f0; padding-bottom: 10px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .btn-save { padding: 11px 28px; background: #1a6b3c; color: #fff; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; }
        .btn-save:hover { background: #145530; }
    </style>
</head>
<body>
<%
    Volunteer volunteer = (Volunteer) request.getAttribute("volunteer");
    String dob = volunteer.getDateOfBirth() != null ? volunteer.getDateOfBirth().toString() : "";
%>
<div class="layout">
    <aside class="sidebar">
        <div class="brand">
            <h2>🤝 VolunteerBridge</h2>
            <span>Volunteer Portal</span>
        </div>
        <nav>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=dashboard"><span class="icon">🏠</span>Dashboard</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=profile" class="active"><span class="icon">👤</span>My Profile</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=browseOpportunities"><span class="icon">🔍</span>Browse Opportunities</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=applicationHistory"><span class="icon">📋</span>My Applications</a>
            <a href="${pageContext.request.contextPath}/VolunteerServlet?action=wishlist"><span class="icon">❤️</span>Wishlist</a>
        </nav>
        <div class="logout">
            <a href="${pageContext.request.contextPath}/LogoutServlet">🚪 Logout</a>
        </div>
    </aside>

    <main class="main">
        <div class="page-header">
            <h1>My Profile</h1>
        </div>

        <% if ("true".equals(request.getParameter("updated"))) { %>
        <div class="alert alert-success" style="max-width:700px;">Profile updated successfully!</div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error" style="max-width:700px;"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="card">
            <h3>Edit Profile Details</h3>
            <form action="${pageContext.request.contextPath}/VolunteerServlet" method="post">
                <input type="hidden" name="action" value="updateProfile"/>

                <div class="form-row">
                    <div class="form-group">
                        <label>Full Name *</label>
                        <input type="text" name="fullName" value="<%= volunteer.getFullName() %>" required/>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" value="<%= volunteer.getEmail() %>" disabled style="background:#f5f5f5;"/>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="phone" value="<%= volunteer.getPhone() != null ? volunteer.getPhone() : "" %>"/>
                    </div>
                    <div class="form-group">
                        <label>Date of Birth</label>
                        <input type="date" name="dateOfBirth" value="<%= dob %>"/>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Gender</label>
                        <select name="gender">
                            <option value="">-- Select --</option>
                            <option value="Male"   <%= "Male".equals(volunteer.getGender())   ? "selected" : "" %>>Male</option>
                            <option value="Female" <%= "Female".equals(volunteer.getGender()) ? "selected" : "" %>>Female</option>
                            <option value="Other"  <%= "Other".equals(volunteer.getGender())  ? "selected" : "" %>>Other</option>
                            <option value="Prefer not to say" <%= "Prefer not to say".equals(volunteer.getGender()) ? "selected" : "" %>>Prefer not to say</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Address</label>
                        <input type="text" name="address" value="<%= volunteer.getAddress() != null ? volunteer.getAddress() : "" %>"/>
                    </div>
                </div>

                <div class="form-group">
                    <label>Skills</label>
                    <input type="text" name="skills" value="<%= volunteer.getSkills() != null ? volunteer.getSkills() : "" %>" placeholder="e.g. Teaching, First Aid, Coding"/>
                </div>

                <div class="form-group">
                    <label>Bio</label>
                    <textarea name="bio" rows="3"><%= volunteer.getBio() != null ? volunteer.getBio() : "" %></textarea>
                </div>

                <button type="submit" class="btn-save">Save Changes</button>
            </form>
        </div>
    </main>
</div>
</body>
</html>