<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>

<head>
    <title>Attendance Management</title>
</head>

<body>

<h2>Volunteer Attendance</h2>

<form action="<%= request.getContextPath() %>/AttendanceServlet"
      method="post">

    <input type="hidden"
           name="action"
           value="log">

    <label>Application ID:</label>

    <input type="number"
           name="applicationId"
           required>

    <br><br>

    <label>Volunteer ID:</label>

    <input type="number"
           name="volunteerId"
           required>

    <br><br>

    <label>Opportunity ID:</label>

    <input type="number"
           name="opportunityId"
           required>

    <br><br>

    <label>Status:</label>

    <select name="status">

        <option value="PRESENT">
            Present
        </option>

        <option value="ABSENT">
            Absent
        </option>

    </select>

    <br><br>

    <label>Hours Logged:</label>

    <input type="number"
           step="0.1"
           name="hoursLogged"
           required>

    <br><br>

    <button type="submit">
        Mark Attendance
    </button>

</form>

</body>

</html>