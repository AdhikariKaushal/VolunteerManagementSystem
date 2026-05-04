package com.volunteermanagementsystem.dao;

import com.volunteermanagementsystem.model.Attendance;
import com.volunteermanagementsystem.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AttendanceDAO - Handles all SQL operations for the attendance table
 * Author: Oshan
 * Group: The GOAT
 */
public class AttendanceDAO {

    public boolean logAttendance(Attendance a) {
        String sql = "INSERT INTO attendance (application_id, volunteer_id, opportunity_id, status, hours_logged, logged_at) " +
                "VALUES (?, ?, ?, ?, ?, NOW())";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, a.getApplicationId());
            ps.setInt(2, a.getVolunteerId());
            ps.setInt(3, a.getOpportunityId());
            ps.setString(4, a.getStatus());
            ps.setDouble(5, a.getHoursLogged());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error logging attendance: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    public boolean updateAttendance(Attendance a) {
        String sql = "UPDATE attendance SET status = ?, hours_logged = ? WHERE attendance_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, a.getStatus());
            ps.setDouble(2, a.getHoursLogged());
            ps.setInt(3, a.getAttendanceId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating attendance: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    public boolean alreadyLogged(int applicationId) {
        String sql = "SELECT attendance_id FROM attendance WHERE application_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, applicationId);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.err.println("Error checking duplicate: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return false;
    }

    // {attendanceId, volunteerName, status, hoursLogged, loggedAt}
    public List<Object[]> getAttendanceByOpportunity(int opportunityId) {
        String sql = "SELECT a.attendance_id, v.full_name, a.status, a.hours_logged, a.logged_at " +
                "FROM attendance a JOIN volunteers v ON a.volunteer_id = v.id " +
                "WHERE a.opportunity_id = ? ORDER BY a.logged_at DESC";
        List<Object[]> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, opportunityId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Object[]{
                        rs.getInt("attendance_id"),
                        rs.getString("full_name"),
                        rs.getString("status"),
                        rs.getDouble("hours_logged"),
                        rs.getTimestamp("logged_at")
                });
            }
        } catch (SQLException e) {
            System.err.println("Error fetching by opportunity: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // {opportunityTitle, orgName, status, hoursLogged, loggedAt}
    public List<Object[]> getAttendanceByVolunteer(int volunteerId) {
        String sql = "SELECT o.title, org.name, a.status, a.hours_logged, a.logged_at " +
                "FROM attendance a " +
                "JOIN opportunities o ON a.opportunity_id = o.id " +
                "JOIN organizations org ON o.organization_id = org.id " +
                "WHERE a.volunteer_id = ? ORDER BY a.logged_at DESC";
        List<Object[]> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Object[]{
                        rs.getString("title"),
                        rs.getString("name"),
                        rs.getString("status"),
                        rs.getDouble("hours_logged"),
                        rs.getTimestamp("logged_at")
                });
            }
        } catch (SQLException e) {
            System.err.println("Error fetching by volunteer: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    public double getTotalHoursByVolunteer(int volunteerId) {
        String sql = "SELECT COALESCE(SUM(hours_logged), 0) FROM attendance WHERE volunteer_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            System.err.println("Error calculating total hours: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return 0.0;
    }
}