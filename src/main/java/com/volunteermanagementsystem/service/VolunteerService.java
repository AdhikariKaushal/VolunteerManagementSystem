package com.volunteermanagementsystem.service;

import com.volunteermanagementsystem.dao.VolunteerDAO;
import com.volunteermanagementsystem.model.Volunteer;
import com.volunteermanagementsystem.model.Wishlist;

import java.sql.SQLException;
import java.util.List;

/**
 * VolunteerService - Business logic layer for volunteer operations
 * Author: Darpan Ghimire
 */
public class VolunteerService {

    private VolunteerDAO volunteerDAO = new VolunteerDAO();

    public int registerVolunteer(Volunteer v) throws SQLException {
        return volunteerDAO.registerVolunteer(v);
    }

    public Volunteer getVolunteerByUserId(int userId) throws SQLException {
        return volunteerDAO.getVolunteerByUserId(userId);
    }

    public Volunteer getVolunteerById(int volunteerId) throws SQLException {
        return volunteerDAO.getVolunteerById(volunteerId);
    }

    public boolean updateVolunteer(Volunteer v) throws SQLException {
        return volunteerDAO.updateVolunteer(v);
    }

    public boolean applyForOpportunity(int volunteerId, int opportunityId) throws SQLException {
        return volunteerDAO.applyForOpportunity(volunteerId, opportunityId);
    }

    public List<Object[]> getApplicationHistory(int volunteerId) throws SQLException {
        return volunteerDAO.getApplicationHistory(volunteerId);
    }

    public List<Object[]> getAllOpenOpportunities() throws SQLException {
        return volunteerDAO.getAllOpenOpportunities();
    }

    public List<Object[]> searchOpportunities(String keyword) throws SQLException {
        return volunteerDAO.searchOpportunities(keyword);
    }

    public int getTotalHours(int volunteerId) throws SQLException {
        return volunteerDAO.getTotalHours(volunteerId);
    }

    public boolean addToWishlist(int volunteerId, int opportunityId) throws SQLException {
        return volunteerDAO.addToWishlist(volunteerId, opportunityId);
    }

    public boolean removeFromWishlist(int volunteerId, int opportunityId) throws SQLException {
        return volunteerDAO.removeFromWishlist(volunteerId, opportunityId);
    }

    public List<Wishlist> getWishlist(int volunteerId) throws SQLException {
        return volunteerDAO.getWishlist(volunteerId);
    }
}