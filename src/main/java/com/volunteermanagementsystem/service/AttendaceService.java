package com.volunteermanagementsystem.service;

import com.volunteermanagementsystem.dao.AttendanceDAO;
import com.volunteermanagementsystem.model.Attendance;

import java.util.List;

/**
 * AttendaceService - Business logic for attendance
 * Author: Oshan
 * Group: The GOAT
 */
public class AttendaceService {

    private final AttendanceDAO attendanceDAO = new AttendanceDAO();

    // Returns null on success, error string on failure
    public String logAttendance(int applicationId, int volunteerId, int opportunityId,
                                String status, double hoursLogged) {
        if (status == null || (!status.equals("PRESENT") && !status.equals("ABSENT")))
            return "Invalid status. Must be PRESENT or ABSENT.";
        if (hoursLogged < 0)
            return "Hours logged cannot be negative.";
        if (hoursLogged > 24)
            return "Hours logged cannot exceed 24 in a single session.";
        if (status.equals("ABSENT"))
            hoursLogged = 0.0;
        if (attendanceDAO.alreadyLogged(applicationId))
            return "Attendance already logged for this application.";

        Attendance a = new Attendance();
        a.setApplicationId(applicationId);
        a.setVolunteerId(volunteerId);
        a.setOpportunityId(opportunityId);
        a.setStatus(status);
        a.setHoursLogged(hoursLogged);

        return attendanceDAO.logAttendance(a) ? null : "Failed to save. Please try again.";
    }

    public String updateAttendance(int attendanceId, String status, double hoursLogged) {
        if (status == null || (!status.equals("PRESENT") && !status.equals("ABSENT")))
            return "Invalid status.";
        if (hoursLogged < 0 || hoursLogged > 24)
            return "Hours must be between 0 and 24.";
        if (status.equals("ABSENT"))
            hoursLogged = 0.0;

        Attendance a = new Attendance();
        a.setAttendanceId(attendanceId);
        a.setStatus(status);
        a.setHoursLogged(hoursLogged);

        return attendanceDAO.updateAttendance(a) ? null : "Failed to update. Please try again.";
    }

    public List<Object[]> getAttendanceByOpportunity(int opportunityId) {
        return attendanceDAO.getAttendanceByOpportunity(opportunityId);
    }

    public List<Object[]> getAttendanceByVolunteer(int volunteerId) {
        return attendanceDAO.getAttendanceByVolunteer(volunteerId);
    }

    public double getTotalHours(int volunteerId) {
        return attendanceDAO.getTotalHoursByVolunteer(volunteerId);
    }
}