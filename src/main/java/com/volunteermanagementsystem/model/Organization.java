package com.volunteermanagementsystem.model;

import java.sql.Timestamp;

public class Organization {

    private int orgId;
    private String orgName;
    private String email;
    private String password;
    private String orgType;
    private String description;
    private String website;
    private String phone;
    private String address;
    private String status;
    private Timestamp createdAt;

    public Organization() {}

    public int getOrgId()                      { return orgId; }
    public void setOrgId(int orgId)            { this.orgId = orgId; }

    public String getOrgName()                 { return orgName; }
    public void setOrgName(String orgName)     { this.orgName = orgName; }

    public String getEmail()                   { return email; }
    public void setEmail(String email)         { this.email = email; }

    public String getPassword()                { return password; }
    public void setPassword(String password)   { this.password = password; }

    public String getOrgType()                 { return orgType; }
    public void setOrgType(String orgType)     { this.orgType = orgType; }

    public String getDescription()             { return description; }
    public void setDescription(String d)       { this.description = d; }

    public String getWebsite()                 { return website; }
    public void setWebsite(String website)     { this.website = website; }

    public String getPhone()                   { return phone; }
    public void setPhone(String phone)         { this.phone = phone; }

    public String getAddress()                 { return address; }
    public void setAddress(String address)     { this.address = address; }

    public String getStatus()                  { return status; }
    public void setStatus(String status)       { this.status = status; }

    public Timestamp getCreatedAt()            { return createdAt; }
    public void setCreatedAt(Timestamp t)      { this.createdAt = t; }
}