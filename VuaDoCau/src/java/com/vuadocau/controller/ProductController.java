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

        String q      = req.getParameter("q");     // keyword
        String g      = req.getParameter("g");     // group: all|can|may|khac
        String cat    = req.getParameter("cat");   // cat=ID (nếu dùng)
        String sortTop = req.getParameter("sortTop");
        String sortNew = req.getParameter("sortNew");

        boolean isTopSeller = "1".equals(sortTop);
        boolean isNewest    = "1".equals(sortNew);

        List<Product> products;

        // ================== TOP SELLER MODE ==================
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
                products = dao.findByCategoryIdsOrderByPurchasedDesc(3, 4, 5); // Dây / Mồi / Phụ kiện
            } else {
                products = dao.findAllOrderByPurchasedDesc(); // tất cả, sort theo Purchased
                g = "all";
            }
        }
        // ================== BÌNH THƯỜNG (mặc định là "mới nhất") ==================
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
                products = dao.findAll();           // mặc định: mới nhất (ORDER BY MaSP DESC)
                g = "all";
            }
            // isNewest == 1 thì vẫn dùng các hàm trên (đều ORDER BY MaSP DESC sẵn rồi)
        }

        // ===== Đẩy ra view =====
        req.setAttribute("products", products);
        req.setAttribute("q", q);
        req.setAttribute("g", g);
        req.setAttribute("sortTop", isTopSeller ? "1" : null);
        req.setAttribute("sortNew", isNewest ? "1" : null);

        req.setAttribute("view", "/WEB-INF/views/products.jsp");
        req.setAttribute("pageTitle", "Sản phẩm");
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }
}
