package com.volunteermanagementsystem.service;

import com.volunteermanagementsystem.dao.AdminDAO;
import com.volunteermanagementsystem.dao.OrganizationDAO;
import com.volunteermanagementsystem.dao.UserDAO;
import com.volunteermanagementsystem.model.Admin;
import com.volunteermanagementsystem.model.Organization;
import com.volunteermanagementsystem.model.User;

import java.util.List;

/**
 * AdminService - Handles admin business logic
 * Author: Kaushal Adhikari
 * Group: The GOAT
 */
public class AdminService {

    private UserDAO userDAO   = new UserDAO();
    private AdminDAO adminDAO = new AdminDAO();
    private OrganizationDAO organizationDAO = new OrganizationDAO();

    /**
     * Returns admin profile by user ID
     */
    public Admin getAdminByUserId(int userId) {
        return adminDAO.getAdminByUserId(userId);
    }

    /**
     * Returns all users in the system
     */
    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    /**
     * Returns all pending registration requests
     */
    public List<User> getPendingUsers() {
        return userDAO.getPendingUsers();
    }

    public List<Organization> getPendingOrganizations() {
        return organizationDAO.getPendingOrganizations();
    }

    /**
     * Approves a user registration
     */
    public boolean approveUser(int userId) {
        return userDAO.updateUserStatus(userId, "active");
    }

    /**
     * Rejects a user registration
     */
    public boolean rejectUser(int userId) {
        return userDAO.updateUserStatus(userId, "deactivated");
    }

    /**
     * Deactivates an active user account
     */
    public boolean deactivateUser(int userId) {
        return userDAO.updateUserStatus(userId, "deactivated");
    }

    public boolean approveOrganization(int orgId) {
        return organizationDAO.updateOrganizationStatus(orgId, "active");
    }

    public boolean rejectOrganization(int orgId) {
        return organizationDAO.updateOrganizationStatus(orgId, "deactivated");
    }

    /**
     * Returns summary report counts for admin dashboard
     */
    public int getTotalVolunteers() {
        return userDAO.countUsersByRole("volunteer");
    }

    public int getTotalOrganizations() {
        return userDAO.countUsersByRole("organization");
    }

    public int getTotalOpportunities() {
        return adminDAO.countOpportunities();
    }

    public int getTotalApplications() {
        return adminDAO.countApplications();
    }
}