package com.jsl.dao.community;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.jsl.dto.community.CommunityBoardDto;
import com.jsl.util.DBManager;

public class CommunityBoardDao {

    public List<CommunityBoardDto> selectList(String category) {
        StringBuilder sql = new StringBuilder("""
            SELECT C_BOARD_ID, MEMBER_ID, CATEGORY, TITLE, GEAR_NAME, VIEW_CNT, LIKE_CNT, REG_DATE
              FROM COMMUNITY_BOARD
             WHERE STATUS = 'Y'
            """);
        if (category != null && !category.isEmpty()) {
            sql.append(" AND CATEGORY = ?");
        }
        sql.append(" ORDER BY REG_DATE DESC");

        List<CommunityBoardDto> list = new ArrayList<CommunityBoardDto>();

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            if (category != null && !category.isEmpty()) {
                pstmt.setString(1, category);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CommunityBoardDto dto = new CommunityBoardDto();
                    dto.setCBoardId(rs.getLong("C_BOARD_ID"));
                    dto.setMemberId(rs.getLong("MEMBER_ID"));
                    dto.setCategory(rs.getString("CATEGORY"));
                    dto.setTitle(rs.getString("TITLE"));
                    dto.setGearName(rs.getString("GEAR_NAME"));
                    dto.setViewCnt(rs.getInt("VIEW_CNT"));
                    dto.setLikeCnt(rs.getInt("LIKE_CNT"));
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

    public CommunityBoardDto selectById(Long cBoardId) {
        String sql = """
            SELECT C_BOARD_ID, MEMBER_ID, CATEGORY, TITLE, CONTENT, GEAR_NAME,
                   VIEW_CNT, LIKE_CNT, STATUS, REG_DATE, MOD_DATE
              FROM COMMUNITY_BOARD
             WHERE C_BOARD_ID = ? AND STATUS = 'Y'
            """;

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setLong(1, cBoardId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next()) return null;

                CommunityBoardDto dto = new CommunityBoardDto();
                dto.setCBoardId(rs.getLong("C_BOARD_ID"));
                dto.setMemberId(rs.getLong("MEMBER_ID"));
                dto.setCategory(rs.getString("CATEGORY"));
                dto.setTitle(rs.getString("TITLE"));
                dto.setContent(rs.getString("CONTENT"));
                dto.setGearName(rs.getString("GEAR_NAME"));
                dto.setViewCnt(rs.getInt("VIEW_CNT"));
                dto.setLikeCnt(rs.getInt("LIKE_CNT"));
                dto.setStatus(rs.getString("STATUS"));
                if (rs.getTimestamp("REG_DATE") != null) {
                    dto.setRegDate(rs.getTimestamp("REG_DATE").toLocalDateTime());
                }
                if (rs.getTimestamp("MOD_DATE") != null) {
                    dto.setModDate(rs.getTimestamp("MOD_DATE").toLocalDateTime());
                }
                return dto;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Long insertBoard(Connection conn, CommunityBoardDto dto) throws SQLException {
        String sql = """
            INSERT INTO COMMUNITY_BOARD (C_BOARD_ID, MEMBER_ID, CATEGORY, TITLE, CONTENT, GEAR_NAME)
            VALUES (C_BOARD_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?)
            """;
        try (PreparedStatement pstmt = conn.prepareStatement(sql, new String[] { "C_BOARD_ID" })) {
            pstmt.setLong(1, dto.getMemberId());
            pstmt.setString(2, dto.getCategory());
            pstmt.setString(3, dto.getTitle());
            pstmt.setString(4, dto.getContent());
            pstmt.setString(5, dto.getGearName());
            pstmt.executeUpdate();

            try (ResultSet keys = pstmt.getGeneratedKeys()) {
                if (keys.next()) return keys.getLong(1);
            }
            throw new SQLException("C_BOARD_ID 채번에 실패했습니다.");
        }
    }

    public int updateBoard(Connection conn, CommunityBoardDto dto) throws SQLException {
        String sql = """
            UPDATE COMMUNITY_BOARD
               SET CATEGORY = ?, TITLE = ?, CONTENT = ?, GEAR_NAME = ?, MOD_DATE = SYSDATE
             WHERE C_BOARD_ID = ?
            """;
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, dto.getCategory());
            pstmt.setString(2, dto.getTitle());
            pstmt.setString(3, dto.getContent());
            pstmt.setString(4, dto.getGearName());
            pstmt.setLong(5, dto.getCBoardId());
            return pstmt.executeUpdate();
        }
    }

    /** 소프트 삭제 - 파일은 지우지 않음 */
    public int updateStatus(Connection conn, Long cBoardId, String status) throws SQLException {
        String sql = "UPDATE COMMUNITY_BOARD SET STATUS = ?, MOD_DATE = SYSDATE WHERE C_BOARD_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setLong(2, cBoardId);
            return pstmt.executeUpdate();
        }
    }

    public int increaseViewCnt(Long cBoardId) {
        String sql = "UPDATE COMMUNITY_BOARD SET VIEW_CNT = VIEW_CNT + 1 WHERE C_BOARD_ID = ?";
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, cBoardId);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public Long findWriterId(Long cBoardId) {
        String sql = "SELECT MEMBER_ID FROM COMMUNITY_BOARD WHERE C_BOARD_ID = ?";
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, cBoardId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getLong("MEMBER_ID") : null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public String findStatus(Connection conn, Long cBoardId) throws SQLException {
        String sql = "SELECT STATUS FROM COMMUNITY_BOARD WHERE C_BOARD_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, cBoardId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getString("STATUS") : null;
            }
        }
    }

    public int updateLikeCnt(Connection conn, Long cBoardId, int delta) throws SQLException {
        String sql = "UPDATE COMMUNITY_BOARD SET LIKE_CNT = LIKE_CNT + ? WHERE C_BOARD_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, delta);
            pstmt.setLong(2, cBoardId);
            return pstmt.executeUpdate();
        }
    }
}