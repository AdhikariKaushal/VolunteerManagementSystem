package com.volunteermanagementsystem.model;

import java.time.LocalDateTime;

/**
 * Wishlist Model
 * Author: Darpan Ghimire
 */

public class Wishlist {

    private int id;
    private int volunteerId;
    private int opportunityId;
    private LocalDateTime savedAt;

    // For joined display
    private String opportunityTitle;
    private String organizationName;
    private String location;
    private String startDate;

    public Wishlist() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getVolunteerId() { return volunteerId; }
    public void setVolunteerId(int volunteerId) { this.volunteerId = volunteerId; }

    public int getOpportunityId() { return opportunityId; }
    public void setOpportunityId(int opportunityId) { this.opportunityId = opportunityId; }

    public LocalDateTime getSavedAt() { return savedAt; }
    public void setSavedAt(LocalDateTime savedAt) { this.savedAt = savedAt; }

    public String getOpportunityTitle() { return opportunityTitle; }
    public void setOpportunityTitle(String opportunityTitle) { this.opportunityTitle = opportunityTitle; }

    public String getOrganizationName() { return organizationName; }
    public void setOrganizationName(String organizationName) { this.organizationName = organizationName; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getStartDate() { return startDate; }
    public void setStartDate(String startDate) { this.startDate = startDate; }
}