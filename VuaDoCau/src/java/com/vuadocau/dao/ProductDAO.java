package com.vuadocau.dao;

import com.vuadocau.model.Product;
import com.vuadocau.util.Db;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    private static final String BASE_SELECT =
        "SELECT sp.MaSP, sp.TenSP, sp.MaDM, dm.TenDM, sp.MaTH, th.TenTH, " +
        "       sp.Gia, sp.Anh, sp.MoTa, sp.TonKho, sp.Rating, sp.Purchased " +
        "FROM sanpham sp " +
        "LEFT JOIN danhmuc dm ON dm.MaDM = sp.MaDM " +
        "LEFT JOIN thuonghieu th ON th.MaTH = sp.MaTH ";

    /* ========================= Public APIs ========================= */

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

    /** ===> Thêm mới: lấy 1 sản phẩm theo ID (dùng cho CartController) */
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
        return p;
    }
    public boolean insert(Product p) {
    String sql = "INSERT INTO sanpham(TenSP, MaDM, MaTH, Gia, Anh, MoTa, TonKho, Rating, Purchased, TrangThai, NgayTao) " +
                 "VALUES (?,?,?,?,?,?,?,?,1,1,NOW())";
    try (Connection con = Db.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, p.getName());
        ps.setInt(2, p.getCategoryId());
        if (p.getBrandId() == null) ps.setNull(3, Types.INTEGER);
        else ps.setInt(3, p.getBrandId());
        ps.setBigDecimal(4, p.getPrice());
        ps.setString(5, p.getImage());
        ps.setString(6, p.getDescription());
        ps.setInt(7, p.getStock());
        ps.setDouble(8, p.getRating());
        ps.setInt(9, p.getPurchased());
        return ps.executeUpdate() > 0;
    } catch (Exception e) { throw new RuntimeException("Insert product failed", e); }
}

public boolean update(Product p) {
    String sql = "UPDATE sanpham SET TenSP=?, MaDM=?, MaTH=?, Gia=?, Anh=?, MoTa=?, TonKho=?, Rating=?, Purchased=? WHERE MaSP=?";
    try (Connection con = Db.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, p.getName());
        ps.setInt(2, p.getCategoryId());
        if (p.getBrandId() == null) ps.setNull(3, Types.INTEGER);
        else ps.setInt(3, p.getBrandId());
        ps.setBigDecimal(4, p.getPrice());
        ps.setString(5, p.getImage());
        ps.setString(6, p.getDescription());
        ps.setInt(7, p.getStock());
        ps.setDouble(8, p.getRating());
        ps.setInt(9, p.getPurchased());
        ps.setInt(10, p.getId());
        return ps.executeUpdate() > 0;
    } catch (Exception e) { throw new RuntimeException("Update product failed", e); }
}

public boolean delete(int id) {
    String sql = "DELETE FROM sanpham WHERE MaSP=?";
    try (Connection con = Db.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, id);
        return ps.executeUpdate() > 0;
    } catch (Exception e) { throw new RuntimeException("Delete product failed", e); }
}
}