package com.jsl.dao.board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.jsl.dto.board.BoardFileDto;
import com.jsl.sql.board.BoardFileSql;
import com.jsl.util.DBManager;

public class BoardFileDao {

    // 제보 첨부파일 등록
    public int insertFile(Connection conn, BoardFileDto file) throws SQLException {

        try (PreparedStatement pstmt = conn.prepareStatement(BoardFileSql.INSERT_FILE)) {

            pstmt.setLong(1, file.getBoardId());
            pstmt.setString(2, file.getOriginName());
            pstmt.setString(3, file.getSaveName());
            pstmt.setString(4, file.getFilePath());
            pstmt.setInt(5, file.getFileSize());

            return pstmt.executeUpdate();
        }
    }

    // 제보 대표 이미지 조회
    public String selectFirstFileUrl(Long boardId) {

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(BoardFileSql.SELECT_FIRST_FILE_URL)) {

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