package com.vuadocau.controller;

import com.vuadocau.dao.ProductDAO;
import com.vuadocau.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductController", urlPatterns = {"/products"})
public class ProductController extends HttpServlet {

    private final ProductDAO dao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String q       = req.getParameter("q");      // keyword
        String g       = req.getParameter("g");      // all|can|may|khac
        String cat     = req.getParameter("cat");    // cat=ID (nếu dùng)
        String sortTop = req.getParameter("sortTop");
        String sortNew = req.getParameter("sortNew");

        boolean isTopSeller = "1".equals(sortTop);
        // Nếu không phải top thì mặc định là "mới nhất"
        boolean isNewest = !isTopSeller;

        List<Product> products;

        // ========= TOP SELLER =========
        if (isTopSeller) {
            if (q != null && !q.isBlank()) {
                products = dao.searchOrderByPurchasedDesc(q.trim());
            } else if (cat != null && !cat.isBlank()) {
                try {
                    int catId = Integer.parseInt(cat);
                    products = dao.findByCategoryOrderByPurchasedDesc(catId);
                } catch (NumberFormatException ex) {
                    products = dao.findAllOrderByPurchasedDesc();
                }
            } else if ("can".equals(g)) {
                products = dao.findByCategoryOrderByPurchasedDesc(1); // Cần câu
            } else if ("may".equals(g)) {
                products = dao.findByCategoryOrderByPurchasedDesc(2); // Máy câu
            } else if ("khac".equals(g)) {
                products = dao.findByCategoryIdsOrderByPurchasedDesc(3, 4, 5);
            } else {
                products = dao.findAllOrderByPurchasedDesc();
                g = "all";
            }
        }
        // ========= MỚI NHẤT (mặc định) =========
        else {
            if (q != null && !q.isBlank()) {
                products = dao.search(q.trim());
            } else if (cat != null && !cat.isBlank()) {
                try {
                    int catId = Integer.parseInt(cat);
                    products = dao.findByCategory(catId);
                } catch (NumberFormatException ex) {
                    products = dao.findAll();
                }
            } else if ("can".equals(g)) {
                products = dao.findByCategory(1);
            } else if ("may".equals(g)) {
                products = dao.findByCategory(2);
            } else if ("khac".equals(g)) {
                products = dao.findByCategoryIds(3, 4, 5);
            } else {
                // findAll() nhớ ORDER BY MaSP DESC để ra "mới nhất"
                products = dao.findAll();
                g = "all";
            }
        }

        // ===== Đẩy ra view =====
        req.setAttribute("products", products);
        req.setAttribute("q", q);
        req.setAttribute("g", g);

        // Thuộc tính dùng cho JSP để set active nút
        req.setAttribute("sortTop", isTopSeller ? "1" : null);
        req.setAttribute("sortNew", isNewest ? "1" : null);

        req.setAttribute("view", "/WEB-INF/views/products.jsp");
        req.setAttribute("pageTitle", "Sản phẩm");
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }
}
