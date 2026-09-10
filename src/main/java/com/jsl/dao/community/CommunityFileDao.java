package com.jsl.dao.community;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.jsl.dto.community.CommunityFileDto;
import com.jsl.sql.community.CommunityFileSql;
import com.jsl.util.DBManager;

public class CommunityFileDao {

    public int insertFile(
            Connection conn,
            CommunityFileDto dto) throws SQLException {

        try (PreparedStatement pstmt =
                conn.prepareStatement(CommunityFileSql.INSERT_FILE)) {

            pstmt.setLong(1, dto.getCBoardId());
            pstmt.setString(2, dto.getOriginName());
            pstmt.setString(3, dto.getSaveName());
            pstmt.setString(4, dto.getFilePath());

            return pstmt.executeUpdate();
        }
    }

    public List<CommunityFileDto> selectFilesByBoardId(
            Long cBoardId,
            Connection conn) throws SQLException {

        List<CommunityFileDto> list = new ArrayList<>();

        try (PreparedStatement pstmt =
                conn.prepareStatement(
                        CommunityFileSql.SELECT_FILES_BY_BOARD_ID)) {

            pstmt.setLong(1, cBoardId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {

                    CommunityFileDto dto = new CommunityFileDto();

                    dto.setCFileId(rs.getLong("C_FILE_ID"));
                    dto.setCBoardId(rs.getLong("C_BOARD_ID"));
                    dto.setOriginName(rs.getString("ORIGIN_NAME"));
                    dto.setSaveName(rs.getString("SAVE_NAME"));
                    dto.setFilePath(rs.getString("FILE_PATH"));

                    list.add(dto);
                }
            }
        }

        return list;
    }

    /** 조회 전용 - 자체 Connection 사용 (CommunityViewService에서 씀) */
    public List<CommunityFileDto> selectFilesByBoardId(Long cBoardId) {

        try (Connection conn = DBManager.getConnection()) {
            return selectFilesByBoardId(cBoardId, conn);

        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /** 수정 시 파일 교체 - 기존 행 삭제 (물리 파일 삭제는 Service에서 별도 처리) */
    public int deleteFilesByBoardId(
            Connection conn,
            Long cBoardId) throws SQLException {

        try (PreparedStatement pstmt =
                conn.prepareStatement(
                        CommunityFileSql.DELETE_FILES_BY_BOARD_ID)) {

            pstmt.setLong(1, cBoardId);

            return pstmt.executeUpdate();
        }
    }

    public String selectFirstFileUrl(Long cBoardId) {

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt =
                     conn.prepareStatement(
                             CommunityFileSql.SELECT_FIRST_FILE_URL)) {

            pstmt.setLong(1, cBoardId);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    return rs.getString("FILE_PATH")
                            + "/"
                            + rs.getString("SAVE_NAME");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}