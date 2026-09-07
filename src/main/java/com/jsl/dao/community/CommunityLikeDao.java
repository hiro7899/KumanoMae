package com.jsl.dao.community;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CommunityLikeDao {

    public boolean exists(Connection conn, Long cBoardId, Long memberId) throws SQLException {
        String sql = "SELECT 1 FROM COMMUNITY_LIKE WHERE C_BOARD_ID = ? AND MEMBER_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, cBoardId);
            pstmt.setLong(2, memberId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int insertLike(Connection conn, Long cBoardId, Long memberId) throws SQLException {
        String sql = "INSERT INTO COMMUNITY_LIKE (C_LIKE_ID, C_BOARD_ID, MEMBER_ID) VALUES (C_LIKE_ID_SEQ.NEXTVAL, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, cBoardId);
            pstmt.setLong(2, memberId);
            return pstmt.executeUpdate();
        }
    }

    public int deleteLike(Connection conn, Long cBoardId, Long memberId) throws SQLException {
        String sql = "DELETE FROM COMMUNITY_LIKE WHERE C_BOARD_ID = ? AND MEMBER_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, cBoardId);
            pstmt.setLong(2, memberId);
            return pstmt.executeUpdate();
        }
    }
}