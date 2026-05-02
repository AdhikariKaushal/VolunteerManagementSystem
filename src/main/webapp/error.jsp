<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error | VolunteerBridge</title>
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
            color: #a32d2d;
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
        .error-icon  { font-size: 60px; margin-bottom: 20px; }
        .error-detail {
            background: #fdecea;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            padding: 12px 20px;
            font-size: 13px;
            color: #a32d2d;
            margin-bottom: 28px;
            max-width: 500px;
        }
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
    <div class="error-icon">⚠️</div>
    <div class="error-code">500</div>
    <div class="error-title">Something Went Wrong</div>
    <div class="error-message">
        An unexpected error occurred. Please try again or contact support.
    </div>
    <% if (exception != null) { %>
    <div class="error-detail">
        <%= exception.getMessage() %>
    </div>
    <% } %>
    <a href="${pageContext.request.contextPath}/index.jsp" class="btn-home">
        Go Back Home
    </a>
</div>
</body>
</html>