package com.volunteermanagementsystem.model;
import java.sql.Date;

public class Opportunity {
    private int opportunityId;
    private int orgId;
    private String title;
    private String description;
    private String location;
    private Date eventDate;
    private int slots;
    private String category;
    private String status;

    public int getOpportunityId()                        { return opportunityId; }
    public void setOpportunityId(int opportunityId)      { this.opportunityId = opportunityId; }
    public int getOrgId()                                { return orgId; }
    public void setOrgId(int orgId)                      { this.orgId = orgId; }
    public String getTitle()                             { return title; }
    public void setTitle(String title)                   { this.title = title; }
    public String getDescription()                       { return description; }
    public void setDescription(String description)       { this.description = description; }
    public String getLocation()                          { return location; }
    public void setLocation(String location)             { this.location = location; }
    public Date getEventDate()                           { return eventDate; }
    public void setEventDate(Date eventDate)             { this.eventDate = eventDate; }
    public int getSlots()                                { return slots; }
    public void setSlots(int slots)                      { this.slots = slots; }
    public String getCategory()                          { return category; }
    public void setCategory(String category)             { this.category = category; }
    public String getStatus()                            { return status; }
    public void setStatus(String status)                 { this.status = status; }
}