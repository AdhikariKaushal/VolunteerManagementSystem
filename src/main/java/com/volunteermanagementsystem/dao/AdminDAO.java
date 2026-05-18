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