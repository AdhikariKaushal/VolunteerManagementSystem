package com.volunteermanagementsystem.dao;

import com.volunteermanagementsystem.model.Organization;
import com.volunteermanagementsystem.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrganizationDAO {

    private String lastError;

    public String getLastError() {
        return lastError;
    }

    private void setLastError(String method, Exception e) {
        String msg = e.getMessage() == null ? e.getClass().getSimpleName() : e.getMessage();
        lastError = method + ": " + msg;
        System.err.println("[OrganizationDAO." + method + "] " + msg);
    }

    /**
     * Schema-aligned registration:
     * 1) Insert credentials into users (role=organization, status=pending)
     * 2) Insert profile into organizations with generated user_id
     */
    public boolean register(Organization org) {
        lastError = null;
        String userSql = "INSERT INTO users (email, password, role, status) VALUES (?, ?, 'organization', 'pending')";
        String orgSql = "INSERT INTO organizations (user_id, org_name, org_type, phone, address, description) VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int userId;
            try (PreparedStatement userPs = conn.prepareStatement(userSql, Statement.RETURN_GENERATED_KEYS)) {
                userPs.setString(1, org.getEmail());
                userPs.setString(2, org.getPassword());
                userPs.executeUpdate();
                try (ResultSet keys = userPs.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new SQLException("Failed to create organization user account.");
                    }
                    userId = keys.getInt(1);
                }
            }

            try (PreparedStatement orgPs = conn.prepareStatement(orgSql)) {
                orgPs.setInt(1, userId);
                orgPs.setString(2, org.getOrgName());
                orgPs.setString(3, org.getOrgType());
                orgPs.setString(4, org.getPhone());
                orgPs.setString(5, org.getAddress());
                orgPs.setString(6, org.getDescription());
                orgPs.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            setLastError("register", e);
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    setLastError("registerRollback", rollbackEx);
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ignored) {}
            }
        }
    }

    public Organization findByEmail(String email) {
        lastError = null;
        String sql = "SELECT o.org_id, o.user_id, o.org_name, o.org_type, o.phone, o.address, o.description, " +
                "u.email, u.password, u.status, u.created_at " +
                "FROM organizations o JOIN users u ON o.user_id = u.user_id " +
                "WHERE LOWER(u.email) = LOWER(?) AND u.role = 'organization'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            setLastError("findByEmail", e);
        }
        return null;
    }

    public Organization findById(int orgId) {
        lastError = null;
        String sql = "SELECT o.org_id, o.user_id, o.org_name, o.org_type, o.phone, o.address, o.description, " +
                "u.email, u.password, u.status, u.created_at " +
                "FROM organizations o JOIN users u ON o.user_id = u.user_id " +
                "WHERE o.org_id = ? AND u.role = 'organization'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orgId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            setLastError("findById", e);
        }
        return null;
    }

    public boolean emailExists(String email) {
        lastError = null;
        String sql = "SELECT user_id FROM users WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            setLastError("emailExists", e);
        }
        return false;
    }

    public boolean phoneExists(String phone) {
        lastError = null;
        String sql = "SELECT org_id FROM organizations WHERE phone = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            return ps.executeQuery().next();
        } catch (SQLException e) {
            setLastError("phoneExists", e);
        }
        return false;
    }

    public boolean updateProfile(Organization org) {
        lastError = null;
        String sql = "UPDATE organizations SET org_name=?, org_type=?, description=?, phone=?, address=? WHERE org_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, org.getOrgName());
            ps.setString(2, org.getOrgType());
            ps.setString(3, org.getDescription());
            ps.setString(4, org.getPhone());
            ps.setString(5, org.getAddress());
            ps.setInt(6, org.getOrgId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            setLastError("updateProfile", e);
            return false;
        }
    }

    public List<Organization> getPendingOrganizations() {
        lastError = null;
        List<Organization> organizations = new ArrayList<>();
        String sql = "SELECT o.org_id, o.user_id, o.org_name, o.org_type, o.phone, o.address, o.description, " +
                "u.email, u.password, u.status, u.created_at " +
                "FROM organizations o JOIN users u ON o.user_id = u.user_id " +
                "WHERE u.role = 'organization' AND u.status = 'pending' ORDER BY u.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                organizations.add(mapRow(rs));
            }
        } catch (SQLException e) {
            setLastError("getPendingOrganizations", e);
        }
        return organizations;
    }

    public boolean updateOrganizationStatus(int orgId, String status) {
        lastError = null;
        String sql = "UPDATE users u JOIN organizations o ON u.user_id = o.user_id SET u.status = ? WHERE o.org_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orgId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            setLastError("updateOrganizationStatus", e);
            return false;
        }
    }

    private Organization mapRow(ResultSet rs) throws SQLException {
        Organization org = new Organization();
        org.setOrgId(rs.getInt("org_id"));
        org.setOrgName(rs.getString("org_name"));
        org.setOrgType(rs.getString("org_type"));
        org.setPhone(rs.getString("phone"));
        org.setAddress(rs.getString("address"));
        org.setDescription(rs.getString("description"));
        org.setEmail(rs.getString("email"));
        org.setPassword(rs.getString("password"));
        org.setStatus(rs.getString("status"));
        org.setCreatedAt(rs.getTimestamp("created_at"));
        return org;
    }
}