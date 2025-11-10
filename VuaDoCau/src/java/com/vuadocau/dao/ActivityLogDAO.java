package com.vuadocau.dao;

import com.vuadocau.model.ActivityLog;
import com.vuadocau.model.User;
import com.vuadocau.util.Db;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ActivityLogDAO {

    private static final String SQL_INSERT =
            "INSERT INTO activity_log(UserId, Type, Message, Meta, IP, CreatedAt) " +
            "VALUES (?,?,?,?,?,NOW())";

    private static final String SQL_RECENT_BY_USER =
            "SELECT Id, UserId, Type, Message, Meta, IP, CreatedAt " +
            "FROM activity_log WHERE UserId=? ORDER BY CreatedAt DESC, Id DESC LIMIT ?";

    // --- helpers ---
    private static String getClientIp(HttpServletRequest req) {
        String[] keys = {
                "X-Forwarded-For","X-Real-IP","CF-Connecting-IP",
                "True-Client-IP","X-Client-IP","X-Cluster-Client-IP"
        };
        for (String k : keys) {
            String v = req.getHeader(k);
            if (v != null && !v.isBlank()) return v.split(",")[0].trim();
        }
        return req.getRemoteAddr();
    }

    // Ghi log cơ bản
    public void log(HttpServletRequest req, User user, String type, String message) throws Exception {
        try (Connection cn = Db.getConnection()) {
            PreparedStatement ps = cn.prepareStatement(SQL_INSERT);
            ps.setInt(1, user.getId());
            ps.setString(2, type);
            ps.setString(3, message);
            ps.setString(4, null);                      // Meta: chưa dùng
            ps.setString(5, getClientIp(req));
            ps.executeUpdate();
        }
    }

    // Ghi log “chống trùng”: nếu cùng chữ ký và trong windowMs thì bỏ qua
    public void logOnce(HttpServletRequest req, User user, String type, String message, long windowMs) throws Exception {
        HttpSession ss = req.getSession(false);
        if (ss == null) { log(req, user, type, message); return; }

        String sig = type + "||" + message;
        Long lastTs = (Long) ss.getAttribute("actlog_ts");
        String lastSig = (String) ss.getAttribute("actlog_sig");

        long now = System.currentTimeMillis();
        if (sig.equals(lastSig) && lastTs != null && (now - lastTs) < windowMs) {
            return; // bỏ log trùng
        }
        log(req, user, type, message);
        ss.setAttribute("actlog_sig", sig);
        ss.setAttribute("actlog_ts", now);
    }

    // Lấy hoạt động gần đây của user
    public List<ActivityLog> findRecentByUser(int userId, int limit) {
        List<ActivityLog> list = new ArrayList<>();
        try (Connection cn = Db.getConnection()) {
            PreparedStatement ps = cn.prepareStatement(SQL_RECENT_BY_USER);
            ps.setInt(1, userId);
            ps.setInt(2, Math.max(1, limit));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ActivityLog a = new ActivityLog();
                    a.setId(rs.getLong("Id"));
                    a.setUserId(rs.getInt("UserId"));
                    a.setType(rs.getString("Type"));
                    a.setMessage(rs.getString("Message"));
                    a.setMeta(rs.getString("Meta"));
                    a.setIp(rs.getString("IP"));
                    a.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    list.add(a);
                }
            }
        } catch (Exception ignore) {}
        return list;
    }
}