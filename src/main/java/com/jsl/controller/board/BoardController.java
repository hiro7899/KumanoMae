package com.jsl.controller.board;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/board/*")
public class BoardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public BoardController() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doAction(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doAction(request, response);
	}
	
	private void doAction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getPathInfo();
		String page = null;

		switch (action) {
		case "/list":
			if ("GET".equalsIgnoreCase(request.getMethod())) {
				page = "/WEB-INF/views/board/list.jsp";
			} else {
//				selectBoardAllService.doCommand(request, response);

				HttpSession session = request.getSession(false);
				if (session != null && session.getAttribute("user") != null) {
					response.sendRedirect("/");
					return;
				}
				page = "/WEB-INF/views/auth/login.jsp";
			}
			break;
		case "/detail":
			page = "/WEB-INF/views/board/detail.jsp";
			break;
		case "/write":
			page = "/WEB-INF/views/board/write.jsp";
			break;
		default:
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		request.getRequestDispatcher(page).forward(request, response);
	}

}
