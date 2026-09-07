package com.jsl.service.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.admin.AdminLogDao;
import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.AdminActionException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class AdminCommunityHideService implements Command {
    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final AdminLogDao adminLogDao = new AdminLogDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        LoginUserDto admin = AdminServiceSupport.getLoginAdmin(request);
        Long cBoardId = AdminServiceSupport.parseId(request, "cBoardId");

        try (Connection conn = DBManager.getConnection()) {
            try {
                conn.setAutoCommit(false);

                String current = communityBoardDao.findStatus(conn, cBoardId);
                if (current == null) throw new AdminActionException("存在しない投稿です。");
                if ("N".equals(current)) throw new AdminActionException("既に非表示の投稿です。");

                communityBoardDao.updateStatus(conn, cBoardId, "N");
                adminLogDao.insertLog(conn, admin.getMemberId(), "COMMUNITY", cBoardId, "HIDE", null);

                conn.commit();

            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException rollbackEx) { e.addSuppressed(rollbackEx); }
                throw new RuntimeException("非表示処理中にエラーが発生しました。", e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("データベースへの接続に失敗しました。", e);
        }
    }
}