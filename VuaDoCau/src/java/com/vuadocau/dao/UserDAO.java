package com.vuadocau.dao;

import com.vuadocau.model.User;
import com.vuadocau.util.Db;
import com.vuadocau.util.PasswordUtil;

import java.sql.*;

public class UserDAO {

    public boolean emailExists(String email) {
        String sql = "SELECT 1 FROM nguoidung WHERE Email=?";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean create(String name, String email, String plainPassword) {
        String sql = "INSERT INTO nguoidung(TenND, Email, MatKhau, RoleID, TrangThai) VALUES (?,?,?,?,1)";
        try (Connection con = Db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, PasswordUtil.sha256(plainPassword));
            ps.setInt(4, 2); // USER
            return ps.executeUpdate() > 0;
        } catch (SQLIntegrityConstraintViolationException e) {
            // email trùng
            return false;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

  public User login(String email, String plainPassword) {
    String sql = "SELECT n.MaND, n.TenND, n.Email, n.RoleID, n.TrangThai, r.RoleName " +
                 "FROM nguoidung n JOIN roles r ON n.RoleID = r.RoleID " +
                 "WHERE n.Email=? AND n.MatKhau=?";
    try (Connection con = Db.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
        ps.setString(1, email);
        ps.setString(2, PasswordUtil.sha256(plainPassword));
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("MaND"));
                u.setName(rs.getString("TenND"));
                u.setEmail(rs.getString("Email"));
                u.setRoleId(rs.getInt("RoleID"));
                u.setRole(rs.getString("RoleName")); // "ADMIN"/"USER"
                u.setActive(rs.getInt("TrangThai") == 1);
                return u;
            }
        }
    } catch (Exception e) { e.printStackTrace(); }
    return null;
}
}