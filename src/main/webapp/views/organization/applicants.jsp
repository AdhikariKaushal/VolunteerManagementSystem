<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.volunteermanagementsystem.model.Application" %>
<%@ page import="com.volunteermanagementsystem.model.Opportunity" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Applicants | VolunteerMS</title>
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
  <%
    String flashSuccess = (String) session.getAttribute("flashSuccess");
    String flashError   = (String) session.getAttribute("flashError");
    session.removeAttribute("flashSuccess");
    session.removeAttribute("flashError");
  %>
  <% if (flashSuccess != null) { %><div class="alert alert-success"><%= flashSuccess %></div><% } %>
  <% if (flashError   != null) { %><div class="alert alert-error"><%= flashError %></div><% } %>

  <% Opportunity opp = (Opportunity) request.getAttribute("opp");
    List<Application> applicants = (List<Application>) request.getAttribute("applicants"); %>

  <div class="page-header">
    <div>
      <h2>Applicants</h2>
      <p class="text-muted">Opportunity: <strong><%= opp.getTitle() %></strong> &nbsp;|&nbsp; Slots: <strong><%= opp.getSlots() %></strong></p>
    </div>
  </div>

  <% if (applicants == null || applicants.isEmpty()) { %>
  <div class="empty-state"><p>No applications received yet.</p></div>
  <% } else { %>
  <div class="table-wrapper">
    <table class="data-table">
      <thead>
      <tr><th>#</th><th>Name</th><th>Email</th><th>Phone</th><th>Applied On</th><th>Status</th><th>Actions</th></tr>
      </thead>
      <tbody>
      <% int i = 1; for (Application app : applicants) { %>
      <tr>
        <td><%= i++ %></td>
        <td><%= app.getVolunteerName() %></td>
        <td><%= app.getVolunteerEmail() %></td>
        <td><%= app.getVolunteerPhone() != null ? app.getVolunteerPhone() : "-" %></td>
        <td><%= app.getAppliedAt() %></td>
        <td><span class="badge badge-<%= "approved".equals(app.getStatus()) ? "green" : "rejected".equals(app.getStatus()) ? "red" : "orange" %>"><%= app.getStatus() %></span></td>
        <td class="action-cell">
          <% if ("pending".equals(app.getStatus())) { %>
          <form action="${pageContext.request.contextPath}/application/approve" method="post" style="display:inline">
            <input type="hidden" name="appId" value="<%= app.getAppId() %>">
            <input type="hidden" name="oppId" value="<%= opp.getOppId() %>">
            <button type="submit" class="btn btn-primary btn-sm">Approve</button>
          </form>
          <form action="${pageContext.request.contextPath}/application/reject" method="post" style="display:inline">
            <input type="hidden" name="appId" value="<%= app.getAppId() %>">
            <input type="hidden" name="oppId" value="<%= opp.getOppId() %>">
            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Reject this applicant?')">Reject</button>
          </form>
          <% } else { %><span class="text-muted">—</span><% } %>
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