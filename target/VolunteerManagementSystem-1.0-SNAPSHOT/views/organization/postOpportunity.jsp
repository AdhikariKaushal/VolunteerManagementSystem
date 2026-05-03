<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.volunteermanagementsystem.model.Opportunity" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Post Opportunity | VolunteerMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/organization.css">
</head>
<body>

<nav class="navbar">
    <div class="nav-brand">VolunteerMS</div>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/org/dashboard" class="btn btn-outline btn-sm">← Dashboard</a>
    </div>
</nav>

<div class="container">
    <h2>Post New Opportunity</h2>

    <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="card">
        <form action="${pageContext.request.contextPath}/opportunity/create" method="post" novalidate>

            <div class="form-group">
                <label for="title">Title *</label>
                <input type="text" id="title" name="title" placeholder="Enter title" required>
            </div>

            <div class="form-group">
                <label for="description">Description *</label>
                <textarea id="description" name="description" rows="4" placeholder="Enter description" required></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="location">Location</label>
                    <input type="text" id="location" name="location" placeholder="Enter location">
                </div>
                <div class="form-group">
                    <label for="category">Category</label>
                    <select id="category" name="category">
                        <option value="">-- Select --</option>
                        <option value="Environment">Environment</option>
                        <option value="Education">Education</option>
                        <option value="Health">Health</option>
                        <option value="Community">Community</option>
                        <option value="Animal Care">Animal Care</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="slots">Slots *</label>
                    <input type="number" id="slots" name="slots" min="1" required>
                </div>
                <div class="form-group">
                    <label for="deadline">Deadline *</label>
                    <input type="date" id="deadline" name="deadline" required>
                </div>
            </div>

            <button type="submit" class="btn btn-primary">Post Opportunity</button>
            <a href="${pageContext.request.contextPath}/org/dashboard" class="btn btn-outline">Cancel</a>

        </form>
    </div>
</div>

</body>
</html>