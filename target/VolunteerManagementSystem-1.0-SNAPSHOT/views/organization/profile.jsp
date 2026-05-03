<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Organisation Login | VolunteerMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/organization.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <h2>Organisation Login</h2>
        <p class="auth-sub">Sign in to manage your opportunities</p>

        <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/org/login" method="post">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" value="${email}"
                       placeholder="contact@organisation.org" required autofocus>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       placeholder="Enter your password" required>
            </div>
            <button type="submit" class="btn btn-primary btn-full">Login</button>
        </form>
        <p class="auth-link">Don't have an account?
            <a href="${pageContext.request.contextPath}/org/register">Register here</a>
        </p>
    </div>
</div>
</body>
</html>