package com.jsl.controller.board;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.service.board.BoardListService;

@WebServlet("/board/*")
public class BoardController extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	private final BoardListService boardListService = new BoardListService();
	
    public BoardController() {
        super();
    }

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
		String action = request.getPathInfo();
		String page = null;

		switch (action) {
		case "/list":
			boardListService.doCommand(request, response);
			page = "/WEB-INF/views/board/list.jsp";

			break;
		case "/detail":
			page = "/WEB-INF/views/board/detail.jsp";
			break;
			
		case "/report":
			page = "/WEB-INF/views/board/report.jsp";
			break;
			
		case "/news":
			page = "/WEB-INF/views/board/news.jsp";
			break;
		
		default:
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		request.getRequestDispatcher(page).forward(request, response);
	}

}
