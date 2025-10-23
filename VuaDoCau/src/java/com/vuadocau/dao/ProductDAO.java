package com.vuadocau.dao;

import com.vuadocau.model.Product;
import com.vuadocau.util.Db;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> findAll() {
        String sql = "SELECT id,name,price,image,rating,purchased,tag FROM products ORDER BY id DESC";
        List<Product> list = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setPrice(rs.getBigDecimal("price"));
                p.setImage(rs.getString("image"));
                p.setRating(rs.getDouble("rating"));
                p.setPurchased(rs.getInt("purchased"));
                p.setTag(rs.getString("tag"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}