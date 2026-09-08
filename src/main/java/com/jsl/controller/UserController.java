package com.jsl.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dto.member.LoginUserDto;
import com.jsl.service.member.EmailVerificationCheckService;
import com.jsl.service.user.UserProfileService;

@WebServlet("/user/*")
public class UserController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final EmailVerificationCheckService emailVerificationCheckService = new EmailVerificationCheckService();
    private final UserProfileService userProfileService = new UserProfileService();

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

        HttpSession session = request.getSession(false);
        LoginUserDto user = (session != null) ? (LoginUserDto) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        String path = request.getPathInfo(); // ★ getServletPath() 대신
        if (path == null) {
            path = "/profile";
        }

        String page = null;

        switch (path) {

        case "/profile":
        	userProfileService.doCommand(request, response);
            page = "/WEB-INF/views/user/profile.jsp";
            break;

        case "/settings":
            page = "/WEB-INF/views/user/settings.jsp";
            break;

		case "/email-verification":
		    emailVerificationCheckService.doCommand(request, response);
		    page = "/WEB-INF/views/user/email_verification.jsp";
		    break;

        default:
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        if (page != null) {
            request.getRequestDispatcher(page).forward(request, response);
        }
    }
}