<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.volunteermanagementsystem.dao.OpportunityDAO" %>
<%@ page import="com.volunteermanagementsystem.dao.OrganizationDAO" %>
<%@ page import="com.volunteermanagementsystem.model.Opportunity" %>
<%@ page import="com.volunteermanagementsystem.model.Organization" %>
<%@ page import="java.sql.Date" %>
<%
    OrganizationDAO orgDAO = new OrganizationDAO();
    OpportunityDAO oppDAO = new OpportunityDAO();
    
    // 1. Create the Organization Profile (since they don't map to Users table directly)
    String orgEmail = "seed_org@example.com";
    Organization org = orgDAO.getOrganizationByEmail(orgEmail);
    
    if (org == null) {
        org = new Organization();
        org.setOrgName("Green Earth Initiative");
        org.setEmail(orgEmail);
        org.setPassword("password123");
        org.setOrgType("NGO");
        org.setPhone("123456789");
        org.setAddress("Kathmandu");
        org.setDescription("Helping the environment");
        org.setWebsite("www.greenearth.com");
        orgDAO.register(org);
        
        org = orgDAO.getOrganizationByEmail(orgEmail);
    }
    
    int actualOrgId = (org != null) ? org.getOrgId() : 1;
    
    // 2. First opportunity
    Opportunity o1 = new Opportunity();
    o1.setOrgId(actualOrgId); 
    o1.setTitle("Community Park Cleanup");
    o1.setDescription("Join us this weekend to clean up the central park. Gloves and bags provided. Help us make the environment greener!");
    o1.setLocation("Central Park, Kathmandu");
    o1.setCategory("Environment");
    o1.setSlots(20);
    o1.setDeadline(new Date(System.currentTimeMillis() + 86400000L * 7));
    o1.setStatus("active");
    
    // 3. Second opportunity
    Opportunity o2 = new Opportunity();
    o2.setOrgId(actualOrgId);
    o2.setTitle("Weekend Math Tutoring");
    o2.setDescription("Help high school students with their math homework on Saturday mornings. We need passionate volunteers to guide young minds.");
    o2.setLocation("Bright Future School, Patan");
    o2.setCategory("Education");
    o2.setSlots(5);
    o2.setDeadline(new Date(System.currentTimeMillis() + 86400000L * 14));
    o2.setStatus("active");
    
    boolean success1 = oppDAO.create(o1);
    boolean success2 = oppDAO.create(o2);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Seed Data</title>
</head>
<body style="font-family: sans-serif; padding: 40px; text-align: center;">
    <h2 style="color: #27ae60;">Database Seeding Complete!</h2>
    <p>Organization created/found with ID: <b><%= actualOrgId %></b></p>
    <p>Opportunity 1 added: <b><%= success1 %></b></p>
    <p>Opportunity 2 added: <b><%= success2 %></b></p>
    <br><br>
    <a href="${pageContext.request.contextPath}/views/volunteer/browseOpportunities.jsp" 
       style="padding: 10px 20px; background: #27ae60; color: white; text-decoration: none; border-radius: 5px;">
       Go back to Browse Opportunities
    </a>
</body>
</html>
