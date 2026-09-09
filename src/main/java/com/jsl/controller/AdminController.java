package com.jsl.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.AdminActionException;
import com.jsl.service.admin.*;

@WebServlet("/admin/*")
public class AdminController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AdminMainService adminMainService = new AdminMainService();

    // Board
    private final AdminBoardListService adminBoardListService = new AdminBoardListService();
    private final AdminApproveService adminApproveService = new AdminApproveService();
    private final AdminRejectService adminRejectService = new AdminRejectService();
    private final AdminClearService adminClearService = new AdminClearService();

    // Member
    private final AdminMemberListService adminMemberListService = new AdminMemberListService();
    private final AdminUpdateGradeService adminUpdateGradeService = new AdminUpdateGradeService();
    private final AdminDeleteMemberService adminDeleteMemberService = new AdminDeleteMemberService();

    // Community
    private final AdminCommunityListService adminCommunityListService = new AdminCommunityListService();
    private final AdminCommunityDetailService adminCommunityDetailService = new AdminCommunityDetailService();
    private final AdminCommunityHideService adminCommunityHideService = new AdminCommunityHideService();
    private final AdminCommunityShowService adminCommunityShowService = new AdminCommunityShowService();
    private final AdminCommunityDeleteService adminCommunityDeleteService = new AdminCommunityDeleteService();
    private final AdminCommunityCommentDeleteService adminCommunityCommentDeleteService =
            new AdminCommunityCommentDeleteService();

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

        // 로그인 여부 확인
        LoginUserDto user = (LoginUserDto) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("/login");
            return;
        }

        // 관리자 권한 확인
        if (!"A".equals(user.getUserGrade())) {
            response.sendRedirect("/");
            return;
        }

        String path = request.getPathInfo();

        if (path == null) {
            path = "/main";
        }

        String page = null;

        try {

            switch (path) {

                /* =========================
                 * Admin Main
                 * ========================= */
                case "/main":
                    adminMainService.doCommand(request, response);
                    page = "/WEB-INF/views/admin/main.jsp";
                    break;


                /* =========================
                 * Member
                 * ========================= */
                case "/member/list":
                    adminMemberListService.doCommand(request, response);
                    page = "/WEB-INF/views/admin/member/list.jsp";
                    break;

                case "/member/updateGrade":
                    adminUpdateGradeService.doCommand(request, response);
                    response.sendRedirect("/admin/member/list");
                    return;

                case "/member/delete":
                    adminDeleteMemberService.doCommand(request, response);
                    response.sendRedirect("/admin/member/list");
                    return;


                /* =========================
                 * Board
                 * ========================= */
                case "/board/list":
                    adminBoardListService.doCommand(request, response);
                    page = "/WEB-INF/views/admin/board/list.jsp";
                    break;

                case "/board/approve":
                    adminApproveService.doCommand(request, response);
                    response.sendRedirect("/admin/board/list");
                    return;

                case "/board/reject":
                    adminRejectService.doCommand(request, response);
                    response.sendRedirect("/admin/board/list");
                    return;

                case "/board/clear":
                    adminClearService.doCommand(request, response);
                    response.sendRedirect("/admin/board/list");
                    return;


                /* =========================
                 * Community
                 * ========================= */
                case "/community/list":
                    adminCommunityListService.doCommand(request, response);
                    page = "/WEB-INF/views/admin/community/list.jsp";
                    break;

                case "/community/detail":
                    adminCommunityDetailService.doCommand(request, response);
                    page = "/WEB-INF/views/admin/community/detail.jsp";
                    break;

                case "/community/hide":
                    adminCommunityHideService.doCommand(request, response);
                    response.sendRedirect("/admin/community/list");
                    return;

                case "/community/show":
                    adminCommunityShowService.doCommand(request, response);
                    response.sendRedirect("/admin/community/list");
                    return;

                case "/community/delete":
                    adminCommunityDeleteService.doCommand(request, response);
                    response.sendRedirect("/admin/community/list");
                    return;

                case "/community/comment/delete":

                    adminCommunityCommentDeleteService.doCommand(request, response);

                    Long redirectId =
                            (Long) request.getAttribute("redirectCBoardId");

                    if (redirectId != null) {
                        response.sendRedirect(
                                "/admin/community/detail?cBoardId=" + redirectId
                        );
                    } else {
                        response.sendRedirect("/admin/community/list");
                    }

                    return;


                /* =========================
                 * 404
                 * ========================= */
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
            }

        } catch (AdminActionException e) {

            request.setAttribute("errorMsg", e.getMessage());

            if (path.startsWith("/community")) {
                adminCommunityListService.doCommand(request, response);
                page = "/WEB-INF/views/admin/community/list.jsp";

            } else if (path.startsWith("/board")) {

                adminBoardListService.doCommand(request, response);
                page = "/WEB-INF/views/admin/board/list.jsp";

            } else if (path.startsWith("/member")) {

                adminMemberListService.doCommand(request, response);
                page = "/WEB-INF/views/admin/member/list.jsp";

            } else {

                page = "/WEB-INF/views/admin/main.jsp";
            }
        }

        if (page != null) {
            request.getRequestDispatcher(page).forward(request, response);
        }
    }
}
