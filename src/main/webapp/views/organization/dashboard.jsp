<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.volunteermanagementsystem.model.Opportunity" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | VolunteerMS</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/organization.css">
</head>
<body>
<nav class="navbar">
    <div class="nav-brand">VolunteerMS</div>
    <div class="nav-links">
        <span>Welcome, <strong>${org.orgName}</strong></span>
        <a href="${pageContext.request.contextPath}/org/profile" class="btn btn-outline btn-sm">My Profile</a>
        <form action="${pageContext.request.contextPath}/org/dashboard" method="post" style="display:inline">
            <input type="hidden" name="action" value="logout">
            <button type="submit" class="btn btn-danger btn-sm">Logout</button>
        </form>
    </div>
</nav>
<div class="container">
    <%
        String msg = request.getParameter("msg");
        if ("created".equals(msg)) { %><div class="alert alert-success">Opportunity created!</div><% }
else if ("updated".equals(msg)) { %><div class="alert alert-success">Opportunity updated!</div><% }
else if ("deleted".equals(msg)) { %><div class="alert alert-success">Opportunity deleted.</div><% }
%>
    <div class="page-header">
        <h2>My Opportunities</h2>
        <a href="${pageContext.request.contextPath}/opportunity/create" class="btn btn-primary">+ Post New Opportunity</a>
    </div>
    <%
        List<Opportunity> opps = (List<Opportunity>) request.getAttribute("opportunities");
        if (opps == null || opps.isEmpty()) {
    %>
    <div class="empty-state">
        <p>No opportunities posted yet.</p>
        <a href="${pageContext.request.contextPath}/opportunity/create" class="btn btn-primary">Post Your First Opportunity</a>
    </div>
    <% } else { %>
    <div class="table-wrapper">
        <table class="data-table">
            <thead>
            <tr><th>#</th><th>Title</th><th>Category</th><th>Location</th><th>Slots</th><th>Deadline</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
            <% int i = 1; for (Opportunity opp : opps) { %>
            <tr>
                <td><%= i++ %></td>
                <td><%= opp.getTitle() %></td>
                <td><%= opp.getCategory() != null ? opp.getCategory() : "-" %></td>
                <td><%= opp.getLocation() != null ? opp.getLocation() : "-" %></td>
                <td><%= opp.getSlots() %></td>
                <td><%= opp.getDeadline() != null ? opp.getDeadline() : "-" %></td>
                <td><span class="badge badge-<%= "open".equals(opp.getStatus()) ? "green" : "gray" %>"><%= opp.getStatus() %></span></td>
                <td class="action-cell">
                    <a href="${pageContext.request.contextPath}/application/list?oppId=<%= opp.getOppId() %>" class="btn btn-outline btn-sm">Applicants</a>
                    <a href="${pageContext.request.contextPath}/opportunity/edit?id=<%= opp.getOppId() %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="${pageContext.request.contextPath}/opportunity/delete?id=<%= opp.getOppId() %>" class="btn btn-danger btn-sm"
                       onclick="return confirm('Delete this opportunity?')">Delete</a>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</div>
</body>
</html>