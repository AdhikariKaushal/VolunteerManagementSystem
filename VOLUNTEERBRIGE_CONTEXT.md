# VolunteerBridge — Full Project Context
## For AI Assistants (Cursor / Windsurf / Copilot / Claude)

> **READ THIS FIRST before making ANY change to this project.**
> This document contains the complete architecture, rules, and code context.
> Do NOT change any existing structure, naming, or approach without explicit instruction.

---

## 1. Project Identity

| Field | Value |
|---|---|
| Project Name | VolunteerBridge |
| Type | Web-based Volunteer Management System |
| Group | The GOAT |
| Group Leader | Kaushal Adhikari (ID: 24045899) |
| GitHub | https://github.com/AdhikariKaushal/VolunteerManagementSystem |

---

## 2. Mandatory Tech Stack — DO NOT CHANGE

| Technology | Usage | Version |
|---|---|---|
| Java | Backend logic | JDK 21 |
| Java EE (J2EE) | Servlets, Filters | Jakarta EE 5.0 |
| JSP | Frontend views | Jakarta JSP 3.0 |
| CSS | Styling — NO Bootstrap, NO Tailwind | Pure CSS + Flexbox + Media Queries |
| MySQL | Database | 8.0+ |
| Apache Tomcat | Application server | 11.0.18 on port 8081 |
| BCrypt (jbcrypt 0.4) | Password hashing | 0.4 |
| Maven | Build tool | pom.xml |
| IntelliJ IDEA | IDE | 2025.3.2 |

**CRITICAL RULES:**
- NO Bootstrap, NO Tailwind, NO React, NO Angular, NO Vue
- NO `@WebServlet` annotations — ALL servlet mappings are in `web.xml` ONLY
- NO Spring, NO Hibernate, NO JPA
- CSS must use Flexbox and media queries for responsiveness
- JavaScript only for minor UI enhancements — NO jQuery

---

## 3. MVC Architecture — STRICT LAYERS

```
JSP (View) → Servlet (Controller) → Service (Business Logic) → DAO (SQL) → MySQL
```

**Package structure — NEVER change package names:**
```
com.volunteermanagementsystem.model       — Plain Java classes (data)
com.volunteermanagementsystem.controller  — Servlets (HTTP request handlers)
com.volunteermanagementsystem.service     — Business logic
com.volunteermanagementsystem.dao         — SQL queries only
com.volunteermanagementsystem.util        — Helper classes
com.volunteermanagementsystem.filter      — AuthFilter only
```

---

## 4. Complete Folder Structure

