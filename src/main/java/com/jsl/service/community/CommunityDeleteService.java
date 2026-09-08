package com.jsl.service.community;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.admin.AdminLogDao;
import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.CommunityException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class CommunityDeleteService implements Command {

    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final AdminLogDao adminLogDao = new AdminLogDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            throw new CommunityException("ログインが必要です。");
        }
        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("user");

        Long cBoardId = parseId(request);
        Long writerId = communityBoardDao.findWriterId(cBoardId);
        if (writerId == null) {
            throw new CommunityException("存在しない投稿です。");
        }

        boolean isOwner = writerId.equals(loginUser.getMemberId());
        boolean isAdmin = "A".equals(loginUser.getUserGrade());
        if (!isOwner && !isAdmin) {
            throw new CommunityException("削除権限がありません。");
        }

        try (Connection conn = DBManager.getConnection()) {
            try {
                conn.setAutoCommit(false);

                communityBoardDao.updateStatus(conn, cBoardId, "N");

                // 관리자가 "타인의 글"을 삭제한 경우에만 조치 이력 기록 (모더레이션 행위)
                if (isAdmin && !isOwner) {
                    adminLogDao.insertLog(conn, loginUser.getMemberId(), "COMMUNITY", cBoardId, "DELETE", null);
                }

                conn.commit();

            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException rollbackEx) { e.addSuppressed(rollbackEx); }
                throw new RuntimeException("投稿削除処理中にエラーが発生しました。", e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("データベースへの接続に失敗しました。", e);
        }
    }

    private Long parseId(HttpServletRequest request) {
        String value = request.getParameter("cBoardId");
        if (value == null || value.trim().isEmpty()) {
            throw new CommunityException("cBoardIdは必須です。");
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            throw new CommunityException("cBoardIdの形式が正しくありません。");
        }
    }
}