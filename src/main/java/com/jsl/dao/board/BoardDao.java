package com.jsl.dao.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.jsl.dto.board.BoardDto;
import com.jsl.util.DBManager;

public class BoardDao {

	public List<BoardDto> selectAllBoard() {
	    String sql = """
	        SELECT BOARD_ID,
	               MEMBER_ID,
	               TITLE,
	               CONTENT,
	               RISK_LEVEL,
	               LATITUDE,
	               LONGITUDE,
	               ADDRESS,
	               SIGHTING_DATE,
	               SITUATION_TAG,
	               VIEW_CNT,
	               STATUS,
	               CLEAR_YN,
	               CLEAR_DATE,
	               CLEAR_MEMO,
	               REG_DATE,
	               MOD_DATE
	          FROM BOARD
	         ORDER BY REG_DATE DESC
	        """;

	    List<BoardDto> list = new ArrayList<>();

	    try (Connection conn = DBManager.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        while (rs.next()) {
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
	                board.setSightingDate(
	                    rs.getTimestamp("SIGHTING_DATE").toLocalDateTime()
	                );
	            }

	            board.setSituationTag(rs.getString("SITUATION_TAG"));
	            board.setViewCnt(rs.getInt("VIEW_CNT"));
	            board.setStatus(rs.getString("STATUS"));
	            board.setClearYn(rs.getString("CLEAR_YN"));

	            if (rs.getTimestamp("CLEAR_DATE") != null) {
	                board.setClearDate(
	                    rs.getTimestamp("CLEAR_DATE").toLocalDateTime()
	                );
	            }

	            board.setClearMemo(rs.getString("CLEAR_MEMO"));

	            if (rs.getTimestamp("REG_DATE") != null) {
	                board.setRegDate(
	                    rs.getTimestamp("REG_DATE").toLocalDateTime()
	                );
	            }

	            if (rs.getTimestamp("MOD_DATE") != null) {
	                board.setModDate(
	                    rs.getTimestamp("MOD_DATE").toLocalDateTime()
	                );
	            }

	            list.add(board);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	
    public List<BoardDto> selectApprovedBoard() {

        String sql = """
            SELECT BOARD_ID,
                   MEMBER_ID,
                   TITLE,
                   CONTENT,
                   RISK_LEVEL,
                   LATITUDE,
                   LONGITUDE,
                   ADDRESS,
                   SIGHTING_DATE,
                   SITUATION_TAG,
                   VIEW_CNT,
                   STATUS,
                   CLEAR_YN,
                   CLEAR_DATE,
                   CLEAR_MEMO,
                   REG_DATE,
                   MOD_DATE
              FROM BOARD
             WHERE STATUS = 'Y'
             ORDER BY REG_DATE DESC
            """;

        List<BoardDto> boardList = new ArrayList<>();

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {

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
                    board.setSightingDate(
                        rs.getTimestamp("SIGHTING_DATE").toLocalDateTime()
                    );
                }

                board.setSituationTag(rs.getString("SITUATION_TAG"));
                board.setViewCnt(rs.getInt("VIEW_CNT"));
                board.setStatus(rs.getString("STATUS"));
                board.setClearYn(rs.getString("CLEAR_YN"));

                if (rs.getTimestamp("CLEAR_DATE") != null) {
                    board.setClearDate(
                        rs.getTimestamp("CLEAR_DATE").toLocalDateTime()
                    );
                }

                board.setClearMemo(rs.getString("CLEAR_MEMO"));

                if (rs.getTimestamp("REG_DATE") != null) {
                    board.setRegDate(
                        rs.getTimestamp("REG_DATE").toLocalDateTime()
                    );
                }

                if (rs.getTimestamp("MOD_DATE") != null) {
                    board.setModDate(
                        rs.getTimestamp("MOD_DATE").toLocalDateTime()
                    );
                }

                boardList.add(board);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return boardList;
    }
}