```
VolunteerManagementSystem/
├── src/main/java/com/volunteermanagementsystem/
│   ├── controller/
│   │   ├── AdminServlet.java          [Kaushal] — admin actions
│   │   ├── LoginServlet.java          [Kaushal] — login for admin/volunteer
│   │   ├── LogoutServlet.java         [Kaushal] — session destroy
│   │   ├── OrgLoginServlet.java       [Sneha]   — org login
│   │   ├── OrgRegisterServlet.java    [Sneha]   — org registration
│   │   ├── OrgDashboardServlet.java   [Sneha]   — org dashboard
│   │   ├── OrgProfileServlet.java     [Sneha]   — org profile
│   │   ├── OpportunityServlet.java    [Sneha]   — opportunity CRUD
│   │   ├── OrganizationServlet.java   [Sneha]   — org management
│   │   ├── ApplicationServlet.java    [Anjal]   — applications
│   │   ├── AttendanceServlet.java     [Oshan]   — attendance
│   │   └── VolunteerServlet.java      [Darpan]  — volunteer actions
│   │
│   ├── dao/
│   │   ├── AdminDAO.java              [Kaushal] — admin SQL
│   │   ├── UserDAO.java               [Kaushal] — user SQL
│   │   ├── OrganizationDAO.java       [Sneha]   — org SQL
│   │   ├── OpportunityDAO.java        [Sneha]   — opportunity SQL
│   │   ├── VolunteerDAO.java          [Darpan]  — volunteer SQL
│   │   ├── ApplicationDAO.java        [Anjal]   — application SQL
│   │   └── AttendanceDAO.java         [Oshan]   — attendance SQL
│   │
│   ├── model/
│   │   ├── User.java                  — users table
│   │   ├── Admin.java                 — admins table
│   │   ├── Volunteer.java             — volunteers table
│   │   ├── Organization.java          — organizations table
│   │   ├── Opportunity.java           — opportunities table
│   │   ├── Application.java           — applications table
│   │   ├── Attendance.java            — attendance table
│   │   └── Wishlist.java              — wishlist table
│   │
│   ├── service/
│   │   ├── AuthService.java           [Kaushal] — login authentication
│   │   ├── AdminService.java          [Kaushal] — admin business logic
│   │   ├── OrganizationService.java   [Sneha]   — org business logic
│   │   ├── OpportunityService.java    [Sneha]   — opportunity logic
│   │   ├── VolunteerService.java      [Darpan]  — volunteer logic
│   │   ├── ApplicationService.java    [Anjal]   — application logic
│   │   └── AttendaceService.java      [Oshan]   — attendance logic
│   │
│   ├── util/
│   │   ├── DBConnection.java          — MySQL connection (password: 12345)
│   │   ├── PasswordUtil.java          — BCrypt hash/verify
│   │   ├── SessionUtil.java           — MERGED: Kaushal + Sneha methods
│   │   └── ValidationUtil.java        — input validation helpers
│   │
│   └── filter/
│       └── AuthFilter.java            — role-based access control
│
├── src/main/webapp/
│   ├── login.jsp                      — SELF-CONTAINED CSS (embedded, no external)
│   ├── index.jsp                      — landing page
│   ├── error.jsp                      — 500 error page
│   ├── error404.jsp                   — 404 error page
│   ├── navbar.jsp                     — shared navbar
│   │
│   ├── css/
│   │   ├── style.css                  — global shared styles
│   │   ├── login.css                  — login page styles
│   │   ├── admin.css                  — admin panel styles
│   │   ├── volunteer.css              — volunteer pages
│   │   ├── organization.css           — org pages
│   │   └── extra.css                  — about/contact pages
│   │
│   ├── views/
│   │   ├── admin/
│   │   │   ├── dashboard.jsp          — SELF-CONTAINED CSS
│   │   │   ├── manageUsers.jsp        — approve/reject users
│   │   │   ├── manageOpportunities.jsp
│   │   │   └── reports.jsp
│   │   │
│   │   ├── volunteer/
│   │   │   ├── register.jsp
│   │   │   ├── dashboard.jsp
│   │   │   ├── profile.jsp
│   │   │   ├── browseOpportunities.jsp
│   │   │   ├── applicationHistory.jsp
│   │   │   └── wishlist.jsp
│   │   │
│   │   ├── organization/
│   │   │   ├── register.jsp
│   │   │   ├── login.jsp
│   │   │   ├── dashboard.jsp
│   │   │   ├── profile.jsp
│   │   │   ├── postOpportunity.jsp
│   │   │   ├── manageOpportunities.jsp
│   │   │   ├── viewApplicants.jsp
│   │   │   ├── applicants.jsp
│   │   │   └── attendance.jsp
│   │   │
│   │   └── extra/
│   │       ├── about.jsp
│   │       └── contact.jsp
│   │
│   └── WEB-INF/
│       └── web.xml                    — ALL servlet mappings here, NO @WebServlet
│
├── database/
│   └── volunteerManagementSystem.sql  — full schema + admin insert
└── pom.xml
```

---

## 5. Database Schema — 9 Tables

