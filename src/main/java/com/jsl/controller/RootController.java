package com.jsl.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.exeption.LoginException;
import com.jsl.service.login.ForgotPasswordService;
import com.jsl.service.login.LoginService;
import com.jsl.service.login.LogoutService;
import com.jsl.service.login.SignUpService;
import com.jsl.service.login.findIdService;

@WebServlet(urlPatterns = {
        "/", "/index",
        "/login", "/logout", "/signup",
        "/forgot-password", "/reset-password",
        "/verify-email"   // ★ 추가
})
public class RootController extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private final LoginService loginService = new LoginService();
	private final LogoutService logoutService = new LogoutService();
	private final SignUpService signUpService = new SignUpService();
	private final ForgotPasswordService forgotPasswordService = new ForgotPasswordService();

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doAction(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doAction(request, response);
	}

	private void doAction(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getServletPath();
		String page = null;

		switch (action) {

		case "/":
		case "/index":
			page = "/index.jsp";
			break;

		case "/login":
		    if ("GET".equalsIgnoreCase(request.getMethod())) {
		        page = "/WEB-INF/views/auth/login.jsp";
		    } else {
		        try {
		            loginService.doCommand(request, response);
		            response.sendRedirect(request.getContextPath() + "/");
		            return;

		        } catch (LoginException e) {
		            request.setAttribute("errorMsg", e.getMessage());
		            page = "/WEB-INF/views/auth/login.jsp";
		        }
		    }
		    break;
		    
		case "/logout":
			logoutService.doCommand(request, response);
			response.sendRedirect("/");
			return;

		case "/signup":
			if ("GET".equalsIgnoreCase(request.getMethod())) {
				page = "/WEB-INF/views/auth/signup.jsp";
			} else {
				signUpService.doCommand(request, response);
				response.sendRedirect("/login");
				return;
			}
			break;
			
		case "/find_id":
			if ("GET".equalsIgnoreCase(request.getMethod())) {
				page = "/WEB-INF/views/auth/find_id.jsp";
			} else {
				findIdService.doCommand(request, response);
				page = "/WEB-INF/views/auth/find_id.jsp";
			}
			break;
			
		case "/find_pw":
			if ("GET".equalsIgnoreCase(request.getMethod())) {
				page = "/WEB-INF/views/auth/find_pw.jsp";
			} else {
				forgotPasswordService.doCommand(request, response);
				page = "/WEB-INF/views/auth/find_pw.jsp";
			}
			break;
//        case "/reset_pw":
//            if ("GET".equalsIgnoreCase(request.getMethod())) {
//                page = "/WEB-INF/views/auth/reset_pw.jsp";
//            } else {
//                new ResetPasswordService().doCommand(request, response);
//                response.sendRedirect("/login");
//                return;
//            }
//            break;

		default:
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		if (page != null) {
			request.getRequestDispatcher(page).forward(request, response);
		}
	}
}