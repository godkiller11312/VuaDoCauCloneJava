package com.vuadocau.model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class Order {
    private int id;
    private int userId;
    private String fullName;    // lấy từ bảng nguoidung
    private String email;       // lấy từ bảng nguoidung
    private String note;        // donhang.GhiChu (gói SDT/Địa chỉ/Ghi chú)
    private String status;      // NEW | CONFIRMED | SHIPPING | DONE | CANCELED
    private Date createdAt;

    // Tổng động
    private BigDecimal subtotal; // sum(ct.SoLuong * ct.Gia)
    private BigDecimal shipFee;  // set ở controller
    private BigDecimal total;    // subtotal + shipFee

    private List<OrderItem> items; // chi tiết đơn

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

 public Date getCreatedAt() { return createdAt; }
 public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    public BigDecimal getShipFee() { return shipFee; }
    public void setShipFee(BigDecimal shipFee) { this.shipFee = shipFee; }

    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
}