**Database name:** `volunteermanagementsystem`
**MySQL password:** `12345` (Kaushal's PC — each member uses their own)

```sql
users          (user_id, email, password, role, status, created_at)
admins         (admin_id, user_id FK, full_name, phone)
volunteers     (volunteer_id, user_id FK, full_name, phone, date_of_birth, address, skills, total_hours)
organizations  (org_id, user_id FK, org_name, org_type, phone, address, description)
opportunities  (opportunity_id, org_id FK, title, description, location, event_date, slots, category, status, created_at)
applications   (application_id, opportunity_id FK, volunteer_id FK, status, applied_at)
attendance     (attendance_id, application_id FK, volunteer_id FK, opportunity_id FK, status, hours_logged, logged_at)
wishlist       (wishlist_id, volunteer_id FK, opportunity_id FK, saved_at)
contact_messages (message_id, full_name, email, message, sent_at)
```

**Registration flow for Organization:**
1. INSERT into `users` (email, password, role='organization', status='pending')
2. INSERT into `organizations` (user_id, org_name, org_type, phone, address, description)
3. Admin approves → UPDATE `users` SET status='active'

**Registration flow for Volunteer:**
1. INSERT into `users` (email, password, role='volunteer', status='pending')
2. INSERT into `volunteers` (user_id, full_name, phone, ...)
3. Admin approves → UPDATE `users` SET status='active'

---

## 6. Important Credentials

| Item | Value |
|---|---|
| Admin Email | admin@volunteerbrige.com |
| Admin Password | admin123 |
| BCrypt Hash | $2a$12$7FAokRGm7/LeiWM7DZWvO.RUSngXhxewEg0L7cuDuIdbzNg4IUxvq |
| DB Name | volunteermanagementsystem |
| DB Username | root |
| DB Password | 12345 (update per machine) |
| Tomcat Port | 8081 |
| App URL | http://localhost:8081/VolunteerManagementSystem_war_exploded/ |
| Login URL | http://localhost:8081/VolunteerManagementSystem_war_exploded/login.jsp |

---

## 7. Critical Rules — NEVER VIOLATE

### Rule 1: No @WebServlet annotations
ALL servlet URL mappings must be in `web.xml` ONLY.
If both `@WebServlet` and `web.xml` mapping exist for the same servlet → duplicate mapping error → Tomcat crashes.

### Rule 2: All JSP paths include /views/
```java
// CORRECT
response.sendRedirect(contextPath + "/views/admin/dashboard.jsp");
response.sendRedirect(contextPath + "/views/volunteer/dashboard.jsp");
response.sendRedirect(contextPath + "/views/organization/dashboard.jsp");

// WRONG
response.sendRedirect(contextPath + "/admin/dashboard.jsp");
```

### Rule 3: Admin pages go through AdminServlet
```java
// CORRECT — loads stat counts first
response.sendRedirect(contextPath + "/AdminServlet?action=dashboard");

// WRONG — bypasses data loading, renders blank page
response.sendRedirect(contextPath + "/views/admin/dashboard.jsp");
```

### Rule 4: SessionUtil is MERGED — never replace
`SessionUtil.java` has methods from BOTH Kaushal AND Sneha.
- Kaushal's: `createSession`, `destroySession`, `isLoggedIn`, `hasRole`, `getUserRole`, `getUserId`, `getUserEmail`
- Sneha's: `setOrganization`, `getOrganization`, `getOrgId`, `isOrgLoggedIn`, `invalidate`

### Rule 5: Password hashing is BCrypt only
```java
// Hash: PasswordUtil.hashPassword("plainPassword")
// Verify: PasswordUtil.verifyPassword("plain", "hashed")
// Library: org.mindrot.jbcrypt version 0.4
```

### Rule 6: login.jsp and dashboard.jsp have embedded CSS
These files have ALL their CSS written directly inside `<style>` tags.
Do NOT add external CSS `<link>` tags to these files — it breaks the UI.

### Rule 7: DBConnection password must match local MySQL
```java
private static final String URL = "jdbc:mysql://localhost:3306/volunteermanagementsystem?useSSL=false&serverTimezone=UTC";
private static final String USERNAME = "root";
private static final String PASSWORD = "12345"; // change per machine
```

### Rule 8: OrganizationDAO uses `organizations` table (with s)
All SQL queries must say `organizations` NOT `organization`.

---

## 8. Servlet URL Mappings (web.xml)

| Servlet Class | URL Pattern |
|---|---|
| LoginServlet | /LoginServlet |
| LogoutServlet | /LogoutServlet |
| AdminServlet | /AdminServlet |
| OrgRegisterServlet | /org/register |
| OrgLoginServlet | /org/login |
| OrgDashboardServlet | /org/dashboard |
| OrgProfileServlet | /org/profile |
| OpportunityServlet | /opportunity |
| OrganizationServlet | /OrganizationServlet |
| VolunteerServlet | /VolunteerServlet |
| ApplicationServlet | /ApplicationServlet |
| AttendanceServlet | /AttendanceServlet |

---

## 9. Color Theme (CSS Variables)

```css
Primary Green:     #1a6b3c   /* buttons, sidebar, headers */
Dark Green:        #0f4a28   /* gradients, hover */
Dark Navy:         #1a1a2e   /* sidebar background */
Light Green BG:    #e8f5ee   /* success alerts, badges */
Light Blue BG:     #eaf1fb   /* info badges */
Light Amber BG:    #faeeda   /* pending badges */
Light Red BG:      #fdecea   /* error alerts */
Page Background:   #f4f6f9   /* main content area */
Card Background:   #ffffff   /* cards, panels */
Text Primary:      #1a1a1a
Text Muted:        #777777
Border:            #dddddd
```

---

## 10. pom.xml Dependencies

```xml
jakarta.servlet-api        5.0.0   (provided)
jakarta.servlet.jsp-api    3.0.0   (provided)
jakarta.servlet.jsp.jstl   2.0.0
org.glassfish.web.jstl     2.0.0
mysql-connector-java       8.0.33
org.mindrot.jbcrypt        0.4
maven-war-plugin           3.3.2
maven-compiler-plugin      3.11.0  (Java 11 source/target)
```

---

## 11. GitHub Branch Status

| Branch | Status |
|---|---|
| main | ✅ Active — Kaushal + Sneha + Darpan merged |
| sneha-organization | Merged |
| Darpan-Ghimire | Merged |
| oshan | ⚠️ NOT YET MERGED |

---

## 12. Known Issues & Fixes

| Issue | Fix |
|---|---|
| Admin login fails after DB reset | Run: UPDATE users SET password='$2a$12$7FAokRGm7/LeiWM7DZWvO.RUSngXhxewEg0L7cuDuIdbzNg4IUxvq' WHERE email='admin@volunteerbrige.com' |
| Blank page after login | Always redirect to /AdminServlet?action=dashboard not directly to dashboard.jsp |
| Duplicate servlet mapping error | Remove @WebServlet annotation from servlet class |
| CSS not loading on JSP pages | Use embedded `<style>` tags for critical pages |
| OrganizationDAO table not found | Make sure all SQL says `organizations` not `organization` |
| DBConnection fails silently | Check PASSWORD in DBConnection.java matches your MySQL password |
| Merge conflicts on SessionUtil | Always use the MERGED version with both Kaushal's and Sneha's methods |
| .class files in GitHub | target/ folder is in .gitignore — never commit compiled files |

---

## 13. Task Ownership

| Member | Owns |
|---|---|
| Kaushal Adhikari | Foundation, Auth, Admin module, DBConnection, SessionUtil, AuthFilter |
| Sneha | Organization module (register, login, dashboard, profile, opportunities, applicants) |
| Darpan Ghimire | Volunteer module (register, browse, apply, wishlist, history) |
| Oshan Rai | Attendance tracking, About page, Contact page, Testing |
| Anjal Babu Adhikari | Application model, ApplicationDAO, testing help |

---

## 14. How to Run the Project

1. Clone: `git clone https://github.com/AdhikariKaushal/VolunteerManagementSystem`
2. Import SQL: Open MySQL Workbench → run `database/volunteerManagementSystem.sql`
3. Update `DBConnection.java` with your MySQL password
4. Open in IntelliJ → File → Open → select project folder
5. Configure Tomcat 11 → port 8081 → war exploded artifact → context path `/`
6. Click Run ▶️
7. Go to: `http://localhost:8081/VolunteerManagementSystem_war_exploded/login.jsp`
8. Login: `admin@volunteerbrige.com` / `admin123`

