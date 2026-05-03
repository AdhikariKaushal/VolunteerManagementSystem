package com.volunteermanagementsystem.model;
import java.sql.Timestamp;

public class Attendance {
    private int attendanceId;
    private int applicationId;
    private int volunteerId;
    private int opportunityId;
    private String status;
    private double hoursLogged;
    private Timestamp loggedAt;

    public int getAttendanceId()                         { return attendanceId; }
    public void setAttendanceId(int attendanceId)        { this.attendanceId = attendanceId; }
    public int getApplicationId()                        { return applicationId; }
    public void setApplicationId(int applicationId)      { this.applicationId = applicationId; }
    public int getVolunteerId()                          { return volunteerId; }
    public void setVolunteerId(int volunteerId)          { this.volunteerId = volunteerId; }
    public int getOpportunityId()                        { return opportunityId; }
    public void setOpportunityId(int opportunityId)      { this.opportunityId = opportunityId; }
    public String getStatus()                            { return status; }
    public void setStatus(String status)                 { this.status = status; }
    public double getHoursLogged()                       { return hoursLogged; }
    public void setHoursLogged(double hoursLogged)       { this.hoursLogged = hoursLogged; }
    public Timestamp getLoggedAt()                       { return loggedAt; }
    public void setLoggedAt(Timestamp loggedAt)          { this.loggedAt = loggedAt; }
}