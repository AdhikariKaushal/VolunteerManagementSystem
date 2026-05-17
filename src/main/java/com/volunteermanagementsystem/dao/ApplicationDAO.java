package com.volunteermanagementsystem.dao;

import com.volunteermanagementsystem.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class ApplicationDAO {

    public boolean updateApplicationStatus(int applicationId, String status) {

        boolean updated = false;

        try {

            Connection conn = DBConnection.getConnection();

            System.out.println("Database Connected");

            String sql =
                    "UPDATE application SET status=? WHERE app_id=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setString(1, status);
            ps.setInt(2, applicationId);

            int rows = ps.executeUpdate();

            System.out.println("Rows Updated: " + rows);

            if (rows > 0) {
                updated = true;
            }

            conn.close();

        } catch (Exception e) {

            e.printStackTrace();

        }

        return updated;
    }
}