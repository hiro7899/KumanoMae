package com.jsl.dao.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.jsl.dto.board.BoardFileDto;

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
}