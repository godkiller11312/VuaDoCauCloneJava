package com.vuadocau.controller;

import com.vuadocau.dao.CategoryDAO;
import com.vuadocau.dao.ProductDAO;
import com.vuadocau.model.Category;
import com.vuadocau.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet(name="HomeController", urlPatterns={"/home"})
public class HomeController extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ProductDAO  productDAO  = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int limit = 8; // số sp/khối
        List<Category> cats = categoryDAO.findAll();

        // Map<category, list products>
        Map<Category, List<Product>> sections = new LinkedHashMap<>();
        for (Category c : cats) {
            sections.put(c, productDAO.findTopByCategory(c.getId(), limit));
        }
        req.setAttribute("sections", sections);
        req.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(req, resp);
    }
}