package com.vuadocau.controller;

import com.vuadocau.dao.CategoryDAO;
import com.vuadocau.dao.ProductDAO;
import com.vuadocau.model.Category;
import com.vuadocau.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        /* ============================================================
           1) LẤY SẢN PHẨM MỖI DANH MỤC (dùng cho "Tìm theo thể loại")
           ============================================================ */
        List<Category> categories = categoryDAO.findAll();
        Map<Category, List<Product>> sections = new LinkedHashMap<>();

        for (Category c : categories) {
            sections.put(c, productDAO.findTopByCategory(c.getId(), 8));
        }

        /* ============================================================
           2) TOP SELLER (sort theo Purchased DESC)
           ============================================================ */
        List<Product> topProducts = productDAO.findAllOrderByPurchasedDesc();
        if (topProducts.size() > 8) {
            topProducts = topProducts.subList(0, 8);
        }

        /* ============================================================
           3) SẢN PHẨM MỚI NHẤT (sort theo MaSP DESC)
           ============================================================ */
        List<Product> newProducts = productDAO.findAll();  // mặc định đã ORDER BY MaSP DESC
        if (newProducts.size() > 8) {
            newProducts = newProducts.subList(0, 8);
        }

        /* ============================================================
           ĐẢY DỮ LIỆU RA VIEW
           ============================================================ */
        req.setAttribute("sections", sections);
        req.setAttribute("topProducts", topProducts);
        req.setAttribute("newProducts", newProducts);

        req.setAttribute("view", "/WEB-INF/views/home.jsp");
        req.setAttribute("pageTitle", "Trang chủ");

        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp")
                .forward(req, resp);
    }
}
