package com.jsl.dao.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.jsl.dto.board.BoardFileDto;
import com.jsl.util.DBManager;

public class BoardFileDao {

    public int insertFile(Connection conn, BoardFileDto file) throws SQLException {

        String sql = """
            INSERT INTO BOARD_FILE (
                FILE_ID, BOARD_ID, ORIGIN_NAME, SAVE_NAME, FILE_PATH, FILE_SIZE
            ) VALUES (
                FILE_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?
            )
            """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, file.getBoardId());
            pstmt.setString(2, file.getOriginName());
            pstmt.setString(3, file.getSaveName());
            pstmt.setString(4, file.getFilePath());
            pstmt.setInt(5, file.getFileSize());
            return pstmt.executeUpdate();
        }
    }
    
    public String selectFirstFileUrl(Long boardId) {
        String sql = """
            SELECT FILE_PATH, SAVE_NAME FROM (
                SELECT FILE_PATH, SAVE_NAME
                  FROM BOARD_FILE
                 WHERE BOARD_ID = ?
                 ORDER BY FILE_ID ASC
            ) WHERE ROWNUM = 1
            """;
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, boardId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("FILE_PATH") + "/" + rs.getString("SAVE_NAME");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}