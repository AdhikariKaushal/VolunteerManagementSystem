package com.volunteermanagementsystem.dao;

import com.volunteermanagementsystem.model.Organization;
import com.volunteermanagementsystem.util.DBConnection;

import java.sql.*;

public class OrganizationDAO {

    /** Insert new organization (status = pending by default). */
    public boolean register(Organization org) {
        String sql = "INSERT INTO organization (org_name, email, password, org_type, description, website, phone, address) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, org.getOrgName());
            ps.setString(2, org.getEmail());
            ps.setString(3, org.getPassword());
            ps.setString(4, org.getOrgType());
            ps.setString(5, org.getDescription());
            ps.setString(6, org.getWebsite());
            ps.setString(7, org.getPhone());
            ps.setString(8, org.getAddress());
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("[OrganizationDAO.register] " + e.getMessage());
            return false;
        }
    }

    /** Find by email — used during login. */
    public Organization findByEmail(String email) {
        String sql = "SELECT * FROM organization WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[OrganizationDAO.findByEmail] " + e.getMessage());
        }
        return null;
    }

    /** Find by primary key. */
    public Organization findById(int orgId) {
        String sql = "SELECT * FROM organization WHERE org_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orgId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            System.err.println("[OrganizationDAO.findById] " + e.getMessage());
        }
        return null;
    }

    /** Check if email is already registered. */
    public boolean emailExists(String email) {
        String sql = "SELECT org_id FROM organization WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.err.println("[OrganizationDAO.emailExists] " + e.getMessage());
        }
        return false;
    }

    /** Check if phone is already registered. */
    public boolean phoneExists(String phone) {
        String sql = "SELECT org_id FROM organization WHERE phone = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            System.err.println("[OrganizationDAO.phoneExists] " + e.getMessage());
        }
        return false;
    }

    /** Update profile fields (not email/password/status). */
    public boolean updateProfile(Organization org) {
        String sql = "UPDATE organization SET org_name=?, org_type=?, description=?, website=?, phone=?, address=? " +
                "WHERE org_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, org.getOrgName());
            ps.setString(2, org.getOrgType());
            ps.setString(3, org.getDescription());
            ps.setString(4, org.getWebsite());
            ps.setString(5, org.getPhone());
            ps.setString(6, org.getAddress());
            ps.setInt(7,    org.getOrgId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[OrganizationDAO.updateProfile] " + e.getMessage());
            return false;
        }
    }

    private Organization mapRow(ResultSet rs) throws SQLException {
        Organization org = new Organization();
        org.setOrgId(rs.getInt("org_id"));
        org.setOrgName(rs.getString("org_name"));
        org.setEmail(rs.getString("email"));
        org.setPassword(rs.getString("password"));
        org.setOrgType(rs.getString("org_type"));
        org.setDescription(rs.getString("description"));
        org.setWebsite(rs.getString("website"));
        org.setPhone(rs.getString("phone"));
        org.setAddress(rs.getString("address"));
        org.setStatus(rs.getString("status"));
        org.setCreatedAt(rs.getTimestamp("created_at"));
        return org;
    }
}