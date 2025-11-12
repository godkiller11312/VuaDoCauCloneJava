package com.vuadocau.controller;

import com.vuadocau.dao.ProductDAO;
import com.vuadocau.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name="ProductDetailController", urlPatterns={"/product"})
public class ProductDetailController extends HttpServlet {
    private final ProductDAO dao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String sid = req.getParameter("id");
        Product p = null;
        try {
            int id = Integer.parseInt(sid);
            p = dao.findById(id);
        } catch (Exception ignored) { }

        if (p == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        req.setAttribute("p", p);
        req.setAttribute("pageTitle", p.getName());
        req.setAttribute("view", "/WEB-INF/views/product_detail.jsp");
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }
}
