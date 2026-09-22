package com.jsl.dao.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.jsl.sql.admin.AdminLogSql;

public class AdminLogDao {
	
    public int insertLog(Connection conn, Long adminId, String targetType, Long targetId,
                          String actionType, String actionMemo) throws SQLException {

        try (PreparedStatement pstmt = conn.prepareStatement(AdminLogSql.INSERT_LOG)) {
            pstmt.setLong(1, adminId);
            pstmt.setString(2, targetType);
            pstmt.setLong(3, targetId);
            pstmt.setString(4, actionType);
            pstmt.setString(5, actionMemo);
            return pstmt.executeUpdate();
        }
    }
}