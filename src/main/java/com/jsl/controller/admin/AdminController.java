package com.jsl.controller.admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.AdminActionException;
import com.jsl.service.admin.AdminApproveService;
import com.jsl.service.admin.AdminClearService;
import com.jsl.service.admin.AdminDeleteMemberService;
import com.jsl.service.admin.AdminMemberListService;
import com.jsl.service.admin.AdminRejectService;
import com.jsl.service.admin.AdminUpdateGradeService;

@WebServlet("/admin/*")
public class AdminController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final AdminApproveService adminApproveService = new AdminApproveService();
    private final AdminRejectService adminRejectService = new AdminRejectService();
    private final AdminClearService adminClearService = new AdminClearService();
    private final AdminMemberListService adminMemberListService = new AdminMemberListService();
    private final AdminUpdateGradeService adminUpdateGradeService = new AdminUpdateGradeService();
    private final AdminDeleteMemberService adminDeleteMemberService = new AdminDeleteMemberService();

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

        LoginUserDto user = (LoginUserDto) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("/login");
            return;
        }
        if (!"A".equals(user.getUserGrade())) {
            response.sendRedirect("/");
            return;
        }

        String path = request.getPathInfo();
        if (path == null) {
            path = "/main";
        }
        String page = null;

        switch (path) {
            case "/main":
                page = "/WEB-INF/views/admin/main.jsp";
                break;

            case "/member/list":
                adminMemberListService.doCommand(request, response);
                page = "/WEB-INF/views/admin/member/list.jsp";
                break;

            case "/member/updateGrade":
                try {
                    adminUpdateGradeService.doCommand(request, response);
                    response.sendRedirect("/admin/member/list");
                    return;
                } catch (AdminActionException e) {
                    request.setAttribute("errorMsg", e.getMessage());
                    adminMemberListService.doCommand(request, response);
                    page = "/WEB-INF/views/admin/member/list.jsp";
                }
                break;

            case "/member/delete":
                try {
                    adminDeleteMemberService.doCommand(request, response);
                    response.sendRedirect("/admin/member/list");
                    return;
                } catch (AdminActionException e) {
                    request.setAttribute("errorMsg", e.getMessage());
                    adminMemberListService.doCommand(request, response);
                    page = "/WEB-INF/views/admin/member/list.jsp";
                }
                break;

            case "/board/list":
                page = "/WEB-INF/views/admin/board/list.jsp";
                break;

            case "/board/approve":
                try {
                    adminApproveService.doCommand(request, response);
                    response.sendRedirect("/admin/board/list");
                    return;
                } catch (AdminActionException e) {
                    request.setAttribute("errorMsg", e.getMessage());
                    page = "/WEB-INF/views/admin/board/list.jsp";
                }
                break;

            case "/board/reject":
                try {
                    adminRejectService.doCommand(request, response);
                    response.sendRedirect("/admin/board/list");
                    return;
                } catch (AdminActionException e) {
                    request.setAttribute("errorMsg", e.getMessage());
                    page = "/WEB-INF/views/admin/board/list.jsp";
                }
                break;

            case "/board/clear":
                try {
                    adminClearService.doCommand(request, response);
                    response.sendRedirect("/admin/board/list");
                    return;
                } catch (AdminActionException e) {
                    request.setAttribute("errorMsg", e.getMessage());
                    page = "/WEB-INF/views/admin/board/list.jsp";
                }
                break;

            case "/community/list":
                page = "/WEB-INF/views/admin/community/list.jsp";
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