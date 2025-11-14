package com.vuadocau.dao;

import com.vuadocau.model.Review;
import com.vuadocau.util.Db;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    /** Thêm/sửa review (1 user / 1 sản phẩm) */
    public boolean upsert(int productId, int userId, int rating, String comment) {
        String sql =
            "INSERT INTO review (MaSP, MaND, Rating, Comment, CreatedAt) " +
            "VALUES (?,?,?,?, NOW()) " +
            "ON DUPLICATE KEY UPDATE " +
            "  Rating    = VALUES(Rating), " +
            "  Comment   = VALUES(Comment), " +
            "  CreatedAt = VALUES(CreatedAt)";

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ps.setInt(2, userId);
            ps.setInt(3, rating);
            ps.setString(4, comment);

            int rows = ps.executeUpdate();

            // Sau khi insert/update -> cập nhật lại rating trung bình vào bảng sanpham
            updateProductAverageRating(con, productId);

            return rows > 0;
        } catch (Exception e) {
            throw new RuntimeException("upsert review failed: " + e.getMessage(), e);
        }
    }

    /** Cập nhật Rating trung bình trong bảng sanpham từ bảng review */
    private void updateProductAverageRating(Connection con, int productId) throws SQLException {
        String sql =
            "UPDATE sanpham sp " +
            "SET sp.Rating = (" +
            "   SELECT COALESCE(AVG(r.Rating), 0) FROM review r WHERE r.MaSP = sp.MaSP" +
            ") " +
            "WHERE sp.MaSP = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.executeUpdate();
        }
    }

    /** Lấy danh sách review của 1 sản phẩm */
    public List<Review> findByProduct(int productId) {
        String sql =
            "SELECT r.Id, r.MaSP, r.MaND, r.Rating, r.Comment, r.CreatedAt, nd.TenND " +
            "FROM review r JOIN nguoidung nd ON nd.MaND = r.MaND " +
            "WHERE r.MaSP = ? " +
            "ORDER BY r.CreatedAt DESC";

        List<Review> list = new ArrayList<>();
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, productId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review rv = new Review();
                    rv.setId(rs.getInt("Id"));
                    rv.setProductId(rs.getInt("MaSP"));
                    rv.setUserId(rs.getInt("MaND"));
                    rv.setRating(rs.getInt("Rating"));
                    rv.setComment(rs.getString("Comment"));
                    Timestamp ts = rs.getTimestamp("CreatedAt");
                    if (ts != null) rv.setCreatedAt(new java.util.Date(ts.getTime()));
                    rv.setUserName(rs.getString("TenND"));
                    list.add(rv);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("findByProduct failed: " + e.getMessage(), e);
        }
        return list;
    }
}
