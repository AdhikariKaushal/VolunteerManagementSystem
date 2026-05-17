<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>Volunteer Applications</title>
</head>

<body>

<h2>Volunteer Applications</h2>

<table border="1" cellpadding="10">

    <tr>
        <th>Application ID</th>
        <th>Status</th>
        <th>Approve</th>
        <th>Reject</th>
    </tr>

    <tr>

        <td>1</td>
        <td>Pending</td>

        <td>

            <form action="<%= request.getContextPath() %>/updateApplicationStatus"
                  method="post">

                <input type="hidden"
                       name="applicationId"
                       value="1">

                <input type="hidden"
                       name="status"
                       value="approved">

                <button type="submit">
                    Approve
                </button>

            </form>

        </td>

        <td>

            <form action="<%= request.getContextPath() %>/updateApplicationStatus"
                  method="post">

                <input type="hidden"
                       name="applicationId"
                       value="1">

                <input type="hidden"
                       name="status"
                       value="rejected">

                <button type="submit">
                    Reject
                </button>

            </form>

        </td>

    </tr>

</table>

</body>
</html>