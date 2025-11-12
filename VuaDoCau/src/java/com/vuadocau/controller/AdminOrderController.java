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
                    resp.sendRedirect(req.getContextPath() + "/admin/orders");
                    return;
                }
                order.setShipFee(BigDecimal.ZERO);
                order.setTotal(order.getSubtotal().add(order.getShipFee()));
                req.setAttribute("order", order);
                forwardLayout(req, resp, "/WEB-INF/views/admin/order-detail.jsp",
                        "Chi tiết đơn #" + order.getId());
                return;
            } catch (Exception ex) {
                req.getSession().setAttribute("flash_error", "Lỗi: " + ex.getMessage());
                resp.sendRedirect(req.getContextPath() + "/admin/orders");
                return;
            }
        }

        // list + filter + sort
        String q = req.getParameter("q");
        String status = req.getParameter("status");
        String sort = req.getParameter("sort");
        String dir  = req.getParameter("dir");
        if (sort == null || sort.isBlank()) sort = "id";
        if (dir  == null || dir.isBlank())  dir  = "desc";
        if (!Arrays.asList("id", "date", "total").contains(sort)) sort = "id";
        dir = "asc".equalsIgnoreCase(dir) ? "asc" : "desc";

        List<Order> orders = orderDAO.findAll(q, status, sort, dir);

        req.setAttribute("orders", orders);
        req.setAttribute("q", q);
        req.setAttribute("status", status);
        req.setAttribute("sort", sort);
        req.setAttribute("dir", dir);

        forwardLayout(req, resp, "/WEB-INF/views/admin/orders.jsp", "Quản Lý Đơn hàng");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/home"); return; }
        req.setCharacterEncoding("UTF-8");

        HttpSession ss = req.getSession();
        String action = req.getParameter("action");
        int id;
        try { id = Integer.parseInt(req.getParameter("id")); }
        catch (Exception ex) { ss.setAttribute("flash_error", "Yêu cầu không hợp lệ."); resp.sendRedirect(req.getContextPath()+"/admin/orders"); return; }

        try {
            boolean ok = false;
            switch (action == null ? "" : action) {
                case "confirm":
                    ok = orderDAO.adminConfirmIfNew(id);
                    ss.setAttribute(ok ? "flash_success" : "flash_error",
                            ok ? ("Đã xác nhận đơn #" + id) : ("Không thể xác nhận (trạng thái không hợp lệ)."));
                    break;
                case "reject":
                    ok = orderDAO.adminRejectIfNew(id);
                    ss.setAttribute(ok ? "flash_success" : "flash_error",
                            ok ? ("Đã từ chối đơn #" + id) : ("Không thể từ chối (trạng thái không hợp lệ)."));
                    break;
                case "startShipping":
                    ok = orderDAO.adminStartShippingIfConfirmed(id);
                    ss.setAttribute(ok ? "flash_success" : "flash_error",
                            ok ? ("Đã chuyển đơn #" + id + " sang ĐANG GIAO") : ("Không thể bắt đầu giao (trạng thái không hợp lệ)."));
                    break;
                case "delete":
                    ok = orderDAO.delete(id);
                    ss.setAttribute(ok ? "flash_success" : "flash_error",
                            ok ? ("Đã xóa đơn #" + id) : ("Không thể xóa đơn #" + id));
                    break;
                default:
                    ss.setAttribute("flash_error", "Action không hợp lệ.");
            }
        } catch (Exception e) {
            ss.setAttribute("flash_error", "Lỗi: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/admin/orders");
    }
}
