package com.jsl.util;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/dbtest")
public class DBTestController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain;charset=UTF-8");

        try (Connection conn = DBManager.getConnection()) {
            response.getWriter().println(conn != null ? "DB 연결 성공" : "DB 연결 실패");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("DB 연결 실패: " + e.getMessage());
        }
    }
}