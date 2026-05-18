package com.volunteermanagementsystem.dao;

import com.volunteermanagementsystem.model.Admin;
import com.volunteermanagementsystem.model.Opportunity;
import com.volunteermanagementsystem.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AdminDAO - Handles all SQL operations for the admins table
 * Author: Kaushal Adhikari
 * Group: The GOAT
 */
public class AdminDAO {

    /**
     * Gets admin profile by user_id
     */
    public Admin getAdminByUserId(int userId) {
        String sql = "SELECT * FROM admins WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAdmin(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting admin: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    /**
     * Returns total count of opportunities
     * Used for admin summary report
     */
    public int countOpportunities() {
        String sql = "SELECT COUNT(*) FROM opportunities";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting opportunities: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return 0;
    }

    /**
     * Returns total count of applications
     * Used for admin summary report
     */
    public int countApplications() {
        String sql = "SELECT COUNT(*) FROM applications";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting applications: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return 0;
    }

    /**
     * Returns ALL opportunities across all organisations, joined with org name.
     * Admin read-only — does NOT touch org CRUD.
     * Author: Kaushal Adhikari
     */
    public List<Opportunity> getAllOpportunities() {
        List<Opportunity> list = new ArrayList<>();
        String sql = "SELECT o.*, org.org_name " +
                     "FROM opportunity o " +
                     "JOIN organizations org ON o.org_id = org.org_id " +
                     "ORDER BY o.created_at DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapOpportunityRow(rs));
            }
        } catch (SQLException e) {
            System.err.println("[AdminDAO.getAllOpportunities] " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    /**
     * Admin flags an opportunity as suspicious/inappropriate.
     * Sets status = 'flagged' — org can still see it, admin monitors it.
     * Author: Kaushal Adhikari
     */
    public boolean flagOpportunity(int oppId) {
        return updateOpportunityStatus(oppId, "flagged");
    }

    /**
     * Admin un-flags an opportunity (restores it to 'open').
     * Author: Kaushal Adhikari
     */
    public boolean unflagOpportunity(int oppId) {
        return updateOpportunityStatus(oppId, "open");
    }

    /**
     * Admin removes an inappropriate opportunity permanently.
     * Author: Kaushal Adhikari
     */
    public boolean removeOpportunity(int oppId) {
        String sql = "DELETE FROM opportunity WHERE opp_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, oppId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[AdminDAO.removeOpportunity] " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    /**
     * Returns the last 5 registered users for recent activity.
     * Author: Kaushal Adhikari
     */
    public List<com.volunteermanagementsystem.model.User> getRecentRegistrations() {
        List<com.volunteermanagementsystem.model.User> list = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role IN ('volunteer', 'organization') " +
                "ORDER BY created_at DESC LIMIT 5";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                com.volunteermanagementsystem.model.User u = new com.volunteermanagementsystem.model.User();
                u.setUserId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.err.println("[AdminDAO.getRecentRegistrations] " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    /**
     * Returns ALL applications across the platform for admin oversight.
     * Joins application → volunteer → users → opportunity → organizations
     * Author: Kaushal Adhikari
     */
    public List<com.volunteermanagementsystem.model.Application> getAllApplications() {
        List<com.volunteermanagementsystem.model.Application> list = new ArrayList<>();
        String sql =
                "SELECT a.app_id, a.opp_id, a.vol_id, a.status, a.applied_at, " +
                        "       v.full_name AS volunteer_name, " +
                        "       u.email     AS volunteer_email, " +
                        "       o.title     AS opportunity_title, " +
                        "       org.org_name AS organization_name " +
                        "FROM application a " +
                        "JOIN volunteer    v   ON a.vol_id  = v.vol_id " +
                        "JOIN users        u   ON v.user_id = u.user_id " +
                        "JOIN opportunity  o   ON a.opp_id  = o.opp_id " +
                        "JOIN organizations org ON o.org_id = org.org_id " +
                        "ORDER BY a.applied_at DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                com.volunteermanagementsystem.model.Application app =
                        new com.volunteermanagementsystem.model.Application();
                app.setAppId(rs.getInt("app_id"));
                app.setOppId(rs.getInt("opp_id"));
                app.setVolId(rs.getInt("vol_id"));
                app.setStatus(rs.getString("status"));
                app.setAppliedAt(rs.getTimestamp("applied_at"));
                app.setVolunteerName(rs.getString("volunteer_name"));
                app.setVolunteerEmail(rs.getString("volunteer_email"));
                app.setOpportunityTitle(rs.getString("opportunity_title"));
                app.setOrganizationName(rs.getString("organization_name"));
                list.add(app);
            }
        } catch (SQLException e) {
            System.err.println("[AdminDAO.getAllApplications] " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // ── private helpers ───────────────────────────────────────────────────────

    private boolean updateOpportunityStatus(int oppId, String newStatus) {
        String sql = "UPDATE opportunity SET status = ? WHERE opp_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, oppId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[AdminDAO.updateOpportunityStatus] " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    private Opportunity mapOpportunityRow(ResultSet rs) throws SQLException {
        Opportunity opp = new Opportunity();
        opp.setOppId(rs.getInt("opp_id"));
        opp.setOrgId(rs.getInt("org_id"));
        opp.setTitle(rs.getString("title"));
        opp.setDescription(rs.getString("description"));
        opp.setLocation(rs.getString("location"));
        opp.setCategory(rs.getString("category"));
        opp.setSlots(rs.getInt("slots"));
        opp.setDeadline(rs.getDate("deadline"));
        opp.setStatus(rs.getString("status"));
        opp.setCreatedAt(rs.getTimestamp("created_at"));
        try { opp.setOrgName(rs.getString("org_name")); } catch (SQLException ignored) {}
        return opp;
    }

    /**
     * Maps a ResultSet row to an Admin object
     */
    private Admin mapResultSetToAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setAdminId(rs.getInt("admin_id"));
        admin.setUserId(rs.getInt("user_id"));
        admin.setFullName(rs.getString("full_name"));
        admin.setPhone(rs.getString("phone"));
        return admin;
    }
}