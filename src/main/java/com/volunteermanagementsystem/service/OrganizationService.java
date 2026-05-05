package com.volunteermanagementsystem.service;



import com.volunteermanagementsystem.dao.OrganizationDAO;
import com.volunteermanagementsystem.model.Organization;
import com.volunteermanagementsystem.util.PasswordUtil;
import com.volunteermanagementsystem.util.ValidationUtil;

public class OrganizationService {

    private final OrganizationDAO orgDAO = new OrganizationDAO();

    /**
     * Validates all fields and registers a new organization.
     * @return null on success, or an error message string on failure.
     */
    public String register(String orgName, String email, String password,
                           String confirmPassword, String orgType,
                           String description, String website,
                           String phone, String address) {

        if (ValidationUtil.isEmpty(orgName))           return "Organisation name is required.";
        if (!ValidationUtil.isAlphaOnly(orgName))      return "Organisation name must contain letters only.";
        if (ValidationUtil.isEmpty(email))             return "Email is required.";
        if (!ValidationUtil.isValidEmail(email))       return "Please enter a valid email address.";
        if (ValidationUtil.isEmpty(phone))             return "Phone number is required.";
        if (!ValidationUtil.isValidPhone(phone))       return "Phone must be exactly 10 digits.";
        if (ValidationUtil.isEmpty(password))          return "Password is required.";
        if (!ValidationUtil.isValidPassword(password)) return "Password must be at least 6 characters.";
        if (!password.equals(confirmPassword))         return "Passwords do not match.";
        if (ValidationUtil.isEmpty(orgType))           return "Organisation type is required.";

        if (orgDAO.emailExists(email)) return "An account with this email already exists.";
        if (orgDAO.phoneExists(phone)) return "An account with this phone number already exists.";

        Organization org = new Organization();
        org.setOrgName(orgName.trim());
        org.setEmail(email.trim());
        org.setPassword(PasswordUtil.hashPassword(password));
        org.setOrgType(orgType.trim());
        org.setDescription(description);
        org.setWebsite(website);
        org.setPhone(phone.trim());
        org.setAddress(address);

        return orgDAO.register(org) ? null : "Registration failed. Please try again.";
    }

    /**
     * Authenticates login. Returns Organization on success, null on failure.
     */
    public Organization login(String email, String password) {
        if (ValidationUtil.isEmpty(email) || ValidationUtil.isEmpty(password)) return null;

        Organization org = orgDAO.findByEmail(email.trim());
        if (org == null) return null;
        if (!PasswordUtil.verifyPassword(password, org.getPassword())) return null;
        // Admin approval sets status to "active" (see AdminService.approveOrganization)
        String st = org.getStatus();
        if (st == null || !("active".equalsIgnoreCase(st) || "approved".equalsIgnoreCase(st))) {
            return null;
        }

        return org;
    }

    /**
     * Returns a human-readable login error message.
     */
    public String getLoginError(String email, String password) {
        if (ValidationUtil.isEmpty(email) || ValidationUtil.isEmpty(password))
            return "Email and password are required.";

        Organization org = orgDAO.findByEmail(email.trim());
        if (org == null)                                        return "No account found with this email.";
        if (!PasswordUtil.verifyPassword(password, org.getPassword())) return "Incorrect password.";
        String st = org.getStatus();
        if (st != null && "pending".equalsIgnoreCase(st))      return "Your account is awaiting admin approval.";
        if (st != null && "deactivated".equalsIgnoreCase(st))  return "Your organisation account is inactive. Contact support.";
        return "Login failed. Please try again.";
    }

    /** Fetch org by ID. */
    public Organization getById(int orgId) {
        return orgDAO.findById(orgId);
    }

    /**
     * Validates and updates editable profile fields.
     * @return null on success, or an error message on failure.
     */
    public String updateProfile(int orgId, String orgName, String orgType,
                                String description, String website,
                                String phone, String address) {

        if (ValidationUtil.isEmpty(orgName))           return "Organisation name is required.";
        if (!ValidationUtil.isAlphaOnly(orgName))      return "Organisation name must contain letters only.";
        if (ValidationUtil.isEmpty(phone))             return "Phone number is required.";
        if (!ValidationUtil.isValidPhone(phone))       return "Phone must be exactly 10 digits.";

        // Allow org to keep its own phone — only block if another org has it
        Organization existing = orgDAO.findById(orgId);
        if (existing != null && !existing.getPhone().equals(phone) && orgDAO.phoneExists(phone))
            return "This phone number is already used by another account.";

        Organization org = new Organization();
        org.setOrgId(orgId);
        org.setOrgName(orgName.trim());
        org.setOrgType(orgType);
        org.setDescription(description);
        org.setWebsite(website);
        org.setPhone(phone.trim());
        org.setAddress(address);

        return orgDAO.updateProfile(org) ? null : "Profile update failed. Please try again.";
    }
}
