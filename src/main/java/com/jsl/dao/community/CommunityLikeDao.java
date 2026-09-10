package com.jsl.dao.community;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.jsl.sql.community.CommunityLikeSql;

public class CommunityLikeDao {

    public boolean exists(
            Connection conn,
            Long cBoardId,
            Long memberId) throws SQLException {

        try (PreparedStatement pstmt =
                conn.prepareStatement(CommunityLikeSql.EXISTS)) {

            pstmt.setLong(1, cBoardId);
            pstmt.setLong(2, memberId);

            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public int insertLike(
            Connection conn,
            Long cBoardId,
            Long memberId) throws SQLException {

        try (PreparedStatement pstmt =
                conn.prepareStatement(CommunityLikeSql.INSERT_LIKE)) {

            pstmt.setLong(1, cBoardId);
            pstmt.setLong(2, memberId);

            return pstmt.executeUpdate();
        }
    }

    public int deleteLike(
            Connection conn,
            Long cBoardId,
            Long memberId) throws SQLException {

        try (PreparedStatement pstmt =
                conn.prepareStatement(CommunityLikeSql.DELETE_LIKE)) {

            pstmt.setLong(1, cBoardId);
            pstmt.setLong(2, memberId);

            return pstmt.executeUpdate();
        }
    }
}