package com.volunteermanagementsystem.model;

public class Organization {
    private int orgId;
    private int userId;
    private String orgName;
    private String orgType;
    private String phone;
    private String address;
    private String description;

    public int getOrgId()                            { return orgId; }
    public void setOrgId(int orgId)                  { this.orgId = orgId; }
    public int getUserId()                           { return userId; }
    public void setUserId(int userId)                { this.userId = userId; }
    public String getOrgName()                       { return orgName; }
    public void setOrgName(String orgName)           { this.orgName = orgName; }
    public String getOrgType()                       { return orgType; }
    public void setOrgType(String orgType)           { this.orgType = orgType; }
    public String getPhone()                         { return phone; }
    public void setPhone(String phone)               { this.phone = phone; }
    public String getAddress()                       { return address; }
    public void setAddress(String address)           { this.address = address; }
    public String getDescription()                   { return description; }
    public void setDescription(String description)   { this.description = description; }
}