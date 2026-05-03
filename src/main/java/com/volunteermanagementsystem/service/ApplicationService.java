package com.volunteermanagementsystem.service;

import com.volunteermanagementsystem.dao.ApplicationDAO;
import com.volunteermanagementsystem.dao.OpportunityDAO;
import com.volunteermanagementsystem.model.Application;
import com.volunteermanagementsystem.model.Opportunity;

import java.util.List;

public class ApplicationService {

    private final ApplicationDAO appDAO = new ApplicationDAO();
    private final OpportunityDAO oppDAO = new OpportunityDAO();

    public List<Application> getByOpportunity(int oppId) {
        return appDAO.findByOpportunity(oppId);
    }

    public String approve(int appId, int oppId) {
        Opportunity opp = oppDAO.findById(oppId);
        if (opp == null) return "Opportunity not found.";
        int approved = appDAO.countApproved(oppId);
        if (approved >= opp.getSlots())
            return "No slots remaining. Cannot approve more applicants.";
        return appDAO.updateStatus(appId, "approved") ? null : "Failed to approve application.";
    }

    public String reject(int appId) {
        return appDAO.updateStatus(appId, "rejected") ? null : "Failed to reject application.";
    }
}