<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | VolunteerBridge</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f4f6f9; }

        .login-wrapper { display: flex; min-height: 100vh; }

        /* Left Panel */
        .login-left {
            flex: 1;
            background: linear-gradient(135deg, #1a6b3c, #0f4a28);
            color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 60px 50px;
        }
        .brand { margin-bottom: 50px; }
        .brand-icon { font-size: 48px; margin-bottom: 16px; }
        .brand h1 { font-size: 32px; font-weight: 700; margin-bottom: 12px; }
        .brand p { font-size: 16px; opacity: 0.85; line-height: 1.6; }
        .features { display: flex; flex-direction: column; gap: 20px; }
        .feature-item { display: flex; align-items: center; gap: 14px; font-size: 15px; opacity: 0.9; }
        .feature-icon { font-size: 22px; }

        /* Right Panel */
        .login-right {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
            background: #f4f6f9;
        }
        .login-card {
            background: #fff;
            border-radius: 16px;
            padding: 40px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
        }
        .login-card h2 { font-size: 24px; font-weight: 700; color: #1a1a1a; margin-bottom: 6px; }
        .login-subtitle { font-size: 14px; color: #777; margin-bottom: 24px; }

        /* Alerts */
        .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 14px; font-weight: 500; }
        .alert-error { background: #fdecea; color: #a32d2d; border: 1px solid #f5c6cb; }
        .alert-success { background: #e8f5ee; color: #085041; border: 1px solid #b7dfca; }

        /* Form */
        .form-group { margin-bottom: 16px; }
        .form-group label { display: block; font-size: 13px; font-weight: 500; color: #444; margin-bottom: 6px; }
        .form-group input {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            color: #333;
            background: #fff;
        }
        .form-group input:focus { outline: none; border-color: #1a6b3c; }

        .btn-login {
            width: 100%;
            padding: 12px;
            background: #1a6b3c;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 8px;
        }
        .btn-login:hover { background: #145530; }

        .login-divider { text-align: center; margin: 24px 0 16px; font-size: 13px; color: #999; }

        .register-links { display: flex; flex-direction: column; gap: 10px; }
        .register-links a {
            display: block;
            text-align: center;
            padding: 10px;
            border: 1px solid #1a6b3c;
            border-radius: 8px;
            color: #1a6b3c;
            font-size: 14px;
            font-weight: 500;
            text-decoration: none;
        }
        .register-links a:hover { background: #1a6b3c; color: #fff; }

        @media (max-width: 768px) {
            .login-wrapper { flex-direction: column; }
            .login-left { padding: 40px 24px; }
            .login-card { padding: 28px 20px; }
        }
    </style>
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

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getParameter("message") != null) { %>
            <div class="alert alert-success"><%= request.getParameter("message") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email"
                           placeholder="Enter your email"
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                           required/>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password"
                           placeholder="Enter your password" required/>
                </div>
                <button type="submit" class="btn-login">Sign In</button>
            </form>

            <div class="login-divider"><span>New to VolunteerBridge?</span></div>

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
