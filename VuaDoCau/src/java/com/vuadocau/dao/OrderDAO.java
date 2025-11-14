package com.vuadocau.dao;

import com.vuadocau.model.*;
import com.vuadocau.util.Db;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /** ===================== TẠO ĐƠN: TRỪ TỒN KHO + TĂNG PURCHASED ===================== */
    public int create(Order o, Cart cart) {
        String sqlOrder = "INSERT INTO donhang (MaND, NgayDH, TrangThai, GhiChu) VALUES (?, NOW(), ?, ?)";
        String sqlItem  = "INSERT INTO chitietdh (MaDH, MaSP, SoLuong, Gia) VALUES (?,?,?,?)";

        // TRỪ tồn kho & TĂNG purchased ngay khi tạo đơn
        String sqlStock =
            "UPDATE sanpham SET TonKho = TonKho - ?, Purchased = Purchased + ? " +
            "WHERE MaSP = ? AND TonKho >= ?";

        try (Connection con = Db.getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement ps = con.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {

                // Tạo bản ghi đơn hàng
                ps.setInt(1, o.getUserId());
                ps.setString(2, o.getStatus()); // "NEW"
                ps.setString(3, o.getNote());
                ps.executeUpdate();

                int orderId;
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    rs.next();
                    orderId = rs.getInt(1);
                }

                try (PreparedStatement psi = con.prepareStatement(sqlItem);
                     PreparedStatement psStock = con.prepareStatement(sqlStock)) {

                    for (CartItem it : cart.getItems()) {
                        // 1) chèn chitietdh
                        psi.setInt(1, orderId);
                        psi.setInt(2, it.getProductId());
                        psi.setInt(3, it.getQuantity());
                        psi.setBigDecimal(4, it.getPrice());
                        psi.addBatch();

                        // 2) cập nhật tồn kho + purchased
                        psStock.setInt(1, it.getQuantity());  // TonKho = TonKho - qty
                        psStock.setInt(2, it.getQuantity());  // Purchased = Purchased + qty
                        psStock.setInt(3, it.getProductId());
                        psStock.setInt(4, it.getQuantity());  // điều kiện đủ tồn kho
                        int ok = psStock.executeUpdate();
                        if (ok == 0) {
                            con.rollback();
                            throw new RuntimeException("Không đủ tồn kho cho sản phẩm ID=" + it.getProductId());
                        }
                    }

                    psi.executeBatch();
                }

                con.commit();
                return orderId;

            } catch (Exception ex) {
                con.rollback();
                throw ex;
            } finally {
                con.setAutoCommit(true);
            }

        } catch (Exception e) {
            throw new RuntimeException("Create order failed", e);
        }
    }

    /** ===================== Lịch sử đơn theo user ===================== */
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
                    o.setTotal(rs.getBigDecimal("Tong"));

                    list.add(o);
                }
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return list;
    }


    /** ===================== Chi tiết 1 đơn của user ===================== */
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

                // Load items
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

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


    /** ===================== Các hàm admin list / filter ===================== */
    public List<Order> findAll(String q, String status, String sort, String dir) {
        String orderBy;

        switch (sort) {
            case "date":  orderBy = "dh.NgayDH"; break;
            case "total": orderBy = "Tong"; break;
            default:      orderBy = "dh.MaDH"; break;
        }

        String dirSql = "asc".equalsIgnoreCase(dir) ? "ASC" : "DESC";

        StringBuilder sb = new StringBuilder(
            "SELECT dh.MaDH, dh.NgayDH, dh.TrangThai, nd.TenND, nd.Email, " +
            "       COALESCE(SUM(ct.SoLuong*ct.Gia),0) AS Tong " +
            "FROM donhang dh " +
            "JOIN nguoidung nd ON nd.MaND = dh.MaND " +
            "LEFT JOIN chitietdh ct ON ct.MaDH = dh.MaDH "
        );

        List<Object> params = new ArrayList<>();
        boolean where = false;

        if (status != null && !status.isBlank()) {
            sb.append(" WHERE dh.TrangThai = ?");
            params.add(status);
            where = true;
        }

        if (q != null && !q.isBlank()) {
            sb.append(where ? " AND" : " WHERE")
              .append(" (CAST(dh.MaDH AS CHAR) LIKE ? OR nd.Email LIKE ? OR nd.TenND LIKE ?)");
            String like = "%" + q.trim() + "%";
            params.add(like); params.add(like); params.add(like);
        }

        sb.append(" GROUP BY dh.MaDH, dh.NgayDH, dh.TrangThai, nd.TenND, nd.Email ")
          .append(" ORDER BY ").append(orderBy).append(" ").append(dirSql);

        List<Order> list = new ArrayList<>();

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sb.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

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

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        return list;
    }


    /** ===================== Chi tiết đơn admin ===================== */
    public Order findAdminById(int orderId) {
        String sql =
            "SELECT dh.MaDH, dh.MaND, dh.NgayDH, dh.TrangThai, dh.GhiChu, nd.TenND, nd.Email " +
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
                        o.setShipFee(java.math.BigDecimal.ZERO);
                        o.setTotal(subtotal);
                    }
                }

                return o;
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


    /** ===================== Action NEW → CANCELED ===================== */
    public boolean userCancelIfNew(int orderId, int userId) {
        final String sql =
            "UPDATE donhang SET TrangThai='CANCELED' WHERE MaDH=? AND MaND=? AND TrangThai='NEW'";

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /** ===================== Admin: NEW → CONFIRMED ===================== */
    public boolean adminConfirmIfNew(int orderId) {
        final String sql =
            "UPDATE donhang SET TrangThai='CONFIRMED' WHERE MaDH=? AND TrangThai='NEW'";

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /** ===================== Admin: NEW → CANCELED ===================== */
    public boolean adminRejectIfNew(int orderId) {
        final String sql =
            "UPDATE donhang SET TrangThai='CANCELED' WHERE MaDH=? AND TrangThai='NEW'";

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /** ===================== Admin: CONFIRMED → SHIPPING ===================== */
    public boolean adminStartShippingIfConfirmed(int orderId) {
        final String sql =
            "UPDATE donhang SET TrangThai='SHIPPING' WHERE MaDH=? AND TrangThai='CONFIRMED'";

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /** ===================== User: SHIPPING → DONE ===================== */
    public boolean userMarkDoneIfShipping(int orderId, int userId) {
        final String sql =
            "UPDATE donhang SET TrangThai='DONE' WHERE MaDH=? AND MaND=? AND TrangThai='SHIPPING'";

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


    /** ===================== updateStatus / insertAdmin / delete ===================== */
    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE donhang SET TrangThai=? WHERE MaDH=?";

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, orderId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public int insertAdmin(int userId, String status, String note) {
        final String sql =
            "INSERT INTO donhang (MaND, NgayDH, TrangThai, GhiChu) VALUES (?, NOW(), ?, ?)";

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, userId);
            ps.setString(2, status);
            ps.setString(3, note);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }

            throw new RuntimeException("Không lấy được MaDH sau khi insert.");

        } catch (Exception e) {
            throw new RuntimeException("insertAdmin failed: " + e.getMessage(), e);
        }
    }

    public boolean delete(int orderId) {
        final String sqlDeleteItems = "DELETE FROM chitietdh WHERE MaDH=?";
        final String sqlDeleteOrder = "DELETE FROM donhang WHERE MaDH=?";

        try (Connection con = Db.getConnection()) {
            con.setAutoCommit(false);

            try (PreparedStatement psi = con.prepareStatement(sqlDeleteItems);
                 PreparedStatement pso = con.prepareStatement(sqlDeleteOrder)) {

                psi.setInt(1, orderId);
                psi.executeUpdate();

                pso.setInt(1, orderId);
                int rows = pso.executeUpdate();

                con.commit();
                return rows > 0;

            } catch (Exception ex) {
                con.rollback();
                throw ex;

            } finally {
                con.setAutoCommit(true);
            }

        } catch (Exception e) {
            throw new RuntimeException("Delete order failed: " + e.getMessage(), e);
        }
    }


    /** ===================== Hàm phụ tăng purchased (nếu dùng ở bước DONE) ===================== */
    public void increasePurchasedForOrder(int orderId) {
        final String sql =
            "UPDATE sanpham sp " +
            "JOIN chitietdh ct ON sp.MaSP = ct.MaSP " +
            "SET sp.Purchased = sp.Purchased + ct.SoLuong " +
            "WHERE ct.MaDH = ?";

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException(
                "increasePurchasedForOrder failed for MaDH=" + orderId, e);
        }
    }
}
