package com.vuadocau.model;

import java.sql.Timestamp;
import java.util.Objects;

/**
 * User model
 * - roleId: 1 = ADMIN, 2 = USER
 * - active: true = hoạt động, false = khóa
 *
 * Lưu ý: có thêm getStatus()/setStatus() để tương thích với JSP cũ gọi ${u.status}
 */
public class User {

    private int id;
    private String name;
    private String email;

    // KHÔNG serialize password ra view; chỉ dùng ở DAO (nếu cần)
    private String password;

    private int roleId;        // 1: ADMIN, 2: USER
    private boolean active;    // tương ứng cột TrangThai (1/0)

    private String avatar;     // tên file hoặc URL avatar
    private Timestamp createdAt; // nếu DB có (không bắt buộc)

    public User() {}

    public User(int id, String name, String email, int roleId, boolean active) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.roleId = roleId;
        this.active = active;
    }

    // ===== Getter/Setter =====
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name != null ? name.trim() : null;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email != null ? email.trim() : null;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password; // hash ở DAO/service
    }

    public int getRoleId() {
        return roleId;
    }
    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public boolean isActive() {
        return active;
    }
    public void setActive(boolean active) {
        this.active = active;
    }

    // Alias cho tương thích JSP cũ: ${u.status}
    public boolean getStatus() {
        return active;
    }
    public void setStatus(boolean status) {
        this.active = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getAvatar() {
        return avatar;
    }
    public void setAvatar(String avatar) {
        this.avatar = avatar != null ? avatar.trim() : null;
    }

    // ===== Helper =====
    public boolean isAdmin() {
        return roleId == 1;
    }

    public String getRoleName() {
        return roleId == 1 ? "ADMIN" : "USER";
    }

    @Override
    public String toString() {
        return "User{id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", roleId=" + roleId +
                ", active=" + active +
                ", avatar='" + avatar + '\'' +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof User)) return false;
        User user = (User) o;
        return id == user.id;
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
