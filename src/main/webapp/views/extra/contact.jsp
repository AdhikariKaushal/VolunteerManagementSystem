<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact | VolunteerBridge</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .nav-bar { background:#fff; padding:16px 32px; display:flex; align-items:center; justify-content:space-between; box-shadow:0 1px 4px rgba(0,0,0,0.06); position:sticky; top:0; z-index:50; }
        .nav-bar .brand { font-size:18px; font-weight:700; color:#1a6b3c; text-decoration:none; }
        .nav-links a { color:#444; text-decoration:none; margin-left:24px; font-size:14px; }
        .nav-links a:hover { color:#1a6b3c; }
        .wrapper { max-width:900px; margin:0 auto; padding:60px 24px; }
        .page-header { text-align:center; margin-bottom:40px; }
        .page-header .icon { font-size:52px; margin-bottom:14px; }
        .page-header h1 { font-size:36px; color:#1a6b3c; margin-bottom:8px; }
        .page-header p { color:#666; font-size:15px; }
        .grid { display:grid; grid-template-columns:1fr 1fr; gap:28px; }
        @media(max-width:640px){ .grid { grid-template-columns:1fr; } }
        .form-card { background:#fff; border-radius:14px; padding:32px; box-shadow:0 1px 6px rgba(0,0,0,0.08); }
        .form-card h2 { font-size:17px; color:#1a6b3c; margin-bottom:18px; }
        .form-card label { display:block; font-size:13px; font-weight:500; color:#444; margin-bottom:5px; }
        .form-card input, .form-card textarea { width:100%; padding:10px 14px; border:1px solid #ddd; border-radius:8px; font-size:14px; font-family:inherit; margin-bottom:14px; }
        .form-card input:focus, .form-card textarea:focus { outline:none; border-color:#1a6b3c; }
        .form-card textarea { resize:vertical; height:110px; }
        .info-card { background:linear-gradient(135deg,#1a6b3c,#0f4a28); color:#fff; border-radius:14px; padding:32px; display:flex; flex-direction:column; gap:20px; }
        .info-card h2 { font-size:17px; }
        .info-item { display:flex; gap:14px; align-items:flex-start; }
        .info-item .i-icon { font-size:20px; }
        .info-item .i-text { font-size:13px; line-height:1.6; opacity:.92; }
        .info-item .i-label { font-weight:600; font-size:12px; display:block; margin-bottom:2px; }
        .success-note { display:none; background:#e8f5ee; color:#085041; border:1px solid #b7dfca; border-radius:8px; padding:10px 14px; font-size:13px; margin-top:10px; }
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
        <div class="icon">📬</div>
        <h1>Contact Us</h1>
        <p>Got questions or feedback? We'd love to hear from you.</p>
    </div>

    <div class="grid">
        <div class="form-card">
            <h2>✉️ Send a Message</h2>
            <label>Full Name</label>
            <input type="text" id="name" placeholder="Your name">
            <label>Email Address</label>
            <input type="email" id="email" placeholder="your@email.com">
            <label>Subject</label>
            <input type="text" id="subject" placeholder="What's this about?">
            <label>Message</label>
            <textarea id="message" placeholder="Write your message here..."></textarea>
            <button type="button" class="btn btn-primary" onclick="submitForm()" style="width:100%;">Send Message</button>
            <div class="success-note" id="successNote">✅ Thanks! We'll get back to you soon.</div>
        </div>

        <div class="info-card">
            <h2>📍 Get In Touch</h2>
            <div class="info-item"><div class="i-icon">📧</div><div class="i-text"><span class="i-label">Email</span>support@volunteerbridge.com</div></div>
            <div class="info-item"><div class="i-icon">📞</div><div class="i-text"><span class="i-label">Phone</span>+977-01-4567890</div></div>
            <div class="info-item"><div class="i-icon">📍</div><div class="i-text"><span class="i-label">Address</span>Kathmandu, Nepal</div></div>
            <div class="info-item"><div class="i-icon">🕐</div><div class="i-text"><span class="i-label">Office Hours</span>Sunday – Friday, 9:00 AM – 5:00 PM</div></div>
            <div class="info-item"><div class="i-icon">🌐</div><div class="i-text"><span class="i-label">Website</span>www.volunteerbridge.com</div></div>
        </div>
    </div>
</div>

<script>
    function submitForm() {
        const name    = document.getElementById('name').value.trim();
        const email   = document.getElementById('email').value.trim();
        const message = document.getElementById('message').value.trim();
        if (!name || !email || !message) { alert('Please fill in name, email, and message.'); return; }
        if (!/^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$/.test(email)) { alert('Invalid email address.'); return; }
        document.getElementById('successNote').style.display = 'block';
        document.getElementById('name').value = '';
        document.getElementById('email').value = '';
        document.getElementById('subject').value = '';
        document.getElementById('message').value = '';
    }
</script>
</body>
</html>