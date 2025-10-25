package com.vuadocau.controller;

import com.vuadocau.util.Db;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/debug/db")
public class DebugDbServlet extends HttpServlet {
  @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    resp.setContentType("text/plain; charset=UTF-8");
    PrintWriter out = resp.getWriter();
    try (Connection con = Db.getConnection();
         Statement st = con.createStatement()) {

      ResultSet r1 = st.executeQuery("SELECT DATABASE()");
      r1.next();
      out.println("DATABASE() = " + r1.getString(1));

      ResultSet r2 = st.executeQuery("SELECT COUNT(*) FROM sanpham");
      r2.next();
      out.println("sanpham.count = " + r2.getInt(1));

    } catch (Throwable t) {
      out.println("ERROR: " + t.getClass().getName() + ": " + t.getMessage());
      StringWriter sw = new StringWriter();
      t.printStackTrace(new PrintWriter(sw));
      out.println(sw.toString()); // in full stacktrace
    }
    out.flush();
  }
}