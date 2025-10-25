package com.vuadocau.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class Db {
    static {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); } 
        catch (ClassNotFoundException e) { throw new RuntimeException(e); }
    }

    private static final String URL =
        "jdbc:mysql://localhost:3306/vuadocau?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASS = ""; // điền mật khẩu nếu có

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
