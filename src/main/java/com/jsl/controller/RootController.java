package com.jsl.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.service.login.FindPasswordService;
import com.jsl.service.login.LoginService;
import com.jsl.service.login.LogoutService;
import com.jsl.service.login.SignUpService;

@WebServlet(urlPatterns = { "/", "/index", "/login", "/logout", "/signup", "/forgot-password", "/reset-password",
		"/board/List", "/board/Write", "/board/News"

})
public class RootController extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	private final LoginService loginService = new LoginService();
	private final LogoutService logoutService = new LogoutService();
	private final SignUpService signUpService = new SignUpService();
	private final FindPasswordService findPasswordService = new FindPasswordService();

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
				loginService.doCommand(request, response);

				HttpSession session = request.getSession(false);
				if (session != null && session.getAttribute("user") != null) {
					response.sendRedirect("/");
					return;
				}
				page = "/WEB-INF/views/auth/login.jsp";
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

		case "/find_pw":
			if ("GET".equalsIgnoreCase(request.getMethod())) {
				page = "/WEB-INF/views/auth/find_pw.jsp";
			} else {
				findPasswordService.doCommand(request, response);
				page = "/WEB-INF/views/auth/find_pw.jsp";
			}
			break;
		case "/board/List":
			page = "/WEB-INF/views/board/boardList.jsp";
			break;

		case "/board/Write":
			page = "/WEB-INF/views/board/boardWrite.jsp";
			break;
			
		case "/board/News":
			page = "/WEB-INF/views/board/boardNews.jsp";
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