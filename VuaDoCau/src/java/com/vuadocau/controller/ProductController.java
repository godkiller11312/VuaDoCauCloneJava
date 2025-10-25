package com.vuadocau.controller;

import com.vuadocau.dao.ProductDAO;
import com.vuadocau.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductController", urlPatterns = {"/products"})
public class ProductController extends HttpServlet {

    private final ProductDAO dao = new ProductDAO();

   @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

    String q   = req.getParameter("q");   // keyword
    String g   = req.getParameter("g");   // group: all|can|may|khac
    String cat = req.getParameter("cat"); // nếu anh vẫn muốn dùng cat=ID

    List<Product> products;

    if (q != null && !q.isBlank()) {
        products = dao.search(q.trim());
    } else if (cat != null && !cat.isBlank()) {
        // hỗ trợ đường dẫn cũ: ?cat=1
        try { products = dao.findByCategory(Integer.parseInt(cat)); }
        catch (NumberFormatException e) { products = dao.findAll(); }
    } else if ("can".equals(g)) {
        products = dao.findByCategory(1);                 // Cần câu
    } else if ("may".equals(g)) {
        products = dao.findByCategory(2);                 // Máy câu
    } else if ("khac".equals(g)) {
        products = dao.findByCategoryIds(3, 4, 5);        // Dây / Mồi / Phụ kiện
    } else {
        products = dao.findAll();                         // Tất cả
        g = "all";
    }

    req.setAttribute("products", products);
    req.setAttribute("q", q);
    req.setAttribute("g", g);
    req.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(req, resp);
}
}