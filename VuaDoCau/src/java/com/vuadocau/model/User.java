package com.vuadocau.model;

public class User {
    private int id;
    private String name;
    private String email;
    private int roleId;      // 1=ADMIN, 2=USER
    private boolean active;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}