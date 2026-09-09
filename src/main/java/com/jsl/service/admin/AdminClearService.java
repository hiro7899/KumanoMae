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

public class AdminClearService implements Command {

    private final BoardDao boardDao = new BoardDao();
    private final AdminLogDao adminLogDao = new AdminLogDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        Long adminId = getAdminId(request);
        Long boardId = parseBoardId(request);
        String clearMemo = request.getParameter("clearMemo"); // 예: "捕獲完了"

        if (clearMemo == null || clearMemo.trim().isEmpty()) {
            throw new AdminActionException("解除理由は必須です。");
        }

        try (Connection conn = DBManager.getConnection()) {
            try {
                conn.setAutoCommit(false);

                String currentStatus = boardDao.findStatus(conn, boardId);
                if (currentStatus == null) {
                    throw new AdminActionException("存在しない通報です。");
                }
                if (!"Y".equals(currentStatus)) {
                    throw new AdminActionException("承認済みの通報のみ危険解除できます。");
                }

                boardDao.updateClear(conn, boardId, clearMemo);
                adminLogDao.insertLog(conn, adminId, "BOARD", boardId, "CLEAR", clearMemo);

                conn.commit();

            } catch (SQLException e) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    e.addSuppressed(rollbackEx);
                }
                throw new RuntimeException("危険解除処理中にエラーが発生しました。", e);
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