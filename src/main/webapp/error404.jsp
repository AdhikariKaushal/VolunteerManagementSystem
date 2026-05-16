<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 Not Found | VolunteerBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .error-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            text-align: center;
            padding: 40px 20px;
            background: #f4f6f9;
        }
        .error-code {
            font-size: 100px;
            font-weight: 800;
            color: #1a6b3c;
            line-height: 1;
            margin-bottom: 16px;
        }
        .error-title {
            font-size: 28px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 12px;
        }
        .error-message {
            font-size: 16px;
            color: #777;
            margin-bottom: 32px;
            max-width: 400px;
            line-height: 1.6;
        }
        .error-icon { font-size: 60px; margin-bottom: 20px; }
        .btn-home {
            padding: 12px 32px;
            background: #1a6b3c;
            color: #fff;
            border-radius: 10px;
            text-decoration: none;
            font-size: 15px;
            font-weight: 600;
            transition: background 0.2s;
        }
        .btn-home:hover { background: #145530; }
    </style>
</head>
<body>
<div class="error-wrapper">
    <div class="error-icon">🔍</div>
    <div class="error-code">404</div>
    <div class="error-title">Page Not Found</div>
    <div class="error-message">
        Oops! The page you are looking for does not exist or has been moved.
    </div>
    <a href="${pageContext.request.contextPath}/index.jsp" class="btn-home">
        Go Back Home
    </a>
</div>
</body>
</html>