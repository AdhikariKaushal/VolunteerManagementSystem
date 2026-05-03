<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Organisation Register | VolunteerMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/organization.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <h2>Register Your Organisation</h2>
        <p class="auth-sub">Create an account to post volunteer opportunities</p>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/org/register" method="post" novalidate>
            <div class="form-group">
                <label for="orgName">Organisation Name *</label>
                <input type="text" id="orgName" name="orgName" value="${orgName}" placeholder="e.g. Green Earth Nepal" required>
            </div>
            <div class="form-group">
                <label for="orgType">Organisation Type *</label>
                <select id="orgType" name="orgType" required>
                    <option value="">-- Select Type --</option>
                    <option value="NGO"        <%= "NGO".equals(request.getAttribute("orgType"))        ? "selected" : "" %>>NGO</option>
                    <option value="Foundation" <%= "Foundation".equals(request.getAttribute("orgType")) ? "selected" : "" %>>Foundation</option>
                    <option value="Non-Profit" <%= "Non-Profit".equals(request.getAttribute("orgType")) ? "selected" : "" %>>Non-Profit</option>
                    <option value="Community"  <%= "Community".equals(request.getAttribute("orgType"))  ? "selected" : "" %>>Community Group</option>
                    <option value="Other"      <%= "Other".equals(request.getAttribute("orgType"))      ? "selected" : "" %>>Other</option>
                </select>
            </div>
            <div class="form-group">
                <label for="email">Email Address *</label>
                <input type="email" id="email" name="email" value="${email}" placeholder="contact@organisation.org" required>
            </div>
            <div class="form-group">
                <label for="phone">Phone Number *</label>
                <input type="text" id="phone" name="phone" value="${phone}" placeholder="10-digit number" maxlength="10" required>
            </div>
            <div class="form-group">
                <label for="password">Password *</label>
                <input type="password" id="password" name="password" placeholder="Min. 6 characters" required>
            </div>
            <div class="form-group">
                <label for="confirmPassword">Confirm Password *</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter password" required>
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description" rows="3" placeholder="Briefly describe your organisation">${description}</textarea>
            </div>
            <div class="form-group">
                <label for="website">Website</label>
                <input type="text" id="website" name="website" value="${website}" placeholder="https://yourorg.org">
            </div>
            <div class="form-group">
                <label for="address">Address</label>
                <input type="text" id="address" name="address" value="${address}" placeholder="City, Country">
            </div>
            <button type="submit" class="btn btn-primary btn-full">Register Organisation</button>
        </form>
        <p class="auth-link">Already have an account?
            <a href="${pageContext.request.contextPath}/org/login">Login here</a>
        </p>
    </div>
</div>
<script>
    document.querySelector('form').addEventListener('submit', function(e) {
        const phone = document.getElementById('phone').value.trim();
        const pass  = document.getElementById('password').value;
        const conf  = document.getElementById('confirmPassword').value;
        const name  = document.getElementById('orgName').value.trim();
        if (!/^[a-zA-Z\s]+$/.test(name)) { alert('Organisation name must contain letters only.'); e.preventDefault(); return; }
        if (!/^\d{10}$/.test(phone))      { alert('Phone number must be exactly 10 digits.');     e.preventDefault(); return; }
        if (pass.length < 6)              { alert('Password must be at least 6 characters.');      e.preventDefault(); return; }
        if (pass !== conf)                { alert('Passwords do not match.');                      e.preventDefault(); return; }
    });
</script>
</body>
</html>