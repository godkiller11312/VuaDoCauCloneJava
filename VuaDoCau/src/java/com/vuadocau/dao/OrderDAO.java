package com.vuadocau.dao;

import com.vuadocau.model.*;
import com.vuadocau.util.Db;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /** Tạo đơn (đúng bảng: donhang/chitietdh) */
    public int create(Order o, Cart cart) {
        String sqlOrder = "INSERT INTO donhang (MaND, NgayDH, TrangThai, GhiChu) VALUES (?, NOW(), ?, ?)";
        String sqlItem  = "INSERT INTO chitietdh (MaDH, MaSP, SoLuong, Gia) VALUES (?,?,?,?)";
        try (Connection con = Db.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps = con.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, o.getUserId());
                ps.setString(2, o.getStatus()); // "NEW"
                ps.setString(3, o.getNote());   // gói SDT/Địa chỉ/Note
                ps.executeUpdate();

                int orderId;
                try (ResultSet rs = ps.getGeneratedKeys()) { rs.next(); orderId = rs.getInt(1); }

                try (PreparedStatement psi = con.prepareStatement(sqlItem)) {
                    for (CartItem it : cart.getItems()) {
                        psi.setInt(1, orderId);
                        psi.setInt(2, it.getProductId());
                        psi.setInt(3, it.getQuantity());
                        psi.setBigDecimal(4, it.getPrice());
                        psi.addBatch();
                    }
                    psi.executeBatch();
                }

                con.commit();
                return orderId;
            } catch (Exception ex) {
                con.rollback();
                throw ex;
            } finally { con.setAutoCommit(true); }
        } catch (Exception e) {
            throw new RuntimeException("Create order failed", e);
        }
    }

    /** Lịch sử đơn theo user, tổng tiền động từ chitietdh */
    public List<Order> findByUser(int userId) {
        String sql =
            "SELECT dh.MaDH, dh.NgayDH, dh.TrangThai, COALESCE(SUM(ct.SoLuong * ct.Gia), 0) AS Tong " +
            "FROM donhang dh " +
            "LEFT JOIN chitietdh ct ON ct.MaDH = dh.MaDH " +
            "WHERE dh.MaND=? " +
            "GROUP BY dh.MaDH, dh.NgayDH, dh.TrangThai " +
            "ORDER BY dh.MaDH DESC";
        List<Order> list = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("MaDH"));
                    Timestamp ts = rs.getTimestamp("NgayDH");
                    if (ts != null) o.setCreatedAt(new java.util.Date(ts.getTime()));
                    o.setStatus(rs.getString("TrangThai"));
                    o.setTotal(rs.getBigDecimal("Tong")); // dùng cho profile
                    list.add(o);
                }
            }
        } catch (Exception e) { throw new RuntimeException(e); }
        return list;
    }

    /** Chi tiết 1 đơn: join nguoidung & sanpham */
    public Order findById(int orderId, int userId) {
        String sql =
            "SELECT dh.MaDH, dh.MaND, dh.NgayDH, dh.TrangThai, dh.GhiChu, nd.TenND, nd.Email " +
            "FROM donhang dh JOIN nguoidung nd ON nd.MaND = dh.MaND " +
            "WHERE dh.MaDH=? AND dh.MaND=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                Order o = new Order();
                o.setId(rs.getInt("MaDH"));
                o.setUserId(rs.getInt("MaND"));
                Timestamp ts = rs.getTimestamp("NgayDH");
               if (ts != null) o.setCreatedAt(new java.util.Date(ts.getTime()));
                o.setStatus(rs.getString("TrangThai"));
                o.setNote(rs.getString("GhiChu"));
                o.setFullName(rs.getString("TenND"));
                o.setEmail(rs.getString("Email"));

                // items + subtotal
                String sqlItems =
                    "SELECT ct.MaSP, sp.TenSP, sp.Anh, ct.Gia, ct.SoLuong " +
                    "FROM chitietdh ct JOIN sanpham sp ON sp.MaSP = ct.MaSP " +
                    "WHERE ct.MaDH=?";
                try (PreparedStatement psi = con.prepareStatement(sqlItems)) {
                    psi.setInt(1, orderId);
                    try (ResultSet rsi = psi.executeQuery()) {
                        List<OrderItem> items = new ArrayList<>();
                        java.math.BigDecimal subtotal = java.math.BigDecimal.ZERO;
                        while (rsi.next()) {
                            OrderItem it = new OrderItem();
                            it.setOrderId(orderId);
                            it.setProductId(rsi.getInt("MaSP"));
                            it.setName(rsi.getString("TenSP"));
                            it.setImage(rsi.getString("Anh"));
                            it.setPrice(rsi.getBigDecimal("Gia"));
                            it.setQuantity(rsi.getInt("SoLuong"));
                            items.add(it);
                            subtotal = subtotal.add(it.getPrice()
                                    .multiply(java.math.BigDecimal.valueOf(it.getQuantity())));
                        }
                        o.setItems(items);
                        o.setSubtotal(subtotal);
                    }
                }
                return o;
            }
        } catch (Exception e) { throw new RuntimeException(e); }
    }
    public List<Order> findAll(String q, String status) {
    StringBuilder sb = new StringBuilder(
        "SELECT dh.MaDH, dh.NgayDH, dh.TrangThai, nd.TenND, nd.Email, " +
        "       COALESCE(SUM(ct.SoLuong*ct.Gia),0) AS Tong " +
        "FROM donhang dh " +
        "JOIN nguoidung nd ON nd.MaND = dh.MaND " +
        "LEFT JOIN chitietdh ct ON ct.MaDH = dh.MaDH ");
    List<Object> params = new ArrayList<>();
    boolean where = false;
    if (status != null && !status.isBlank()) {
        sb.append(where ? " AND" : " WHERE").append(" dh.TrangThai = ?");
        params.add(status);
        where = true;
    }
    if (q != null && !q.isBlank()) {
        sb.append(where ? " AND" : " WHERE")
          .append(" (CAST(dh.MaDH AS CHAR) LIKE ? OR nd.Email LIKE ? OR nd.TenND LIKE ?)");
        String like = "%" + q.trim() + "%";
        params.add(like); params.add(like); params.add(like);
        where = true;
    }
    sb.append(" GROUP BY dh.MaDH, dh.NgayDH, dh.TrangThai, nd.TenND, nd.Email ")
      .append(" ORDER BY dh.MaDH DESC");

    List<Order> list = new ArrayList<>();
    try (Connection con = Db.getConnection();
         PreparedStatement ps = con.prepareStatement(sb.toString())) {
        for (int i = 0; i < params.size(); i++) ps.setObject(i+1, params.get(i));
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("MaDH"));
                Timestamp ts = rs.getTimestamp("NgayDH");
                if (ts != null) o.setCreatedAt(new java.util.Date(ts.getTime()));
                o.setStatus(rs.getString("TrangThai"));
                o.setFullName(rs.getString("TenND"));
                o.setEmail(rs.getString("Email"));
                o.setTotal(rs.getBigDecimal("Tong"));
                list.add(o);
            }
        }
    } catch (Exception e) { throw new RuntimeException(e); }
    return list;
}

