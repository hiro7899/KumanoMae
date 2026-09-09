package com.jsl.service.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.admin.AdminLogDao;
import com.jsl.dao.member.MemberDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.AdminActionException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class AdminDeleteMemberService implements Command {

    private final MemberDao memberDao = new MemberDao();
    private final AdminLogDao adminLogDao = new AdminLogDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        LoginUserDto admin = getLoginAdmin(request);
        Long targetMemberId = parseMemberId(request);

        if (targetMemberId.equals(admin.getMemberId())) {
            throw new AdminActionException("自分自身は削除できません。");
        }

        try (Connection conn = DBManager.getConnection()) {
            try {
                conn.setAutoCommit(false);

                String currentStatus = memberDao.findStatus(conn, targetMemberId);
                if (currentStatus == null) {
                    throw new AdminActionException("存在しない会員です。");
                }
                if ("N".equals(currentStatus)) {
                    throw new AdminActionException("既に退会処理された会員です。");
                }

                memberDao.updateStatus(conn, targetMemberId, "N");
                adminLogDao.insertLog(conn, admin.getMemberId(), "MEMBER", targetMemberId, "DELETE", null);

                conn.commit();

            } catch (SQLException e) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    e.addSuppressed(rollbackEx);
                }
                throw new RuntimeException("会員削除処理中にエラーが発生しました。", e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("データベースへの接続に失敗しました。", e);
        }
    }

    private LoginUserDto getLoginAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        LoginUserDto admin = (session != null) ? (LoginUserDto) session.getAttribute("user") : null;
        if (admin == null) {
            throw new AdminActionException("ログインが必要です。");
        }
        return admin;
    }

    private Long parseMemberId(HttpServletRequest request) {
        String value = request.getParameter("memberId");
        if (value == null || value.trim().isEmpty()) {
            throw new AdminActionException("memberIdは必須です。");
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            throw new AdminActionException("memberIdの形式が正しくありません。");
        }
    }
}