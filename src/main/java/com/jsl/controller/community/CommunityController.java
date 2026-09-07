package com.jsl.controller.community;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.exeption.CommunityException;
import com.jsl.service.community.CommunityCommentAddService;
import com.jsl.service.community.CommunityCommentDeleteService;
import com.jsl.service.community.CommunityDeleteService;
import com.jsl.service.community.CommunityDetailService;
import com.jsl.service.community.CommunityListService;
import com.jsl.service.community.CommunityUpdateFormService;
import com.jsl.service.community.CommunityUpdateService;
import com.jsl.service.community.CommunityWriteService;

@WebServlet("/community/*")
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,
        maxRequestSize = 30 * 1024 * 1024, // 최대 5장이라 BOARD(20MB)보다 여유 있게
        fileSizeThreshold = 1024 * 1024
)
public class CommunityController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final CommunityListService communityListService = new CommunityListService();
    private final CommunityDetailService communityDetailService = new CommunityDetailService();
    private final CommunityWriteService communityWriteService = new CommunityWriteService();
    private final CommunityUpdateFormService communityUpdateFormService = new CommunityUpdateFormService();
    private final CommunityUpdateService communityUpdateService = new CommunityUpdateService();
    private final CommunityDeleteService communityDeleteService = new CommunityDeleteService();
    private final CommunityCommentAddService communityCommentAddService = new CommunityCommentAddService();
    private final CommunityCommentDeleteService communityCommentDeleteService = new CommunityCommentDeleteService();

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

        String action = request.getPathInfo();
        if (action == null) {
            action = "/list";
        }

        String page = null;

        try {
            switch (action) {

            case "/list":
                communityListService.doCommand(request, response);
                page = "/WEB-INF/views/community/list.jsp";
                break;

            case "/detail":
            	communityDetailService.doCommand(request, response);
                page = "/WEB-INF/views/community/detail.jsp";
                break;

            case "/write":
                if (request.getSession(false) == null || request.getSession(false).getAttribute("user") == null) {
                    response.sendRedirect("/login");
                    return;
                }
                if ("GET".equalsIgnoreCase(request.getMethod())) {
                    page = "/WEB-INF/views/community/write.jsp";
                } else {
                    communityWriteService.doCommand(request, response);
                    response.sendRedirect("/community/list");
                    return;
                }
                break;

            case "/update":
                if ("GET".equalsIgnoreCase(request.getMethod())) {
                    communityUpdateFormService.doCommand(request, response);
                    page = "/WEB-INF/views/community/update.jsp";
                } else {
                    communityUpdateService.doCommand(request, response);
                    response.sendRedirect("/community/view?cBoardId=" + request.getParameter("cBoardId"));
                    return;
                }
                break;

            case "/delete":
                communityDeleteService.doCommand(request, response);
                response.sendRedirect("/community/list");
                return;

            case "/comment/add":
                communityCommentAddService.doCommand(request, response);
                response.sendRedirect("/community/view?cBoardId=" + request.getParameter("cBoardId"));
                return;

            case "/comment/delete":
                communityCommentDeleteService.doCommand(request, response);
                Long redirectId = (Long) request.getAttribute("redirectCBoardId");
                response.sendRedirect("/community/view?cBoardId=" + redirectId);
                return;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

        } catch (CommunityException e) {
            request.setAttribute("errorMsg", e.getMessage());
            // 에러 시 되돌아갈 화면 - 상황별로 목록/상세 중 더 적절한 쪽으로
            page = (action.equals("/write") || action.equals("/update"))
                    ? "/WEB-INF/views/community/" + action.substring(1) + ".jsp"
                    : "/WEB-INF/views/community/list.jsp";
        }

        if (page != null) {
            request.getRequestDispatcher(page).forward(request, response);
        }
    }
}