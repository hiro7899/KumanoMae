package com.jsl.service.community;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.dao.community.CommunityLikeDao;
import com.jsl.dto.api.CommunityLikeRequest;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.CommunityException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;
import com.jsl.util.JsonRequestUtil;
import com.jsl.util.JsonResponseUtil;

public class CommunityLikeToggleService implements Command {

    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final CommunityLikeDao communityLikeDao = new CommunityLikeDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            JsonResponseUtil.writeError(response, 401, "ログインが必要です。");
            return;
        }
        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("user");

        CommunityLikeRequest body = JsonRequestUtil.parseBody(request, CommunityLikeRequest.class);
        Long cBoardId = body.getCBoardId();
        if (cBoardId == null) {
            JsonResponseUtil.writeError(response, 400, "cBoardIdは必須です。");
            return;
        }

        try (Connection conn = DBManager.getConnection()) {
            try {
                conn.setAutoCommit(false);

                String status = communityBoardDao.findStatus(conn, cBoardId);
                if (!"Y".equals(status)) {
                    throw new CommunityException("削除された投稿にはいいねできません。");
                }

                boolean exists = communityLikeDao.exists(conn, cBoardId, loginUser.getMemberId());
                boolean nowLiked;

                if (exists) {
                    communityLikeDao.deleteLike(conn, cBoardId, loginUser.getMemberId());
                    communityBoardDao.updateLikeCnt(conn, cBoardId, -1);
                    nowLiked = false;
                } else {
                    communityLikeDao.insertLike(conn, cBoardId, loginUser.getMemberId());
                    communityBoardDao.updateLikeCnt(conn, cBoardId, 1);
                    nowLiked = true;
                }

                int likeCnt = selectLikeCnt(conn, cBoardId);
                conn.commit();

                JsonResponseUtil.writeLikeResult(response, nowLiked, likeCnt);

            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException rollbackEx) { e.addSuppressed(rollbackEx); }
                throw new RuntimeException("いいね処理中にエラーが発生しました。", e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("データベースへの接続に失敗しました。", e);
        }
    }

    private int selectLikeCnt(Connection conn, Long cBoardId) throws SQLException {
        String sql = "SELECT LIKE_CNT FROM COMMUNITY_BOARD WHERE C_BOARD_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, cBoardId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt("LIKE_CNT") : 0;
            }
        }
    }
}