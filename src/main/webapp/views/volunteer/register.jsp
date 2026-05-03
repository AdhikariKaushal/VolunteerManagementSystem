<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | VolunteerBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background: #f4f6f9; display: flex; justify-content: center; align-items: flex-start; padding: 40px 16px; }
        .register-card { background: #fff; border-radius: 12px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); padding: 40px; width: 100%; max-width: 600px; }
        .register-card h2 { color: #1a6b3c; margin-bottom: 6px; }
        .register-card p.subtitle { color: #888; font-size: 14px; margin-bottom: 28px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
        .btn-submit { width: 100%; padding: 12px; background: #1a6b3c; color: #fff; border: none; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; margin-top: 8px; }
        .btn-submit:hover { background: #145530; }
        .login-link { text-align: center; margin-top: 16px; font-size: 13px; color: #888; }
        .login-link a { color: #1a6b3c; text-decoration: none; font-weight: 500; }
    </style>
</head>
<body>
<div class="register-card">
    <h2>🤝 Create Volunteer Profile</h2>
    <p class="subtitle">Fill in your details to get started with VolunteerBridge</p>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/VolunteerServlet" method="post">
        <input type="hidden" name="action" value="register"/>

        <div class="form-row">
            <div class="form-group">
                <label for="fullName">Full Name *</label>
                <input type="text" id="fullName" name="fullName" placeholder="Jane Doe" required/>
            </div>
            <div class="form-group">
                <label for="email">Email Address *</label>
                <input type="email" id="email" name="email" placeholder="jane@example.com" required/>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="phone">Phone Number</label>
                <input type="text" id="phone" name="phone" placeholder="9800000000"/>
            </div>
            <div class="form-group">
                <label for="dateOfBirth">Date of Birth</label>
                <input type="date" id="dateOfBirth" name="dateOfBirth"/>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="gender">Gender</label>
                <select id="gender" name="gender">
                    <option value="">-- Select --</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                    <option value="Prefer not to say">Prefer not to say</option>
                </select>
            </div>
            <div class="form-group">
                <label for="address">Address</label>
                <input type="text" id="address" name="address" placeholder="Kathmandu, Nepal"/>
            </div>
        </div>

        <div class="form-group">
            <label for="skills">Skills</label>
            <input type="text" id="skills" name="skills" placeholder="e.g. Teaching, First Aid, Coding"/>
        </div>

        <div class="form-group">
            <label for="bio">Short Bio</label>
            <textarea id="bio" name="bio" rows="3" placeholder="Tell us a little about yourself..."></textarea>
        </div>

        <button type="submit" class="btn-submit">Create Profile</button>
    </form>

    <div class="login-link">
        Already have a profile? <a href="${pageContext.request.contextPath}/VolunteerServlet?action=dashboard">Go to Dashboard</a>
    </div>
</div>
</body>
</html>