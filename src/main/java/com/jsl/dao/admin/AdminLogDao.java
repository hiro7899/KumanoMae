package com.jsl.dao.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class AdminLogDao {

    public int insertLog(Connection conn, Long adminId, String targetType, Long targetId,
                          String actionType, String actionMemo) throws SQLException {

        String sql = """
            INSERT INTO ADMIN_LOG (
                LOG_ID, ADMIN_ID, TARGET_TYPE, TARGET_ID, ACTION_TYPE, ACTION_MEMO
            ) VALUES (
                LOG_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?
            )
            """;

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, adminId);
            pstmt.setString(2, targetType);
            pstmt.setLong(3, targetId);
            pstmt.setString(4, actionType);
            pstmt.setString(5, actionMemo);
            return pstmt.executeUpdate();
        }
    }
}