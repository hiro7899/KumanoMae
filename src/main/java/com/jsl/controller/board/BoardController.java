package com.jsl.controller.board;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
			page = "/WEB-INF/views/board/list.jsp";
			break;
		case "/view":
			page = "/WEB-INF/views/board/view.jsp";
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
