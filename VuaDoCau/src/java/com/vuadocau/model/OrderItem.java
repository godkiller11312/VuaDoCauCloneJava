package com.vuadocau.model;

import java.math.BigDecimal;

public class OrderItem {
    private int orderId;
    private int productId;
    private String name;   // từ sanpham.TenSP
    private String image;  // từ sanpham.Anh
    private BigDecimal price; // chitietdh.Gia (đơn giá tại thời điểm đặt)
    private int quantity;

    public BigDecimal getSubtotal() {
        return price.multiply(BigDecimal.valueOf(quantity));
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}