package com.vuadocau.util;

import java.security.MessageDigest;

public class PasswordUtil {
    public static String sha256(String plain) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] h = md.digest(plain.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : h) sb.append(String.format("%02X", b)); // UPPER HEX
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}