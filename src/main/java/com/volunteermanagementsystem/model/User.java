package com.volunteermanagementsystem.model;

import java.sql.Timestamp;

public class User {

    private int userId;
    private String email;
    private String password;
    private String role;
    private String status;
    private Timestamp createdAt;

    public User() {}

    public User(int userId, String email, String password, String role, String status, Timestamp createdAt) {
        this.userId    = userId;
        this.email     = email;
        this.password  = password;
        this.role      = role;
        this.status    = status;
        this.createdAt = createdAt;
    }

    public int getUserId()                           { return userId; }
    public void setUserId(int userId)                { this.userId = userId; }

    public String getEmail()                         { return email; }
    public void setEmail(String email)               { this.email = email; }

    public String getPassword()                      { return password; }
    public void setPassword(String password)         { this.password = password; }

    public String getRole()                          { return role; }
    public void setRole(String role)                 { this.role = role; }

    public String getStatus()                        { return status; }
    public void setStatus(String status)             { this.status = status; }

    public Timestamp getCreatedAt()                  { return createdAt; }
    public void setCreatedAt(Timestamp createdAt)    { this.createdAt = createdAt; }

    @Override
    public String toString() {
        return "User{userId=" + userId + ", email=" + email + ", role=" + role + ", status=" + status + "}";
    }
}