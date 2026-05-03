package com.volunteermanagementsystem.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Opportunity {

    private int oppId;
    private int orgId;
    private String title;
    private String description;
    private String location;
    private String category;
    private int slots;
    private Date deadline;
    private String status;
    private Timestamp createdAt;
    private String orgName;

    public Opportunity() {}

    public int getOppId()                    { return oppId; }
    public void setOppId(int oppId)          { this.oppId = oppId; }

    public int getOrgId()                    { return orgId; }
    public void setOrgId(int orgId)          { this.orgId = orgId; }

    public String getTitle()                 { return title; }
    public void setTitle(String title)       { this.title = title; }

    public String getDescription()           { return description; }
    public void setDescription(String d)     { this.description = d; }

    public String getLocation()              { return location; }
    public void setLocation(String l)        { this.location = l; }

    public String getCategory()              { return category; }
    public void setCategory(String c)        { this.category = c; }

    public int getSlots()                    { return slots; }
    public void setSlots(int slots)          { this.slots = slots; }

    public Date getDeadline()                { return deadline; }
    public void setDeadline(Date deadline)   { this.deadline = deadline; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public Timestamp getCreatedAt()          { return createdAt; }
    public void setCreatedAt(Timestamp t)    { this.createdAt = t; }

    public String getOrgName()               { return orgName; }
    public void setOrgName(String orgName)   { this.orgName = orgName; }
}