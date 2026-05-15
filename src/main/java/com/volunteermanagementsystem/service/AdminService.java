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
     * Deactivates an active user account.
     * @return null on success, or an error message on failure
     */
    public String deactivateUser(int userId, int actingAdminId) {
        User target = userDAO.getUserById(userId);
        if (target == null) {
            return "User not found.";
        }
        if ("admin".equalsIgnoreCase(target.getRole())) {
            return "Admin accounts cannot be deactivated.";
        }
        if (actingAdminId == userId) {
            return "You cannot deactivate your own account.";
        }
        String status = target.getStatus() == null ? "" : target.getStatus().trim();
        if (!"active".equalsIgnoreCase(status)) {
            return "Only active accounts can be deactivated.";
        }
        return userDAO.updateUserStatus(userId, "deactivated")
                ? null
                : "Failed to deactivate user. Please try again.";
    }

    /**
     * Reactivates a deactivated user account.
     * @return null on success, or an error message on failure
     */
    public String activateUser(int userId) {
        User target = userDAO.getUserById(userId);
        if (target == null) {
            return "User not found.";
        }
        if ("admin".equalsIgnoreCase(target.getRole())) {
            return "Admin accounts cannot be changed from this screen.";
        }
        String status = target.getStatus() == null ? "" : target.getStatus().trim();
        if (!"deactivated".equalsIgnoreCase(status)) {
            return "Only deactivated accounts can be reactivated.";
        }
        return userDAO.updateUserStatus(userId, "active")
                ? null
                : "Failed to activate user. Please try again.";
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