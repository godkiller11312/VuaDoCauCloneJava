package com.vuadocau.controller;

import com.vuadocau.dao.ActivityLogDAO;
import com.vuadocau.dao.OrderDAO;
import com.vuadocau.model.Order;
import com.vuadocau.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "AdminOrderController", urlPatterns = {"/admin/orders"})
public class AdminOrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final ActivityLogDAO actDAO = new ActivityLogDAO();

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        if (s == null) return false;
        Object o = s.getAttribute("authUser");
        return (o instanceof User) && ((User) o).getRoleId() == 1;
    }

    /** Forward qua layout chung */
    private void forwardLayout(HttpServletRequest req, HttpServletResponse resp,
                               String viewPath, String pageTitle)
            throws ServletException, IOException {
        req.setAttribute("view", viewPath);
        if (pageTitle != null) req.setAttribute("pageTitle", pageTitle);
        req.getRequestDispatcher("/WEB-INF/views/_layout/main.jsp").forward(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/home"); return; }
        req.setCharacterEncoding("UTF-8");

        User admin = (User) req.getSession().getAttribute("authUser");
        String action = req.getParameter("action");

        if ("detail".equalsIgnoreCase(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                Order order = orderDAO.findAdminById(id);
                if (order == null) {
                    req.getSession().setAttribute("flash_error", "Không tìm thấy đơn #" + id);
                    if (admin != null) actDAO.log(req, admin, "ORDER_VIEW", "Không tìm thấy đơn #" + id);
                    resp.sendRedirect(req.getContextPath() + "/admin/orders");
                    return;
                }
                order.setShipFee(BigDecimal.ZERO);
                order.setTotal(order.getSubtotal().add(order.getShipFee()));

                if (admin != null) actDAO.log(req, admin, "ORDER_VIEW", "Xem đơn #" + order.getId());

                req.setAttribute("order", order);

                // ✅ dùng layout
                forwardLayout(req, resp, "/WEB-INF/views/admin/order-detail.jsp",
                        "Chi tiết đơn #" + order.getId());
                return;
            } catch (Exception ex) {
                ex.printStackTrace();
                if (admin != null) {
                    try { actDAO.log(req, admin, "ERROR", "AdminOrderController.detail: " + ex.getMessage()); }
                    catch (Exception ignore) {}
                }
                req.getSession().setAttribute("flash_error", "Lỗi: " + ex.getMessage());
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
                return;
            }
        }

        // ===== Danh sách + lọc + sắp xếp =====
        String q = req.getParameter("q");
        String status = req.getParameter("status");

        // sort/dir whitelist
        String sort = req.getParameter("sort");
        String dir  = req.getParameter("dir");
        if (sort == null || sort.isBlank()) sort = "id";
        if (dir  == null || dir.isBlank())  dir  = "desc";
        if (!Arrays.asList("id", "date", "total").contains(sort)) sort = "id";
        dir = "asc".equalsIgnoreCase(dir) ? "asc" : "desc";

        List<Order> orders = orderDAO.findAll(q, status, sort, dir);

        if (admin != null) {
            String msg = String.format("Lọc đơn: q='%s', status='%s', sort='%s', dir='%s', count=%d",
                    nullToEmpty(q), nullToEmpty(status), sort, dir, (orders == null ? 0 : orders.size()));
            try { actDAO.log(req, admin, "ORDER_LIST", msg); } catch (Exception ignore) {}
        }

        req.setAttribute("orders", orders);
        req.setAttribute("q", q);
        req.setAttribute("status", status);
        req.setAttribute("sort", sort);
        req.setAttribute("dir", dir);

        // ✅ dùng layout
        forwardLayout(req, resp, "/WEB-INF/views/admin/orders.jsp", "Quản Lý Đơn hàng");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/home"); return; }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        User admin = (User) req.getSession().getAttribute("authUser");

        try {
            if ("updateStatus".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                String st = req.getParameter("status");
                try {
                    orderDAO.updateStatus(id, st);
                    req.getSession().setAttribute("flash_success", "Đã cập nhật trạng thái đơn #" + id);
                    if (admin != null) actDAO.log(req, admin, "ORDER_UPDATE_STATUS",
                            "Đổi trạng thái đơn #" + id + " -> " + st);
                } catch (Exception ex) {
                    if (admin != null) actDAO.log(req, admin, "ORDER_UPDATE_STATUS_FAIL",
                            "Cập nhật trạng thái đơn #" + id + " thất bại: " + ex.getMessage());
                    throw ex;
                }

            } else if ("create".equals(action)) {
                int userId = Integer.parseInt(req.getParameter("userId"));
                String st   = req.getParameter("status");
                String note = req.getParameter("note");
                try {
                    int newId = orderDAO.insertAdmin(userId, st, note);
                    req.getSession().setAttribute("flash_success", "Đã tạo đơn mới #" + newId);
                    if (admin != null) actDAO.log(req, admin, "ORDER_CREATE",
                            "Tạo đơn #" + newId + " cho userId=" + userId + ", status=" + st);
                } catch (Exception ex) {
                    if (admin != null) actDAO.log(req, admin, "ORDER_CREATE_FAIL",
                            "Tạo đơn thất bại cho userId=" + userId + ": " + ex.getMessage());
                    throw ex;
                }

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                boolean ok = orderDAO.delete(id);
                if (ok) {
                    req.getSession().setAttribute("flash_success", "Đã xóa đơn #" + id);
                    if (admin != null) actDAO.log(req, admin, "ORDER_DELETE", "Xóa đơn #" + id);
                } else {
                    req.getSession().setAttribute("flash_error", "Không thể xóa đơn #" + id);
                    if (admin != null) actDAO.log(req, admin, "ORDER_DELETE_FAIL", "Xóa đơn #" + id + " thất bại");
                }

            } else {
                req.getSession().setAttribute("flash_error", "Action không hợp lệ.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (admin != null) {
                try { actDAO.log(req, admin, "ERROR", "AdminOrderController: " + e.getMessage()); }
                catch (Exception ignore) {}
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/orders");
    }

    private static String nullToEmpty(String s){ return s == null ? "" : s; }
}
