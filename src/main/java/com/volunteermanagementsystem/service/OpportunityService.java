package com.volunteermanagementsystem.service;


import com.volunteermanagementsystem.dao.OpportunityDAO;
import com.volunteermanagementsystem.model.Opportunity;
import com.volunteermanagementsystem.util.ValidationUtil;

import java.sql.Date;
import java.util.List;

public class OpportunityService {

    private final OpportunityDAO oppDAO = new OpportunityDAO();

    /**
     * Validates and creates a new opportunity.
     * @return null on success, or an error message on failure.
     */
    public String create(int orgId, String title, String description,
                         String location, String category,
                         String slotsStr, String deadlineStr) {

        if (ValidationUtil.isEmpty(title))       return "Title is required.";
        if (ValidationUtil.isEmpty(description)) return "Description is required.";
        if (ValidationUtil.isEmpty(slotsStr))    return "Number of slots is required.";
        if (!ValidationUtil.isPositiveInt(slotsStr)) return "Slots must be a positive number.";
        if (ValidationUtil.isEmpty(deadlineStr)) return "Deadline is required.";

        Opportunity opp = new Opportunity();
        opp.setOrgId(orgId);
        opp.setTitle(title.trim());
        opp.setDescription(description.trim());
        opp.setLocation(location);
        opp.setCategory(category);
        opp.setSlots(Integer.parseInt(slotsStr));
        opp.setDeadline(Date.valueOf(deadlineStr));
        opp.setStatus("open");

        return oppDAO.create(opp) ? null : "Failed to create opportunity. Please try again.";
    }

    /**
     * Validates and updates an existing opportunity.
     * @return null on success, or an error message on failure.
     */
    public String update(int oppId, int orgId, String title, String description,
                         String location, String category,
                         String slotsStr, String deadlineStr, String status) {

        if (ValidationUtil.isEmpty(title))           return "Title is required.";
        if (ValidationUtil.isEmpty(description))     return "Description is required.";
        if (ValidationUtil.isEmpty(slotsStr))        return "Number of slots is required.";
        if (!ValidationUtil.isPositiveInt(slotsStr)) return "Slots must be a positive number.";
        if (ValidationUtil.isEmpty(deadlineStr))     return "Deadline is required.";

        Opportunity opp = new Opportunity();
        opp.setOppId(oppId);
        opp.setOrgId(orgId);
        opp.setTitle(title.trim());
        opp.setDescription(description.trim());
        opp.setLocation(location);
        opp.setCategory(category);
        opp.setSlots(Integer.parseInt(slotsStr));
        opp.setDeadline(Date.valueOf(deadlineStr));
        opp.setStatus(status != null ? status : "open");

        return oppDAO.update(opp) ? null : "Failed to update opportunity. Please try again.";
    }

    /** Delete an opportunity — only if it belongs to this org. */
    public boolean delete(int oppId, int orgId) {
        return oppDAO.delete(oppId, orgId);
    }

    /** All opportunities posted by this org. */
    public List<Opportunity> getByOrg(int orgId) {
        return oppDAO.findByOrg(orgId);
    }

    /** Single opportunity by ID. */
    public Opportunity getById(int oppId) {
        return oppDAO.findById(oppId);
    }
}