package com.vuadocau.dao;

import com.vuadocau.model.Category;
import com.vuadocau.util.Db;

import java.sql.*;
import java.util.*;

public class CategoryDAO {
    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT MaDM, TenDM FROM danhmuc ORDER BY MaDM";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Category(rs.getInt(1), rs.getString(2)));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}