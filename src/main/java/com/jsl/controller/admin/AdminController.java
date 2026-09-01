package com.jsl.controller.admin;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dto.member.LoginUserDto;

@WebServlet("/admin/*")
public class AdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doAction(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doAction(request, response);
    }

    private void doAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    	LoginUserDto user = (LoginUserDto) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        if (!"A".equals(user.getUserGrade())) {
            response.sendRedirect("/");
            return;
        }
    	
        String path = request.getPathInfo();
        String page = null;

        switch (path) {
            case "/main":
                page = "/WEB-INF/views/admin/main.jsp";
                break;

            case "/member/list":
                // 회원 목록
                break;

            case "/member/updateGrade":
                // 회원 등급 변경
                break;

            case "/member/delete":
                // 회원 삭제
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
        
        if (page != null) {
			request.getRequestDispatcher(page).forward(request, response);
		}
    }
}