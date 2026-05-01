package com.volunteermanagementsystem.util;

/**
 * ValidationUtil - Reusable input validation methods
 * Author: Kaushal Adhikari
 * Group: The GOAT
 */
public class ValidationUtil {

    // Private constructor — utility class
    private ValidationUtil() {}

    /**
     * Checks if a string is null or empty
     */
    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    /**
     * Validates email format
     */
    public static boolean isValidEmail(String email) {
        if (isEmpty(email)) return false;
        return email.matches("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$");
    }

    /**
     * Validates phone number — must be 10 digits
     */
    public static boolean isValidPhone(String phone) {
        if (isEmpty(phone)) return false;
        return phone.matches("^[0-9]{10}$");
    }

    /**
     * Validates password — minimum 6 characters
     */
    public static boolean isValidPassword(String password) {
        if (isEmpty(password)) return false;
        return password.length() >= 6;
    }

    /**
     * Validates full name — letters and spaces only, no numbers
     */
    public static boolean isValidName(String name) {
        if (isEmpty(name)) return false;
        return name.matches("^[a-zA-Z ]{2,100}$");
    }

    /**
     * Validates that a number is positive
     */
    public static boolean isPositiveNumber(int number) {
        return number > 0;
    }
}
