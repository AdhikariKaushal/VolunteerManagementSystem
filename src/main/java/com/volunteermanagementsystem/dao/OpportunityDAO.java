package com.volunteermanagementsystem.dao;

import com.volunteermanagementsystem.model.Opportunity;
import com.volunteermanagementsystem.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OpportunityDAO {

    /** Create a new opportunity. */
    public boolean create(Opportunity opp) {
        String sql = "INSERT INTO opportunity (org_id, title, description, location, category, slots, deadline) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1,    opp.getOrgId());
            ps.setString(2, opp.getTitle());
            ps.setString(3, opp.getDescription());
            ps.setString(4, opp.getLocation());
            ps.setString(5, opp.getCategory());
            ps.setInt(6,    opp.getSlots());
            ps.setDate(7,   opp.getDeadline());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[OpportunityDAO.create] " + e.getMessage());
            return false;
        }
    }

    /**
     * All opportunities across ALL organizations — used by admin manageOpportunities.jsp.
     * FIX: replaces the old stub getAllOpportunities() that returned an empty list.
     */
    public List<Opportunity> findAll() {
        List<Opportunity> list = new ArrayList<>();
        String sql = "SELECT o.*, org.org_name FROM opportunity o " +
                "JOIN organization org ON o.org_id = org.org_id " +
                "ORDER BY o.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[OpportunityDAO.findAll] " + e.getMessage());
        }
        return list;
    }

    /** All opportunities by this org (for org dashboard list). */
    public List<Opportunity> findByOrg(int orgId) {
        List<Opportunity> list = new ArrayList<>();
        String sql = "SELECT o.*, org.org_name FROM opportunity o " +
                "JOIN organization org ON o.org_id = org.org_id " +
                "WHERE o.org_id = ? ORDER BY o.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orgId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("[OpportunityDAO.findByOrg] " + e.getMessage());
        }
        return list;
    }

    /** Single opportunity by ID. */
    public Opportunity findById(int oppId) {
        String sql = "SELECT o.*, org.org_name FROM opportunity o " +
                "JOIN organization org ON o.org_id = org.org_id " +
                "WHERE o.opp_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, oppId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[OpportunityDAO.findById] " + e.getMessage());
        }
        return null;
    }

    /** Update opportunity — org_id check ensures org owns it. */
    public boolean update(Opportunity opp) {
        String sql = "UPDATE opportunity SET title=?, description=?, location=?, category=?, " +
                "slots=?, deadline=?, status=? WHERE opp_id=? AND org_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, opp.getTitle());
            ps.setString(2, opp.getDescription());
            ps.setString(3, opp.getLocation());
            ps.setString(4, opp.getCategory());
            ps.setInt(5,    opp.getSlots());
            ps.setDate(6,   opp.getDeadline());
            ps.setString(7, opp.getStatus());
            ps.setInt(8,    opp.getOppId());
            ps.setInt(9,    opp.getOrgId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[OpportunityDAO.update] " + e.getMessage());
            return false;
        }
    }

    /** Delete opportunity — org_id check ensures org owns it. */
    public boolean delete(int oppId, int orgId) {
        String sql = "DELETE FROM opportunity WHERE opp_id=? AND org_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, oppId);
            ps.setInt(2, orgId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[OpportunityDAO.delete] " + e.getMessage());
            return false;
        }
    }

    private Opportunity mapRow(ResultSet rs) throws SQLException {
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
}
