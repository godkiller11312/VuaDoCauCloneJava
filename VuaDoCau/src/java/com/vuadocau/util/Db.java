package com.vuadocau.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Db {
    private static final String URL =
        "jdbc:mysql://localhost:3306/vuadocau?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root"; // đổi theo XAMPP của bạn
    private static final String PASS = "";     // đổi theo XAMPP của bạn

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}