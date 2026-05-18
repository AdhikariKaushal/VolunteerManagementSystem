package com.volunteermanagementsystem.service;

import com.volunteermanagementsystem.dao.AdminDAO;
import com.volunteermanagementsystem.dao.UserDAO;
import com.volunteermanagementsystem.model.Admin;
import com.volunteermanagementsystem.model.User;

import java.util.List;

public class AdminService {

    private UserDAO userDAO   = new UserDAO();
    private AdminDAO adminDAO = new AdminDAO();

    public Admin getAdminByUserId(int userId) {
        return adminDAO.getAdminByUserId(userId);
    }

    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    public List<User> getPendingUsers() {
        return userDAO.getPendingUsers();
    }

    public boolean approveUser(int userId) {
        return userDAO.updateUserStatus(userId, "active");
    }

    public boolean rejectUser(int userId) {
        return userDAO.updateUserStatus(userId, "deactivated");
    }

    public String deactivateUser(int userId, int actingAdminId) {
        User target = userDAO.getUserById(userId);
        if (target == null)                                return "User not found.";
        if ("admin".equalsIgnoreCase(target.getRole()))    return "Admin accounts cannot be deactivated.";
        if (actingAdminId == userId)                       return "You cannot deactivate your own account.";
        String status = target.getStatus() == null ? "" : target.getStatus().trim();
        if (!"active".equalsIgnoreCase(status))            return "Only active accounts can be deactivated.";
        return userDAO.updateUserStatus(userId, "deactivated")
                ? null : "Failed to deactivate user. Please try again.";
    }

    public String activateUser(int userId) {
        User target = userDAO.getUserById(userId);
        if (target == null)                                return "User not found.";
        if ("admin".equalsIgnoreCase(target.getRole()))    return "Admin accounts cannot be changed from this screen.";
        String status = target.getStatus() == null ? "" : target.getStatus().trim();
        if (!"deactivated".equalsIgnoreCase(status))       return "Only deactivated accounts can be reactivated.";
        return userDAO.updateUserStatus(userId, "active")
                ? null : "Failed to activate user. Please try again.";
    }

    public String deleteUser(int userId, int actingAdminId) {
        User target = userDAO.getUserById(userId);
        if (target == null)                                return "User not found.";
        if ("admin".equalsIgnoreCase(target.getRole()))    return "Admin accounts cannot be deleted.";
        if (actingAdminId == userId)                       return "You cannot delete your own account.";
        String role = target.getRole() == null ? "" : target.getRole().trim();
        if (!"volunteer".equalsIgnoreCase(role) && !"organization".equalsIgnoreCase(role))
            return "Only volunteer and organisation accounts can be deleted.";
        if (userDAO.deleteUserCascade(userId)) return null;
        String detail = userDAO.getLastDeleteError();
        if (detail != null && !detail.isEmpty()) return "Failed to delete user: " + detail;
        return "Failed to delete user. Please try again.";
    }

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