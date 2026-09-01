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

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doAction(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doAction(request, response);
	}

	protected void doAction(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// exact-match 패턴이므로 getServletPath()가 "/login", "/logout" 등을 그대로 반환
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
				new LoginService().doCommand(request, response);

				HttpSession session = request.getSession(false);
				if (session != null && session.getAttribute("userId") != null) {
					response.sendRedirect(request.getContextPath() + "/");
					return;
				}
				// 로그인 실패 시 errorMsg를 request에 담아 폼 재출력
				page = "/WEB-INF/views/auth/login.jsp";
			}
			break;

		case "/logout":
			new LogoutService().doCommand(request, response);
			response.sendRedirect(request.getContextPath() + "/");
			return;

		case "/signup":
			if ("GET".equalsIgnoreCase(request.getMethod())) {
				page = "/WEB-INF/views/auth/signup.jsp";
			} else {
				new SignUpService().doCommand(request, response);
				response.sendRedirect(request.getContextPath() + "/login");
				return;
			}
			break;

		case "/find_pw":
			if ("GET".equalsIgnoreCase(request.getMethod())) {
				page = "/WEB-INF/views/auth/find_pw.jsp";
			} else {
				new FindPasswordService().doCommand(request, response);
				page = "/WEB-INF/views/auth/find_pw.jsp"; // 처리 결과 메시지와 함께 재출력
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
//                response.sendRedirect(request.getContextPath() + "/login");
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