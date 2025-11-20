package com.vuadocau.dao;

import com.vuadocau.model.Brand;
import com.vuadocau.util.Db;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BrandDAO {

    public List<Brand> findAll() {
        String sql = "SELECT MaTH, TenTH FROM thuonghieu ORDER BY TenTH ASC";
        List<Brand> list = new ArrayList<>();

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Brand b = new Brand();
                b.setId(rs.getInt("MaTH"));
                b.setName(rs.getString("TenTH"));
                list.add(b);
            }

        } catch (Exception e) {
            throw new RuntimeException("BrandDAO.findAll failed", e);
        }
        return list;
    }

    public Brand findById(int id) {
        String sql = "SELECT MaTH, TenTH FROM thuonghieu WHERE MaTH = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Brand b = new Brand();
                    b.setId(rs.getInt("MaTH"));
                    b.setName(rs.getString("TenTH"));
                    return b;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("BrandDAO.findById failed: " + id, e);
        }
        return null;
    }
}
