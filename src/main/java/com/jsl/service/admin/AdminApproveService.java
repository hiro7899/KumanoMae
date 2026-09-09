package com.jsl.service.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.admin.AdminLogDao;
import com.jsl.dao.board.BoardDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.AdminActionException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class AdminApproveService implements Command {

    private final BoardDao boardDao = new BoardDao();
    private final AdminLogDao adminLogDao = new AdminLogDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        Long adminId = getAdminId(request);
        Long boardId = parseBoardId(request);

        try (Connection conn = DBManager.getConnection()) {
            try {
                conn.setAutoCommit(false);

                String currentStatus = boardDao.findStatus(conn, boardId);
                if (currentStatus == null) {
                    throw new AdminActionException("存在しない通報です。");
                }
                if (!"W".equals(currentStatus)) {
                    throw new AdminActionException("承認待ち状態の通報のみ承認できます。");
                }

                boardDao.updateStatus(conn, boardId, "Y");
                adminLogDao.insertLog(conn, adminId, "BOARD", boardId, "APPROVE", null);

                conn.commit();

            } catch (SQLException e) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    e.addSuppressed(rollbackEx);
                }
                throw new RuntimeException("承認処理中にエラーが発生しました。", e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("データベースへの接続に失敗しました。", e);
        }
    }

    private Long getAdminId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        LoginUserDto admin = (session != null) ? (LoginUserDto) session.getAttribute("user") : null;
        if (admin == null) {
            throw new AdminActionException("ログインが必要です。");
        }
        return admin.getMemberId();
    }

    private Long parseBoardId(HttpServletRequest request) {
        String value = request.getParameter("boardId");
        if (value == null || value.trim().isEmpty()) {
            throw new AdminActionException("boardIdは必須です。");
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            throw new AdminActionException("boardIdの形式が正しくありません。");
        }
    }
}