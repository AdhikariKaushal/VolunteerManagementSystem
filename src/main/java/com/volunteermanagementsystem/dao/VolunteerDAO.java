package com.volunteermanagementsystem.dao;

import com.volunteermanagementsystem.model.Volunteer;
import com.volunteermanagementsystem.model.Wishlist;
import com.volunteermanagementsystem.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * VolunteerDAO
 * Author: Darpan Ghimire
 */
public class VolunteerDAO {

    // ─── REGISTRATION ────────────────────────────────────────────────────────

    public int registerVolunteer(Volunteer v) throws SQLException {
        String sql = "INSERT INTO volunteers (user_id, full_name, phone, address, " +
                "skills, date_of_birth, total_hours) " +
                "VALUES (?, ?, ?, ?, ?, ?, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, v.getUserId());
            ps.setString(2, v.getFullName());
            ps.setString(3, v.getPhone());
            ps.setString(4, v.getAddress());
            ps.setString(5, v.getSkills());
            ps.setDate(6, v.getDateOfBirth() != null ? Date.valueOf(v.getDateOfBirth()) : null);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next())
                    return rs.getInt(1);
            }
        }
        return -1;
    }

    // ─── PROFILE ─────────────────────────────────────────────────────────────

    public Volunteer getVolunteerByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM volunteers WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapRow(rs);
        }
        return null;
    }

    public Volunteer getVolunteerById(int volunteerId) throws SQLException {
        String sql = "SELECT * FROM volunteers WHERE volunteer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return mapRow(rs);
        }
        return null;
    }

    public boolean updateVolunteer(Volunteer v) throws SQLException {
        String sql = "UPDATE volunteers SET full_name=?, phone=?, address=?, skills=?, " +
                "date_of_birth=? WHERE volunteer_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, v.getFullName());
            ps.setString(2, v.getPhone());
            ps.setString(3, v.getAddress());
            ps.setString(4, v.getSkills());
            ps.setDate(5, v.getDateOfBirth() != null ? Date.valueOf(v.getDateOfBirth()) : null);
            ps.setInt(6, v.getId());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── APPLICATIONS ────────────────────────────────────────────────────────

    public boolean applyForOpportunity(int volunteerId, int opportunityId) throws SQLException {
        if (hasAlreadyApplied(volunteerId, opportunityId))
            return false;

        String sql = "INSERT INTO applications (volunteer_id, opportunity_id, status) " +
                "VALUES (?, ?, 'pending')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ps.setInt(2, opportunityId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean hasAlreadyApplied(int volunteerId, int opportunityId) throws SQLException {
        String sql = "SELECT application_id FROM applications " +
                "WHERE volunteer_id=? AND opportunity_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ps.setInt(2, opportunityId);
            return ps.executeQuery().next();
        }
    }

    public List<Object[]> getApplicationHistory(int volunteerId) throws SQLException {
        String sql = "SELECT a.application_id, o.title, org.org_name, a.status, a.applied_at " +
                "FROM applications a " +
                "JOIN opportunities o ON a.opportunity_id = o.opportunity_id " +
                "JOIN organizations org ON o.org_id = org.org_id " +
                "WHERE a.volunteer_id = ? " +
                "ORDER BY a.applied_at DESC";

        List<Object[]> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Object[]{
                        rs.getInt("application_id"),
                        rs.getString("title"),
                        rs.getString("org_name"),
                        rs.getString("status"),
                        rs.getTimestamp("applied_at")
                });
            }
        }
        return list;
    }

    // ─── OPPORTUNITIES (browse) ───────────────────────────────────────────────

    public List<Object[]> getAllOpenOpportunities() throws SQLException {
        String sql = "SELECT o.opportunity_id, o.title, org.org_name, o.location, " +
                "o.event_date, o.slots, o.category " +
                "FROM opportunities o " +
                "JOIN organizations org ON o.org_id = org.org_id " +
                "ORDER BY o.event_date ASC";

        List<Object[]> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Object[]{
                        rs.getInt("opportunity_id"),
                        rs.getString("title"),
                        rs.getString("org_name"),
                        rs.getString("location"),
                        rs.getString("event_date"),
                        rs.getInt("slots"),
                        rs.getString("category")
                });
            }
        }
        return list;
    }

    public List<Object[]> searchOpportunities(String keyword) throws SQLException {
        String sql = "SELECT o.opportunity_id, o.title, org.org_name, o.location, " +
                "o.event_date, o.slots, o.category " +
                "FROM opportunities o " +
                "JOIN organizations org ON o.org_id = org.org_id " +
                "WHERE o.title LIKE ? OR o.location LIKE ? OR o.category LIKE ? " +
                "ORDER BY o.event_date ASC";

        List<Object[]> list = new ArrayList<>();
        String kw = "%" + keyword + "%";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, kw);
            ps.setString(2, kw);
            ps.setString(3, kw);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Object[]{
                        rs.getInt("opportunity_id"),
                        rs.getString("title"),
                        rs.getString("org_name"),
                        rs.getString("location"),
                        rs.getString("event_date"),
                        rs.getInt("slots"),
                        rs.getString("category")
                });
            }
        }
        return list;
    }

    // ─── TOTAL HOURS ─────────────────────────────────────────────────────────

    public int getTotalHours(int volunteerId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(hours_logged), 0) FROM attendance " +
                "WHERE volunteer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        }
        return 0;
    }

    // ─── WISHLIST ────────────────────────────────────────────────────────────

    public boolean addToWishlist(int volunteerId, int opportunityId) throws SQLException {
        if (isInWishlist(volunteerId, opportunityId))
            return false;

        String sql = "INSERT INTO wishlist (volunteer_id, opportunity_id, saved_at) " +
                "VALUES (?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ps.setInt(2, opportunityId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean removeFromWishlist(int volunteerId, int opportunityId) throws SQLException {
        String sql = "DELETE FROM wishlist WHERE volunteer_id=? AND opportunity_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ps.setInt(2, opportunityId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean isInWishlist(int volunteerId, int opportunityId) throws SQLException {
        String sql = "SELECT volunteer_id FROM wishlist " +
                "WHERE volunteer_id=? AND opportunity_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ps.setInt(2, opportunityId);
            return ps.executeQuery().next();
        }
    }

    public List<Wishlist> getWishlist(int volunteerId) throws SQLException {
        String sql = "SELECT w.volunteer_id, w.opportunity_id, w.saved_at, " +
                "o.title, org.org_name as org_name, o.location, o.event_date " +
                "FROM wishlist w " +
                "JOIN opportunities o ON w.opportunity_id = o.opportunity_id " +
                "JOIN organizations org ON o.org_id = org.org_id " +
                "WHERE w.volunteer_id = ? ORDER BY w.saved_at DESC";

        List<Wishlist> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Wishlist w = new Wishlist();
                w.setVolunteerId(rs.getInt("volunteer_id"));
                w.setOpportunityId(rs.getInt("opportunity_id"));
                w.setSavedAt(rs.getTimestamp("saved_at").toLocalDateTime());
                w.setOpportunityTitle(rs.getString("title"));
                w.setOrganizationName(rs.getString("org_name"));
                w.setLocation(rs.getString("location"));
                w.setStartDate(rs.getString("event_date"));
                list.add(w);
            }
        }
        return list;
    }

    // ─── HELPER ──────────────────────────────────────────────────────────────

    private Volunteer mapRow(ResultSet rs) throws SQLException {
        Volunteer v = new Volunteer();
        v.setId(rs.getInt("volunteer_id"));
        v.setUserId(rs.getInt("user_id"));
        v.setFullName(rs.getString("full_name"));
        v.setPhone(rs.getString("phone"));
        v.setAddress(rs.getString("address"));
        v.setSkills(rs.getString("skills"));
        Date dob = rs.getDate("date_of_birth");
        if (dob != null)
            v.setDateOfBirth(dob.toLocalDate());
        v.setTotalHours(rs.getInt("total_hours"));
        return v;
    }
}