package com.jsl.service.community;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.community.CommunityCommentDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.CommunityException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class CommunityCommentDeleteService implements Command {

    private final CommunityCommentDao communityCommentDao = new CommunityCommentDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            throw new CommunityException("ログインが必要です。");
        }
        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("user");

        Long cCommentId = parseId(request);

        try (Connection conn = DBManager.getConnection()) {
            Long writerId = communityCommentDao.findWriterId(conn, cCommentId);
            if (writerId == null) {
                throw new CommunityException("存在しないコメントです。");
            }

            boolean isOwner = writerId.equals(loginUser.getMemberId());
            boolean isAdmin = "A".equals(loginUser.getUserGrade());
            if (!isOwner && !isAdmin) {
                throw new CommunityException("削除権限がありません。");
            }

            // 리다이렉트용 cBoardId를 미리 확보해서 request에 담아둠 (Controller가 사용)
            Long cBoardId = communityCommentDao.findBoardId(conn, cCommentId);
            request.setAttribute("redirectCBoardId", cBoardId);

            communityCommentDao.deleteComment(conn, cCommentId);

        } catch (SQLException e) {
            throw new RuntimeException("コメント削除中にエラーが発生しました。", e);
        }
    }

    private Long parseId(HttpServletRequest request) {
        String value = request.getParameter("cCommentId");
        if (value == null || value.trim().isEmpty()) {
            throw new CommunityException("cCommentIdは必須です。");
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            throw new CommunityException("cCommentIdの形式が正しくありません。");
        }
    }
}