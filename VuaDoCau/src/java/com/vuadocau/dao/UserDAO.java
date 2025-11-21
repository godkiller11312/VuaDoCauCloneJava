package com.vuadocau.dao;

import com.vuadocau.model.User;
import com.vuadocau.util.Db;
import com.vuadocau.util.PasswordUtil;

import java.sql.*;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    /* ========= Các hàm dùng chung ========= */

    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM nguoidung WHERE Email=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Đăng ký cho user thường (role=2, active=1) */
    public boolean create(String name, String email, String plainPassword) {
        // Avatar để NULL, DB sẽ nhận giá trị mặc định (nếu có)
        String sql = "INSERT INTO nguoidung(TenND, Email, MatKhau, RoleID, TrangThai) VALUES (?,?,?,?,1)";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, PasswordUtil.sha256(plainPassword));
            ps.setInt(4, 2); // USER
            return ps.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            return false; // email trùng
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User login(String email, String plainPassword) {
        String sql = "SELECT MaND, TenND, Email, Avatar, RoleID, TrangThai " +
                "FROM nguoidung WHERE Email=? AND MatKhau=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, PasswordUtil.sha256(plainPassword));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /* ========= Các hàm cho Admin ========= */

    /** Danh sách người dùng có filter + sort */
    public List<User> adminFindAll(String q, Integer roleId, Boolean active, String sort, String dir) {
        List<User> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT MaND, TenND, Email, Avatar, RoleID, TrangThai, NgayTao FROM nguoidung WHERE 1=1 "
        );

        // lọc theo q
        if (q != null && !q.isBlank()) {
            sql.append(" AND (TenND LIKE ? OR Email LIKE ?)");
        }
        // lọc theo role
        if (roleId != null) {
            sql.append(" AND RoleID = ").append(roleId);
        }
        // lọc theo trạng thái
        if (active != null) {
            sql.append(" AND TrangThai = ").append(active ? 1 : 0);
        }

        // sort
        String orderBy;
        switch (sort) {
            case "name":
                orderBy = "TenND";
                break;
            case "email":
                orderBy = "Email";
                break;
            case "roleId":
                orderBy = "RoleID";
                break;
            case "active":
                orderBy = "TrangThai";
                break;
            default:
                orderBy = "MaND";
        }
        String direction = "asc".equalsIgnoreCase(dir) ? "ASC" : "DESC";
        sql.append(" ORDER BY ").append(orderBy).append(" ").append(direction);

        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int i = 1;
            if (q != null && !q.isBlank()) {
                String kw = "%" + q.trim() + "%";
                ps.setString(i++, kw);
                ps.setString(i++, kw);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public User findById(int id) {
        String sql = "SELECT MaND, TenND, Email, Avatar, RoleID, TrangThai, NgayTao " +
                "FROM nguoidung WHERE MaND=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Tạo user theo tham số admin chọn */
    public boolean adminCreate(String name, String email, String plainPassword, int roleId, boolean active) {
        // tạm thời chưa cho chọn avatar trong màn admin -> để NULL
        String sql = "INSERT INTO nguoidung(TenND, Email, MatKhau, RoleID, TrangThai) VALUES (?,?,?,?,?)";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, PasswordUtil.sha256(plainPassword));
            ps.setInt(4, roleId);               // 1=ADMIN, 2=USER
            ps.setInt(5, active ? 1 : 0);       // 1=Hoạt động, 0=Khóa
            return ps.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            // Email trùng
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Cập nhật thông tin hồ sơ + quyền + trạng thái */
    public boolean updateProfile(int id, String name, String email, int roleId, boolean active) {
        String sql = "UPDATE nguoidung SET TenND=?, Email=?, RoleID=?, TrangThai=? WHERE MaND=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setInt(3, roleId);
            ps.setInt(4, active ? 1 : 0);
            ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /** Đặt lại mật khẩu */
    public boolean updatePassword(Integer id, String newPlainPassword) {
        String sql = "UPDATE nguoidung SET MatKhau=? WHERE MaND=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, PasswordUtil.sha256(newPlainPassword));
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Xóa tài khoản */
    public boolean delete(int id) {
        String sql = "DELETE FROM nguoidung WHERE MaND=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Cập nhật avatar cho user */
    public boolean updateAvatar(int id, String avatar) {
        String sql = "UPDATE nguoidung SET Avatar=? WHERE MaND=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (avatar == null || avatar.trim().isEmpty()) {
                ps.setNull(1, Types.VARCHAR);
            } else {
                ps.setString(1, avatar.trim());
            }
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /* ========= Mapper ========= */

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("MaND"));
        u.setName(rs.getString("TenND"));
        u.setEmail(rs.getString("Email"));
        u.setAvatar(rs.getString("Avatar"));
        u.setRoleId(rs.getInt("RoleID"));
        u.setActive(rs.getInt("TrangThai") == 1);
        // createdAt nếu muốn thì thêm try-catch để lấy NgayTao (không bắt buộc)
        return u;
    }
}
