package com.jsl.controller.community;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,       // 파일 1개당 5MB
        maxRequestSize = 20 * 1024 * 1024,   // 요청 전체 최대 20MB
        fileSizeThreshold = 1024 * 1024
)
@WebServlet("/community/*")
public class CommunityController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    public CommunityController() {
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

        String path = request.getPathInfo();
        if (path == null) {
        	path = "/list";
        }

        String page = null;

        switch (path) {
        case "/list":
            page = "/WEB-INF/views/community/list.jsp";
            break;

        case "/detail":
            page = "/WEB-INF/views/community/detail.jsp";
            break;


        case "/write":
            page = "/WEB-INF/views/community/write.jsp";
            break;
            
        case "/update":
			page = "/WEB-INF/views/community/update.jsp";
			break;
		
        case "/delete":
        	page = "/WEB-INF/views/community/delete.jsp";
			break;

        case "/comment/add":
			break;
		
        case "/comment/update":
			break;
		
        case "/comment/delete":
        	break;
        	
        case "/like/toggle":
        	break;
			
        default:
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.getRequestDispatcher(page).forward(request, response);
    }
}
