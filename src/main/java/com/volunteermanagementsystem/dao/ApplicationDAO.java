package com.volunteermanagementsystem.dao;


import com.volunteermanagementsystem.model.Application;
import com.volunteermanagementsystem.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    /** All applicants for a given opportunity, joined with volunteer info. */
    public List<Application> findByOpportunity(int oppId) {
        List<Application> list = new ArrayList<>();
        String sql = "SELECT a.*, v.full_name AS vol_name, v.email AS vol_email, v.phone AS vol_phone " +
                "FROM application a " +
                "JOIN volunteer v ON a.vol_id = v.vol_id " +
                "WHERE a.opp_id = ? ORDER BY a.applied_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, oppId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Application app = mapRow(rs);
                app.setVolunteerName(rs.getString("vol_name"));
                app.setVolunteerEmail(rs.getString("vol_email"));
                app.setVolunteerPhone(rs.getString("vol_phone"));
                list.add(app);
            }
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO.findByOpportunity] " + e.getMessage());
        }
        return list;
    }

    /** Count approved applications for an opportunity (slot check). */
    public int countApproved(int oppId) {
        String sql = "SELECT COUNT(*) FROM application WHERE opp_id=? AND status='approved'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, oppId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO.countApproved] " + e.getMessage());
        }
        return 0;
    }

    /** Approve or reject an application. */
    public boolean updateStatus(int appId, String status) {
        String sql = "UPDATE application SET status=? WHERE app_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, appId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO.updateStatus] " + e.getMessage());
            return false;
        }
    }

    /** Find a single application by ID. */
    public Application findById(int appId) {
        String sql = "SELECT * FROM application WHERE app_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[ApplicationDAO.findById] " + e.getMessage());
        }
        return null;
    }

    private Application mapRow(ResultSet rs) throws SQLException {
        Application app = new Application();
        app.setAppId(rs.getInt("app_id"));
        app.setOppId(rs.getInt("opp_id"));
        app.setVolId(rs.getInt("vol_id"));
        app.setStatus(rs.getString("status"));
        app.setAppliedAt(rs.getTimestamp("applied_at"));
        return app;
    }
}