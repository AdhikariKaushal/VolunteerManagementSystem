package com.volunteermanagementsystem.model;
import java.sql.Timestamp;

public class Application {
    private int applicationId;
    private int opportunityId;
    private int volunteerId;
    private String status;
    private Timestamp appliedAt;

    public int getApplicationId()                        { return applicationId; }
    public void setApplicationId(int applicationId)      { this.applicationId = applicationId; }
    public int getOpportunityId()                        { return opportunityId; }
    public void setOpportunityId(int opportunityId)      { this.opportunityId = opportunityId; }
    public int getVolunteerId()                          { return volunteerId; }
    public void setVolunteerId(int volunteerId)          { this.volunteerId = volunteerId; }
    public String getStatus()                            { return status; }
    public void setStatus(String status)                 { this.status = status; }
    public Timestamp getAppliedAt()                      { return appliedAt; }
    public void setAppliedAt(Timestamp appliedAt)        { this.appliedAt = appliedAt; }
}