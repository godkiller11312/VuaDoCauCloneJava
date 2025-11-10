package com.vuadocau.model;

import java.math.BigDecimal;

public class CartItem {
    private int productId;
    private String name;
    private String image;
    private BigDecimal price;   // đơn giá tại thời điểm thêm
    private int quantity;
    private int stock;          // tồn kho tại thời điểm thêm

    public CartItem() { }

    public CartItem(int productId, String name, String image, BigDecimal price, int quantity, int stock) {
        this.productId = productId;
        this.name = name;
        this.image = image;
        this.price = price;
        this.quantity = quantity;
        this.stock = stock;
    }

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

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public BigDecimal getSubtotal() {
        return price.multiply(BigDecimal.valueOf(quantity));
    }
}