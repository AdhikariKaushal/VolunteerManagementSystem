package com.volunteermanagementsystem.model;

import java.time.LocalDate;

/**
 * Volunteer Model
 * Author: Darpan Ghimire
 */
public class Volunteer {

    private int id;
    private int userId;       // FK → users table
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private String skills;
    private LocalDate dateOfBirth;
    private String gender;
    private String bio;
    private int totalHours;

    public Volunteer() {}

    public Volunteer(int userId, String fullName, String email, String phone,
                     String address, String skills, LocalDate dateOfBirth,
                     String gender, String bio) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.address = address;
        this.skills = skills;
        this.dateOfBirth = dateOfBirth;
        this.gender = gender;
        this.bio = bio;
        this.totalHours = 0;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public int getTotalHours() { return totalHours; }
    public void setTotalHours(int totalHours) { this.totalHours = totalHours; }
}