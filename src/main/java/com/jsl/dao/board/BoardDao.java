package com.jsl.dao.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.jsl.dto.board.BoardDto;
import com.jsl.util.DBManager;

public class BoardDao {

    public List<BoardDto> selectAllBoard() {
        String sql = """
            SELECT BOARD_ID, MEMBER_ID, TITLE, CONTENT, RISK_LEVEL, LATITUDE, LONGITUDE,
                   ADDRESS, SIGHTING_DATE, SITUATION_TAG, VIEW_CNT, STATUS, CLEAR_YN,
                   CLEAR_DATE, CLEAR_MEMO, REG_DATE, MOD_DATE
              FROM BOARD
             ORDER BY REG_DATE DESC
            """;

        List<BoardDto> list = new ArrayList<>();

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<BoardDto> selectApprovedBoard() {
        String sql = """
            SELECT BOARD_ID, MEMBER_ID, TITLE, CONTENT, RISK_LEVEL, LATITUDE, LONGITUDE,
                   ADDRESS, SIGHTING_DATE, SITUATION_TAG, VIEW_CNT, STATUS, CLEAR_YN,
                   CLEAR_DATE, CLEAR_MEMO, REG_DATE, MOD_DATE
              FROM BOARD
             WHERE STATUS = 'Y'
             ORDER BY REG_DATE DESC
            """;

        List<BoardDto> boardList = new ArrayList<>();

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                boardList.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return boardList;
    }

    /** ResultSet 1행을 BoardDto로 매핑하는 공통 헬퍼 (기존 두 메서드의 중복 제거) */
    private BoardDto mapRow(ResultSet rs) throws SQLException {
        BoardDto board = new BoardDto();

        board.setBoardId(rs.getLong("BOARD_ID"));
        board.setMemberId(rs.getLong("MEMBER_ID"));
        board.setTitle(rs.getString("TITLE"));
        board.setContent(rs.getString("CONTENT"));
        board.setRiskLevel(rs.getString("RISK_LEVEL"));
        board.setLatitude(rs.getDouble("LATITUDE"));
        board.setLongitude(rs.getDouble("LONGITUDE"));
        board.setAddress(rs.getString("ADDRESS"));

        if (rs.getTimestamp("SIGHTING_DATE") != null) {
            board.setSightingDate(rs.getTimestamp("SIGHTING_DATE").toLocalDateTime());
        }

        board.setSituationTag(rs.getString("SITUATION_TAG"));
        board.setViewCnt(rs.getInt("VIEW_CNT"));
        board.setStatus(rs.getString("STATUS"));
        board.setClearYn(rs.getString("CLEAR_YN"));

        if (rs.getTimestamp("CLEAR_DATE") != null) {
            board.setClearDate(rs.getTimestamp("CLEAR_DATE").toLocalDateTime());
        }

        board.setClearMemo(rs.getString("CLEAR_MEMO"));

        if (rs.getTimestamp("REG_DATE") != null) {
            board.setRegDate(rs.getTimestamp("REG_DATE").toLocalDateTime());
        }

        if (rs.getTimestamp("MOD_DATE") != null) {
            board.setModDate(rs.getTimestamp("MOD_DATE").toLocalDateTime());
        }

        return board;
    }

    /**
     * ★ 트랜잭션 처리를 위해 Connection을 외부(Service)에서 전달받는다.
     * ★ 생성된 BOARD_ID를 Long으로 반환한다 (JDBC Generated Keys 방식).
     */
    public Long insertReport(Connection conn, BoardDto board) throws SQLException {

        String sql = """
            INSERT INTO BOARD (
                BOARD_ID, MEMBER_ID, TITLE, CONTENT, RISK_LEVEL,
                LATITUDE, LONGITUDE, ADDRESS, SIGHTING_DATE, SITUATION_TAG, STATUS
            ) VALUES (
                BOARD_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'W'
            )
            """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql, new String[] { "BOARD_ID" })) {

            pstmt.setLong(1, board.getMemberId());
            pstmt.setString(2, board.getTitle());
            pstmt.setString(3, board.getContent());
            pstmt.setString(4, board.getRiskLevel());
            pstmt.setDouble(5, board.getLatitude());
            pstmt.setDouble(6, board.getLongitude());
            pstmt.setString(7, board.getAddress());
            pstmt.setTimestamp(8, Timestamp.valueOf(board.getSightingDate()));
            pstmt.setString(9, board.getSituationTag());

            pstmt.executeUpdate();

            try (ResultSet keys = pstmt.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getLong(1);
                }
            }
            throw new SQLException("BOARD_ID 채번에 실패했습니다.");
        }
    }
    
    /** 제보 승인/반려 공통 처리. status는 'Y' 또는 'N' */
    public int updateStatus(Connection conn, Long boardId, String status) throws SQLException {

        String sql = "UPDATE BOARD SET STATUS = ?, MOD_DATE = SYSDATE WHERE BOARD_ID = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setLong(2, boardId);
            return pstmt.executeUpdate();
        }
    }

    /** 위험 해제 처리 */
    public int updateClear(Connection conn, Long boardId, String clearMemo) throws SQLException {

        String sql = """
            UPDATE BOARD
               SET CLEAR_YN = 'Y', CLEAR_DATE = SYSDATE, CLEAR_MEMO = ?, MOD_DATE = SYSDATE
             WHERE BOARD_ID = ?
            """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, clearMemo);
            pstmt.setLong(2, boardId);
            return pstmt.executeUpdate();
        }
    }

    /** 현재 STATUS 조회 - 승인/반려 시 상태 전이 검증용 (예: 이미 승인된 글을 다시 승인 시도 방지) */
    public String findStatus(Connection conn, Long boardId) throws SQLException {

        String sql = "SELECT STATUS FROM BOARD WHERE BOARD_ID = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, boardId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getString("STATUS") : null;
            }
        }
    }
}