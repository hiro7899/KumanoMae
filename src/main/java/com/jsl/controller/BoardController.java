package com.jsl.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.exeption.BoardReportException;
import com.jsl.exeption.EmailNotVerifiedException;
import com.jsl.service.board.BoardListService;
import com.jsl.service.board.BoardReportService;
import com.jsl.service.member.EmailVerificationGuardService;

@WebServlet("/board/*")
@MultipartConfig(
        maxFileSize = 5 * 1024 * 1024,       // 파일 1개당 5MB
        maxRequestSize = 20 * 1024 * 1024,   // 요청 전체 최대 20MB
        fileSizeThreshold = 1024 * 1024
)
public class BoardController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final BoardListService boardListService = new BoardListService();
    private final BoardReportService boardReportService = new BoardReportService();
    private final EmailVerificationGuardService emailVerificationGuardService = new EmailVerificationGuardService();

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

        String path = request.getPathInfo();
        if (path == null) {
        	path = "/list";
        }

        String page = null;

        switch (path) {
        case "/list":
            boardListService.doCommand(request, response);
            page = "/WEB-INF/views/board/list.jsp";
            break;

        case "/detail":
            page = "/WEB-INF/views/board/detail.jsp";
            break;

        case "/report":
        	try {
                emailVerificationGuardService.checkVerified(request);
            } catch (EmailNotVerifiedException e) {
                response.sendRedirect("LOGIN_REQUIRED".equals(e.getCode()) ? "/login" : "/user/email-verification");
                return;
            }

            if ("GET".equalsIgnoreCase(request.getMethod())) {
                page = "/WEB-INF/views/board/write.jsp";
            } else {
                try {
                    boardReportService.doCommand(request, response);
                    response.sendRedirect(request.getContextPath() + "/board/list");
                    return;

                } catch (BoardReportException e) {
                    request.setAttribute("errorMsg", e.getMessage());
                    page = "/WEB-INF/views/board/report.jsp";

                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("errorMsg"
                    		, "通報の登録中にエラーが発生しました。しばらくしてからもう一度お試しください。");
                    
                    page = "/WEB-INF/views/board/report.jsp";
                }
            }
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