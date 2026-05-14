<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volunteer Registration | VolunteerBridge</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body {
            background: linear-gradient(135deg, #1b5e20 0%, #2e7d32 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px 20px;
        }
        .register-container {
            background: rgba(255, 255, 255, 0.97);
            border-radius: 20px;
            padding: 40px 45px;
            width: 100%;
            max-width: 700px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.25);
            animation: fadeIn 0.5s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .register-header h1 {
            color: #2e7d32;
            font-size: 1.9rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin-bottom: 6px;
        }
        .register-header p { color: #666; }

        .section-title {
            font-size: 0.8rem;
            font-weight: 600;
            color: #2e7d32;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 2px solid #e8f5e9;
            padding-bottom: 6px;
            margin: 24px 0 16px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        .form-group {
            margin-bottom: 18px;
            text-align: left;
        }
        .form-group label {
            display: block;
            margin-bottom: 7px;
            font-weight: 500;
            color: #333;
            font-size: 0.92rem;
        }
        .form-group label span.req { color: #e74c3c; }
        .form-control {
            width: 100%;
            padding: 11px 14px;
            border: 1.5px solid #ddd;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            background: #fafafa;
        }
        .form-control:focus {
            border-color: #2e7d32;
            outline: none;
            box-shadow: 0 0 0 3px rgba(46, 125, 50, 0.15);
            background: #fff;
        }
        textarea.form-control { resize: vertical; min-height: 90px; }
        select.form-control { cursor: pointer; }

        .skills-hint {
            font-size: 0.78rem;
            color: #888;
            margin-top: 4px;
        }

        .btn-register {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #2e7d32, #1b5e20);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.05rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            letter-spacing: 0.5px;
        }
        .btn-register:hover {
            background: linear-gradient(135deg, #1b5e20, #0a3d0a);
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(46, 125, 50, 0.35);
        }
        .login-link {
            display: block;
            margin-top: 22px;
            color: #666;
            text-align: center;
            font-size: 0.92rem;
        }
        .login-link a {
            color: #2e7d32;
            font-weight: 600;
            text-decoration: none;
        }
        .login-link a:hover { text-decoration: underline; }
        .error-message {
            color: #e74c3c;
            background: rgba(231, 76, 60, 0.1);
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            border-left: 4px solid #e74c3c;
        }
        .full-width { grid-column: 1 / -1; }
    </style>
</head>
<body>

    <div class="register-container">
        <div class="register-header">
            <h1><i class="fa-solid fa-handshake-angle"></i> VolunteerBridge</h1>
            <p>Join our community and make an impact!</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <i class="fa-solid fa-circle-exclamation"></i> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/RegisterVolunteerServlet" method="post">

            <!-- ── Account Info ── -->
            <div class="section-title"><i class="fa-solid fa-lock"></i> Account Details</div>
            <div class="form-row">
                <div class="form-group">
                    <label for="email">Email Address <span class="req">*</span></label>
                    <input type="email" id="email" name="email" class="form-control" required placeholder="john@example.com">
                </div>
                <div class="form-group">
                    <label for="password">Password <span class="req">*</span></label>
                    <input type="password" id="password" name="password" class="form-control" required placeholder="Create a strong password">
                </div>
            </div>

            <!-- ── Personal Info ── -->
            <div class="section-title"><i class="fa-solid fa-user"></i> Personal Information</div>
            <div class="form-row">
                <div class="form-group">
                    <label for="fullName">Full Name <span class="req">*</span></label>
                    <input type="text" id="fullName" name="fullName" class="form-control" required placeholder="John Doe">
                </div>
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone" class="form-control" placeholder="+977 98XXXXXXXX">
                </div>
                <div class="form-group">
                    <label for="dateOfBirth">Date of Birth</label>
                    <input type="date" id="dateOfBirth" name="dateOfBirth" class="form-control">
                </div>
                <div class="form-group">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender" class="form-control">
                        <option value="">-- Select --</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                        <option value="Prefer not to say">Prefer not to say</option>
                    </select>
                </div>
                <div class="form-group full-width">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address" class="form-control" placeholder="City, Country">
                </div>
            </div>

            <!-- ── Skills & Bio ── -->
            <div class="section-title"><i class="fa-solid fa-star"></i> Skills & Interests</div>
            <div class="form-group">
                <label for="skills">Skills & Interests</label>
                <input type="text" id="skills" name="skills" class="form-control" placeholder="e.g. Teaching, First Aid, Web Development, Photography">
                <div class="skills-hint"><i class="fa-solid fa-circle-info"></i> Separate multiple skills with commas</div>
            </div>
            <div class="form-group">
                <label for="bio">Short Bio</label>
                <textarea id="bio" name="bio" class="form-control" placeholder="Tell us a little about yourself and why you want to volunteer..."></textarea>
            </div>

            <button type="submit" class="btn-register">
                <i class="fa-solid fa-user-plus"></i> Create Account
            </button>
        </form>

        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login.jsp">Log in here</a>
        </div>
    </div>

</body>
</html>
