package com.volunteermanagementsystem.dao;

import com.volunteermanagementsystem.model.Volunteer;
import com.volunteermanagementsystem.model.Wishlist;
import com.volunteermanagementsystem.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * VolunteerDAO
 * Author: Darpan Ghimire
 */
public class VolunteerDAO {

    // ─── REGISTRATION ────────────────────────────────────────────────────────

    /**
     * Insert a new volunteer profile linked to a user account.
     * Returns the generated volunteer ID, or -1 on failure.
     */
    public int registerVolunteer(Volunteer v) throws SQLException {
        String sql = "INSERT INTO volunteers (user_id, full_name, email, phone, address, " +
                "skills, date_of_birth, gender, bio, total_hours) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, v.getUserId());
            ps.setString(2, v.getFullName());
            ps.setString(3, v.getEmail());
            ps.setString(4, v.getPhone());
            ps.setString(5, v.getAddress());
            ps.setString(6, v.getSkills());
            ps.setDate(7, v.getDateOfBirth() != null ? Date.valueOf(v.getDateOfBirth()) : null);
            ps.setString(8, v.getGender());
            ps.setString(9, v.getBio());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    // ─── PROFILE ─────────────────────────────────────────────────────────────

    /** Get volunteer profile by user ID (used right after login) */
    public Volunteer getVolunteerByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM volunteers WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    /** Get volunteer profile by volunteer primary key */
    public Volunteer getVolunteerById(int volunteerId) throws SQLException {
        String sql = "SELECT * FROM volunteers WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    /** Update volunteer profile details */
    public boolean updateVolunteer(Volunteer v) throws SQLException {
        String sql = "UPDATE volunteers SET full_name=?, phone=?, address=?, skills=?, " +
                "date_of_birth=?, gender=?, bio=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, v.getFullName());
            ps.setString(2, v.getPhone());
            ps.setString(3, v.getAddress());
            ps.setString(4, v.getSkills());
            ps.setDate(5, v.getDateOfBirth() != null ? Date.valueOf(v.getDateOfBirth()) : null);
            ps.setString(6, v.getGender());
            ps.setString(7, v.getBio());
            ps.setInt(8, v.getId());

            return ps.executeUpdate() > 0;
        }
    }

    // ─── APPLICATIONS ────────────────────────────────────────────────────────

    /**
     * Apply to an opportunity — inserts into applications table.
     * Returns false if volunteer already applied.
     */
    public boolean applyForOpportunity(int volunteerId, int opportunityId) throws SQLException {
        // Prevent duplicate applications
        if (hasAlreadyApplied(volunteerId, opportunityId)) return false;

        String sql = "INSERT INTO applications (volunteer_id, opportunity_id, status, applied_at) " +
                "VALUES (?, ?, 'PENDING', NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ps.setInt(2, opportunityId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Check if a volunteer already applied to a specific opportunity */
    public boolean hasAlreadyApplied(int volunteerId, int opportunityId) throws SQLException {
        String sql = "SELECT id FROM applications WHERE volunteer_id=? AND opportunity_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ps.setInt(2, opportunityId);
            return ps.executeQuery().next();
        }
    }

    /**
     * Get all applications for a volunteer with opportunity + org details.
     * Returns list of Object[] rows: {appId, opportunityTitle, orgName, status, appliedAt}
     */
    public List<Object[]> getApplicationHistory(int volunteerId) throws SQLException {
        String sql = "SELECT a.id, o.title, org.name, a.status, a.applied_at " +
                "FROM applications a " +
                "JOIN opportunities o ON a.opportunity_id = o.id " +
                "JOIN organizations org ON o.organization_id = org.id " +
                "WHERE a.volunteer_id = ? " +
                "ORDER BY a.applied_at DESC";

        List<Object[]> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Object[]{
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("name"),
                        rs.getString("status"),
                        rs.getTimestamp("applied_at")
                });
            }
        }
        return list;
    }

    // ─── OPPORTUNITIES (browse) ───────────────────────────────────────────────

    /**
     * Get all OPEN opportunities with organization name.
     * Returns list of Object[]: {oppId, title, orgName, location, startDate, endDate, category}
     */
    public List<Object[]> getAllOpenOpportunities() throws SQLException {
        String sql = "SELECT o.id, o.title, org.name, o.location, o.start_date, o.end_date, o.category " +
                "FROM opportunities o " +
                "JOIN organizations org ON o.organization_id = org.id " +
                "WHERE o.status = 'OPEN' " +
                "ORDER BY o.start_date ASC";

        List<Object[]> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Object[]{
                        rs.getInt("o.id"),
                        rs.getString("title"),
                        rs.getString("name"),
                        rs.getString("location"),
                        rs.getString("start_date"),
                        rs.getString("end_date"),
                        rs.getString("category")
                });
            }
        }
        return list;
    }

    /**
     * Search opportunities by keyword (title or location).
     */
    public List<Object[]> searchOpportunities(String keyword) throws SQLException {
        String sql = "SELECT o.id, o.title, org.name, o.location, o.start_date, o.end_date, o.category " +
                "FROM opportunities o " +
                "JOIN organizations org ON o.organization_id = org.id " +
                "WHERE o.status = 'OPEN' AND (o.title LIKE ? OR o.location LIKE ? OR o.category LIKE ?) " +
                "ORDER BY o.start_date ASC";

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
                        rs.getInt("o.id"),
                        rs.getString("title"),
                        rs.getString("name"),
                        rs.getString("location"),
                        rs.getString("start_date"),
                        rs.getString("end_date"),
                        rs.getString("category")
                });
            }
        }
        return list;
    }

    // ─── TOTAL HOURS ─────────────────────────────────────────────────────────

    /** Get total volunteering hours logged for a volunteer */
    public int getTotalHours(int volunteerId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(hours_logged), 0) FROM attendance WHERE volunteer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    // ─── WISHLIST ────────────────────────────────────────────────────────────

    /** Add opportunity to wishlist */
    public boolean addToWishlist(int volunteerId, int opportunityId) throws SQLException {
        // Don't add duplicates
        if (isInWishlist(volunteerId, opportunityId)) return false;

        String sql = "INSERT INTO wishlist (volunteer_id, opportunity_id, saved_at) VALUES (?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ps.setInt(2, opportunityId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Remove opportunity from wishlist */
    public boolean removeFromWishlist(int volunteerId, int opportunityId) throws SQLException {
        String sql = "DELETE FROM wishlist WHERE volunteer_id=? AND opportunity_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ps.setInt(2, opportunityId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Check if opportunity is already in volunteer's wishlist */
    public boolean isInWishlist(int volunteerId, int opportunityId) throws SQLException {
        String sql = "SELECT id FROM wishlist WHERE volunteer_id=? AND opportunity_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ps.setInt(2, opportunityId);
            return ps.executeQuery().next();
        }
    }

    /** Get all wishlist items for a volunteer (with opportunity details) */
    public List<Wishlist> getWishlist(int volunteerId) throws SQLException {
        String sql = "SELECT w.id, w.volunteer_id, w.opportunity_id, w.saved_at, " +
                "o.title, org.name as org_name, o.location, o.start_date " +
                "FROM wishlist w " +
                "JOIN opportunities o ON w.opportunity_id = o.id " +
                "JOIN organizations org ON o.organization_id = org.id " +
                "WHERE w.volunteer_id = ? ORDER BY w.saved_at DESC";

        List<Wishlist> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Wishlist w = new Wishlist();
                w.setId(rs.getInt("id"));
                w.setVolunteerId(rs.getInt("volunteer_id"));
                w.setOpportunityId(rs.getInt("opportunity_id"));
                w.setSavedAt(rs.getTimestamp("saved_at").toLocalDateTime());
                w.setOpportunityTitle(rs.getString("title"));
                w.setOrganizationName(rs.getString("org_name"));
                w.setLocation(rs.getString("location"));
                w.setStartDate(rs.getString("start_date"));
                list.add(w);
            }
        }
        return list;
    }

    // ─── HELPER ──────────────────────────────────────────────────────────────

    private Volunteer mapRow(ResultSet rs) throws SQLException {
        Volunteer v = new Volunteer();
        v.setId(rs.getInt("id"));
        v.setUserId(rs.getInt("user_id"));
        v.setFullName(rs.getString("full_name"));
        v.setEmail(rs.getString("email"));
        v.setPhone(rs.getString("phone"));
        v.setAddress(rs.getString("address"));
        v.setSkills(rs.getString("skills"));
        Date dob = rs.getDate("date_of_birth");
        if (dob != null) v.setDateOfBirth(dob.toLocalDate());
        v.setGender(rs.getString("gender"));
        v.setBio(rs.getString("bio"));
        v.setTotalHours(rs.getInt("total_hours"));
        return v;
    }
}