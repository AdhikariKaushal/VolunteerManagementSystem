package com.volunteermanagementsystem.model;

import java.sql.Timestamp;

public class Application {

    private int appId;
    private int oppId;
    private int volId;
    private String status;
    private Timestamp appliedAt;

    // Joined display fields
    private String volunteerName;
    private String volunteerEmail;
    private String volunteerPhone;
    private String opportunityTitle;

    public Application() {}

    public int getAppId()                      { return appId; }
    public void setAppId(int appId)            { this.appId = appId; }

    public int getOppId()                      { return oppId; }
    public void setOppId(int oppId)            { this.oppId = oppId; }

    public int getVolId()                      { return volId; }
    public void setVolId(int volId)            { this.volId = volId; }

    public String getStatus()                  { return status; }
    public void setStatus(String status)       { this.status = status; }

    public Timestamp getAppliedAt()            { return appliedAt; }
    public void setAppliedAt(Timestamp t)      { this.appliedAt = t; }

    public String getVolunteerName()           { return volunteerName; }
    public void setVolunteerName(String n)     { this.volunteerName = n; }

    public String getVolunteerEmail()          { return volunteerEmail; }
    public void setVolunteerEmail(String e)    { this.volunteerEmail = e; }

    public String getVolunteerPhone()          { return volunteerPhone; }
    public void setVolunteerPhone(String p)    { this.volunteerPhone = p; }

    public String getOpportunityTitle()        { return opportunityTitle; }
    public void setOpportunityTitle(String t)  { this.opportunityTitle = t; }
}