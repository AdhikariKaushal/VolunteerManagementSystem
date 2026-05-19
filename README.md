# Volunteer Management System

A web-based platform that connects volunteers with organizations offering volunteering opportunities. Built with Java Servlets, JSP, and MySQL.

---

## Features

### Volunteer
- Register and log in securely
- Browse and apply for volunteering opportunities
- Track application status (pending / approved / rejected)
- View and update profile (skills, bio, contact info)
- Save opportunities to a wishlist
- Track total volunteering hours

### Organization
- Register and manage an organization profile
- Post, edit, and close volunteering opportunities
- Review applicants and approve or reject them
- Track attendance of volunteers

### Admin
- Login and Session
- Manage all users (volunteers and organizations)
- Activate or deactivate accounts
- Manage and oversee all opportunities
- View summary reports
- View all applications
- Dashboard with cards
- Delete user accounts

---

## Tech Stack

| Layer      | Technology                      |
|------------|---------------------------------|
| Language   | Java 11                         |
| Frontend   | JSP, JSTL, HTML, CSS            |
| Backend    | Jakarta Servlets (Jakarta EE 5) |
| Database   | MySQL                           |
| Security   | BCrypt password hashing         |
| Server     | port 8082 / Tomcat              |

---

---

## Database Setup

1. Open MySQL and create the database:
```sql
   CREATE DATABASE volunteermanagementsystem;
```

2. Import the schema:
```bash
   mysql -u root -p volunteermanagementsystem < schema.sql
```

3. Update the database credentials in `DBConnection.java`:
```java
   private static final String URL = "jdbc:mysql://localhost:3306/volunteermanagementsystem";
   private static final String USER = "your_username";
   private static final String PASSWORD = "your_password";
```

## Default Roles

| Role         | Access                                      |
|--------------|---------------------------------------------|
| Admin        | Full system access                          |
| Organization | Post opportunities, manage applicants       |
| Volunteer    | Browse opportunities, apply, track hours    |

---

## Contributors

- Darpan Ghimire
- Kaushal Adhikari
- Sneha Tiwari
- Oshan