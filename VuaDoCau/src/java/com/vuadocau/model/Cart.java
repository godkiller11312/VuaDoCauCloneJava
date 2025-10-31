package com.vuadocau.model;

import java.math.BigDecimal;
import java.util.*;

public class Cart {
    // key = productId
    private final Map<Integer, CartItem> items = new LinkedHashMap<>();

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public CartItem getItem(int productId) {
        return items.get(productId);
    }

    public void add(Product p, int qty) {
        if (p == null || qty <= 0) return;
        CartItem it = items.get(p.getId());
        if (it == null) {
            it = new CartItem(p.getId(), p.getName(), p.getImage(), p.getPrice(), qty);
            items.put(p.getId(), it);
        } else {
            it.setQuantity(it.getQuantity() + qty);
        }
    }

    public void update(int productId, int qty) {
        CartItem it = items.get(productId);
        if (it == null) return;
        if (qty <= 0) items.remove(productId);
        else it.setQuantity(qty);
    }

    public void remove(int productId) {
        items.remove(productId);
    }

    public void clear() {
        items.clear();
    }

    public int getTotalQty() {
        return items.values().stream().mapToInt(CartItem::getQuantity).sum();
    }

    public BigDecimal getTotalAmount() {
        return items.values().stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }
}