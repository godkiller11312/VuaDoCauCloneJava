package com.vuadocau.model;

import java.math.BigDecimal;
import java.util.*;

public class Cart {
    private final Map<Integer, CartItem> items = new LinkedHashMap<>();

    public Collection<CartItem> getItems() { return items.values(); }
    public CartItem getItem(int productId) { return items.get(productId); }

    public void add(Product p, int qty) {
        if (p == null || qty <= 0) return;

        // NOTE: nếu Product dùng getter khác, đổi p.getStock() cho khớp
        int stock = Math.max(0, p.getStock());
        CartItem it = items.get(p.getId());
        if (it == null) {
            int addQty = Math.min(qty, stock);
            it = new CartItem(p.getId(), p.getName(), p.getImage(), p.getPrice(), addQty, stock);
            items.put(p.getId(), it);
        } else {
            it.setStock(stock); // cập nhật nếu stock thay đổi
            int newQty = Math.min(it.getQuantity() + qty, stock);
            it.setQuantity(newQty);
        }
    }

    public void update(int productId, int qty) {
        CartItem it = items.get(productId);
        if (it == null) return;
        if (qty <= 0) { items.remove(productId); return; }
        int stock = Math.max(0, it.getStock());
        it.setQuantity(Math.min(qty, stock));
    }

    public void remove(int productId) { items.remove(productId); }
    public void clear() { items.clear(); }

    // Giữ lại duy nhất 1 sản phẩm trong giỏ, xóa các item khác
    public void keepOnly(int productId) {
        CartItem it = items.get(productId);
        items.clear();
        if (it != null) {
            items.put(productId, it);
        }
    }

    public int getTotalQty() {
        return items.values().stream().mapToInt(CartItem::getQuantity).sum();
    }

    public BigDecimal getTotalAmount() {
        return items.values().stream().map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public boolean isEmpty() { return items.isEmpty(); }
}
