package com.vuadocau.dao;

import com.vuadocau.model.Product;
import com.vuadocau.util.Db;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

private static final String BASE_SELECT =
    "SELECT sp.MaSP, sp.TenSP, sp.MaDM, dm.TenDM, sp.MaTH, th.TenTH, " +
    "       sp.Gia, sp.GiaCu, sp.Anh, sp.MoTa, sp.TonKho, sp.Rating, sp.Purchased " +
    "FROM sanpham sp " +
    "LEFT JOIN danhmuc dm ON dm.MaDM = sp.MaDM " +
    "LEFT JOIN thuonghieu th ON th.MaTH = sp.MaTH ";

    public List<Product> findAll() {
        String sql = BASE_SELECT + " ORDER BY sp.MaSP DESC";
        return query(sql, ps -> {});
    }

    public List<Product> findByCategory(int categoryId) {
        String sql = BASE_SELECT + " WHERE sp.MaDM=? ORDER BY sp.MaSP DESC";
        return query(sql, ps -> ps.setInt(1, categoryId));
    }

    public List<Product> search(String keyword) {
        String sql = BASE_SELECT + " WHERE sp.TenSP LIKE ? ORDER BY sp.MaSP DESC";
        return query(sql, ps -> ps.setString(1, "%" + keyword + "%"));
    }

    public List<Product> findTopByCategory(int categoryId, int limit) {
        String sql = BASE_SELECT + " WHERE sp.MaDM=? ORDER BY sp.MaSP DESC LIMIT ?";
        return query(sql, ps -> { ps.setInt(1, categoryId); ps.setInt(2, limit); });
    }

    public List<Product> findByCategoryIds(int... ids) {
        if (ids == null || ids.length == 0) return findAll();
        StringBuilder sb = new StringBuilder(BASE_SELECT).append(" WHERE sp.MaDM IN (");
        for (int i = 0; i < ids.length; i++) {
            sb.append("?").append(i < ids.length - 1 ? "," : ")");
        }
        sb.append(" ORDER BY sp.MaSP DESC");
        return query(sb.toString(), ps -> {
            for (int i = 0; i < ids.length; i++) ps.setInt(i + 1, ids[i]);
        });
    }

    public Product findById(int id) {
        String sql = BASE_SELECT + " WHERE sp.MaSP = ?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (Exception e) {
            throw new RuntimeException("findById failed: " + id, e);
        }
    }

    /* ========================= CUD ========================= */

    public boolean insert(Product p) {
        final String sql =
            "INSERT INTO sanpham " +
            "(TenSP, MaDM, MaTH, Gia, Anh, MoTa, TonKho, Rating, Purchased, TrangThai, NgayTao) " +
            "VALUES (?,?,?,?,?,?,?,?,?,1,NOW())";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int i = 1;
            ps.setString(i++, p.getName());
            ps.setInt(i++, p.getCategoryId());
            if (p.getBrandId() == null) ps.setNull(i++, Types.INTEGER);
            else                         ps.setInt(i++, p.getBrandId());
            ps.setBigDecimal(i++, p.getPrice());
            ps.setString(i++, p.getImage());
            ps.setString(i++, p.getDescription());
            ps.setInt(i++, p.getStock());
            ps.setDouble(i++, p.getRating());
            ps.setInt(i++, p.getPurchased());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            throw new RuntimeException("Insert product failed: " + e.getMessage(), e);
        }
    }

    public boolean update(Product p) {
        final String sql =
            "UPDATE sanpham " +
            "SET TenSP=?, MaDM=?, MaTH=?, Gia=?, Anh=?, MoTa=?, TonKho=?, Rating=?, Purchased=? " +
            "WHERE MaSP=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int i = 1;
            ps.setString(i++, p.getName());
            ps.setInt(i++, p.getCategoryId());
            if (p.getBrandId() == null) ps.setNull(i++, Types.INTEGER);
            else                         ps.setInt(i++, p.getBrandId());
            ps.setBigDecimal(i++, p.getPrice());
            ps.setString(i++, p.getImage());
            ps.setString(i++, p.getDescription());
            ps.setInt(i++, p.getStock());
            ps.setDouble(i++, p.getRating());
            ps.setInt(i++, p.getPurchased());
            ps.setInt(i,   p.getId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            throw new RuntimeException("Update product failed: " + e.getMessage(), e);
        }
    }

    public boolean delete(int id) {
        final String sql = "DELETE FROM sanpham WHERE MaSP=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            throw new RuntimeException("Delete product failed: " + e.getMessage(), e);
        }
    }

    /* ========================= Helpers ========================= */

    private interface Binder { void bind(PreparedStatement ps) throws Exception; }

    private List<Product> query(String sql, Binder binder) {
        List<Product> list = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            binder.bind(ps);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("Query failed: " + sql, e);
        }
        return list;
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setId(rs.getInt("MaSP"));
        p.setName(rs.getString("TenSP"));
        p.setCategoryId(rs.getInt("MaDM"));
        p.setCategoryName(rs.getString("TenDM"));

        int th = rs.getInt("MaTH");
        p.setBrandId(rs.wasNull() ? null : th);
        p.setBrandName(rs.getString("TenTH"));

        p.setPrice(rs.getBigDecimal("Gia"));
        p.setImage(rs.getString("Anh"));
        p.setDescription(rs.getString("MoTa"));
        p.setStock(rs.getInt("TonKho"));
        p.setRating(rs.getDouble("Rating"));
        p.setPurchased(rs.getInt("Purchased"));
        p.setPrice(rs.getBigDecimal("Gia"));
        p.setOldPrice(rs.getBigDecimal("GiaCu"));  // ✅ thêm dòng này
        return p;
    }

    /* ========================= NEW: tìm cho admin có filter + sort ========================= */

    public List<Product> adminSearch(String keyword, Integer categoryId, String sort, String dir) {
        // map tên sort -> cột SQL an toàn
        String orderCol;
        switch (sort) {
            case "name":      orderCol = "sp.TenSP"; break;
            case "price":     orderCol = "sp.Gia"; break;
            case "stock":     orderCol = "sp.TonKho"; break;
            case "rating":    orderCol = "sp.Rating"; break;
            case "purchased": orderCol = "sp.Purchased"; break;
            case "id":
            default:          orderCol = "sp.MaSP";
        }
        String orderDir = "asc".equalsIgnoreCase(dir) ? "ASC" : "DESC";

        StringBuilder sql = new StringBuilder(BASE_SELECT).append(" WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND sp.TenSP LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }
        if (categoryId != null) {
            sql.append(" AND sp.MaDM = ? ");
            params.add(categoryId);
        }
        sql.append(" ORDER BY ").append(orderCol).append(' ').append(orderDir);

        return queryDyn(sql.toString(), params);
    }

    private List<Product> queryDyn(String sql, List<Object> params) {
        List<Product> list = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) {
            throw new RuntimeException("QueryDyn failed: " + e.getMessage(), e);
        }
        return list;
    }
}