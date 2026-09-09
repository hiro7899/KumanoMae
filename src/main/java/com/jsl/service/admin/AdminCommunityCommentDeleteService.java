package com.jsl.service.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.admin.AdminLogDao;
import com.jsl.dao.community.CommunityCommentDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.AdminActionException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class AdminCommunityCommentDeleteService implements Command {

    private final CommunityCommentDao communityCommentDao = new CommunityCommentDao();
    private final AdminLogDao adminLogDao = new AdminLogDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        LoginUserDto admin = AdminServiceSupport.getLoginAdmin(request);
        Long cCommentId = AdminServiceSupport.parseId(request, "cCommentId");

        try (Connection conn = DBManager.getConnection()) {
            try {
                conn.setAutoCommit(false);

                Long writerId = communityCommentDao.findWriterId(conn, cCommentId);
                if (writerId == null) throw new AdminActionException("存在しないコメントです。");

                Long cBoardId = communityCommentDao.findBoardId(conn, cCommentId);

                communityCommentDao.deleteComment(conn, cCommentId);
                adminLogDao.insertLog(conn, admin.getMemberId(), "COMMUNITY", cBoardId, "DELETE",
                        "コメント削除: cCommentId=" + cCommentId);

                conn.commit();
                request.setAttribute("redirectCBoardId", cBoardId);

            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException rollbackEx) { e.addSuppressed(rollbackEx); }
                throw new RuntimeException("コメント削除中にエラーが発生しました。", e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("データベースへの接続に失敗しました。", e);
        }
    }
}