// Chi tiết một đơn cho admin (không ràng user)
public Order findAdminById(int orderId) {
    String sql = "SELECT dh.MaDH, dh.MaND, dh.NgayDH, dh.TrangThai, dh.GhiChu, nd.TenND, nd.Email " +
                 "FROM donhang dh JOIN nguoidung nd ON nd.MaND = dh.MaND " +
                 "WHERE dh.MaDH=?";
    try (Connection con = Db.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setInt(1, orderId);
        try (ResultSet rs = ps.executeQuery()) {
            if (!rs.next()) return null;
            Order o = new Order();
            o.setId(rs.getInt("MaDH"));
            o.setUserId(rs.getInt("MaND"));
            Timestamp ts = rs.getTimestamp("NgayDH");
            if (ts != null) o.setCreatedAt(new java.util.Date(ts.getTime()));
            o.setStatus(rs.getString("TrangThai"));
            o.setNote(rs.getString("GhiChu"));
            o.setFullName(rs.getString("TenND"));
            o.setEmail(rs.getString("Email"));

            String sqlItems = "SELECT ct.MaSP, sp.TenSP, sp.Anh, ct.Gia, ct.SoLuong " +
                              "FROM chitietdh ct JOIN sanpham sp ON sp.MaSP = ct.MaSP " +
                              "WHERE ct.MaDH=?";
            try (PreparedStatement psi = con.prepareStatement(sqlItems)) {
                psi.setInt(1, orderId);
                try (ResultSet rsi = psi.executeQuery()) {
                    List<OrderItem> items = new ArrayList<>();
                    java.math.BigDecimal subtotal = java.math.BigDecimal.ZERO;
                    while (rsi.next()) {
                        OrderItem it = new OrderItem();
                        it.setOrderId(orderId);
                        it.setProductId(rsi.getInt("MaSP"));
                        it.setName(rsi.getString("TenSP"));
                        it.setImage(rsi.getString("Anh"));
                        it.setPrice(rsi.getBigDecimal("Gia"));
                        it.setQuantity(rsi.getInt("SoLuong"));
                        items.add(it);
                        subtotal = subtotal.add(it.getPrice()
                                   .multiply(java.math.BigDecimal.valueOf(it.getQuantity())));
                    }
                    o.setItems(items);
                    o.setSubtotal(subtotal);
                    o.setShipFee(java.math.BigDecimal.ZERO);
                    o.setTotal(subtotal);
                }
            }
            return o;
        }
    } catch (Exception e) { throw new RuntimeException(e); }
}

public boolean updateStatus(int orderId, String status) {
    String sql = "UPDATE donhang SET TrangThai=? WHERE MaDH=?";
    try (Connection con = Db.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, status);
        ps.setInt(2, orderId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) { throw new RuntimeException(e); }
}
}