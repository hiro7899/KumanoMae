package com.jsl.dao.community;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.jsl.dto.community.CommunityCommentDto;
import com.jsl.util.DBManager;

public class CommunityCommentDao {

    public List<CommunityCommentDto> selectByBoardId(Long cBoardId) {
        String sql = """
            SELECT C_COMMENT_ID, C_BOARD_ID, MEMBER_ID, CONTENT, REG_DATE
              FROM COMMUNITY_COMMENT
             WHERE C_BOARD_ID = ?
             ORDER BY REG_DATE ASC
            """;
        List<CommunityCommentDto> list = new ArrayList<>();
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, cBoardId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CommunityCommentDto dto = new CommunityCommentDto();
                    dto.setCCommentId(rs.getLong("C_COMMENT_ID"));
                    dto.setCBoardId(rs.getLong("C_BOARD_ID"));
                    dto.setMemberId(rs.getLong("MEMBER_ID"));
                    dto.setContent(rs.getString("CONTENT"));
                    if (rs.getTimestamp("REG_DATE") != null) {
                        dto.setRegDate(rs.getTimestamp("REG_DATE").toLocalDateTime());
                    }
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int insertComment(Connection conn, CommunityCommentDto dto) throws SQLException {
        String sql = """
            INSERT INTO COMMUNITY_COMMENT (C_COMMENT_ID, C_BOARD_ID, MEMBER_ID, CONTENT)
            VALUES (C_COMMENT_ID_SEQ.NEXTVAL, ?, ?, ?)
            """;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, dto.getCBoardId());
            pstmt.setLong(2, dto.getMemberId());
            pstmt.setString(3, dto.getContent());
            return pstmt.executeUpdate();
        }
    }

    public Long findWriterId(Connection conn, Long cCommentId) throws SQLException {
        String sql = "SELECT MEMBER_ID FROM COMMUNITY_COMMENT WHERE C_COMMENT_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, cCommentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getLong("MEMBER_ID") : null;
            }
        }
    }

    public Long findBoardId(Connection conn, Long cCommentId) throws SQLException {
        String sql = "SELECT C_BOARD_ID FROM COMMUNITY_COMMENT WHERE C_COMMENT_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, cCommentId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getLong("C_BOARD_ID") : null;
            }
        }
    }

    /** 물리 삭제 */
    public int deleteComment(Connection conn, Long cCommentId) throws SQLException {
        String sql = "DELETE FROM COMMUNITY_COMMENT WHERE C_COMMENT_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, cCommentId);
            return pstmt.executeUpdate();
        }
    }
}