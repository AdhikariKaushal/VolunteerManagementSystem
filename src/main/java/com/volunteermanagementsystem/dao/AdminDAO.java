package com.volunteermanagementsystem.dao;

import com.volunteermanagementsystem.model.Admin;
import com.volunteermanagementsystem.util.DBConnection;

import java.sql.*;

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