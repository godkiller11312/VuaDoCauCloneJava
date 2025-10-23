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


@WebServlet(name="ProductController", urlPatterns={"/products"})
public class ProductController extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Product> products = productDAO.findAll();
        req.setAttribute("products", products);
        req.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(req, resp);
    }
}