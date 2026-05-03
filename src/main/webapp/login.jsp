<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | VolunteerBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>

<div class="login-wrapper">

    <div class="login-left">
        <div class="brand">
            <div class="brand-icon">🤝</div>
            <h1>VolunteerBridge</h1>
            <p>Connecting volunteers with communities that need them most.</p>
        </div>
        <div class="features">
            <div class="feature-item">
                <span class="feature-icon">🌍</span>
                <span>Discover volunteer opportunities near you</span>
            </div>
            <div class="feature-item">
                <span class="feature-icon">🏢</span>
                <span>Organizations posting meaningful causes</span>
            </div>
            <div class="feature-item">
                <span class="feature-icon">📋</span>
                <span>Track your volunteering history and hours</span>
            </div>
        </div>
    </div>

    <div class="login-right">
        <div class="login-card">

            <h2>Welcome Back</h2>
            <p class="login-subtitle">Sign in to your account</p>

            <!-- Error Message -->
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <!-- Success Message -->
            <% if (request.getParameter("message") != null) { %>
            <div class="alert alert-success">
                <%= request.getParameter("message") %>
            </div>
            <% } %>

            <!-- Login Form -->
            <form action="${pageContext.request.contextPath}/LoginServlet" method="post">

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email"
                           id="email"
                           name="email"
                           placeholder="Enter your email"
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                           required/>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="Enter your password"
                           required/>
                </div>

                <button type="submit" class="btn-login">Sign In</button>

            </form>

            <div class="login-divider">
                <span>New to VolunteerBridge?</span>
            </div>

            <div class="register-links">
                <a href="${pageContext.request.contextPath}/views/volunteer/register.jsp">
                    Register as Volunteer
                </a>
                <a href="${pageContext.request.contextPath}/views/organization/register.jsp">
                    Register as Organization
                </a>
            </div>

        </div>
    </div>

</div>

</body>
</html>