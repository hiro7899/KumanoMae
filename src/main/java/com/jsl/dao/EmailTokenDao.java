package com.jsl.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;

import com.jsl.dto.EmailTokenDto;
import com.jsl.sql.EmailTokenSql;

public class EmailTokenDao {

    public int insertToken(Connection conn, Long memberId, String token, String tokenType,
                           LocalDateTime expireDate) throws SQLException {

        try (PreparedStatement pstmt = conn.prepareStatement(EmailTokenSql.INSERT_TOKEN)) {
            pstmt.setLong(1, memberId);
            pstmt.setString(2, token);
            pstmt.setString(3, tokenType);
            pstmt.setTimestamp(4, Timestamp.valueOf(expireDate));

            return pstmt.executeUpdate();
        }
    }

    /** 유효한(만료 안 됐고 미사용) 토큰만 조회 */
    public EmailTokenDto findValidToken(Connection conn, String token, String tokenType)
            throws SQLException {

        try (PreparedStatement pstmt = conn.prepareStatement(EmailTokenSql.SELECT_VALID_TOKEN)) {
            pstmt.setString(1, token);
            pstmt.setString(2, tokenType);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }

                EmailTokenDto dto = new EmailTokenDto();

                dto.setTokenId(rs.getLong("TOKEN_ID"));
                dto.setMemberId(rs.getLong("MEMBER_ID"));
                dto.setToken(rs.getString("TOKEN"));
                dto.setTokenType(rs.getString("TOKEN_TYPE"));
                dto.setExpireDate(
                    rs.getTimestamp("EXPIRE_DATE").toLocalDateTime()
                );
                dto.setUsedYn(rs.getString("USED_YN"));

                return dto;
            }
        }
    }

    public int markUsed(Connection conn, Long tokenId) throws SQLException {

        try (PreparedStatement pstmt = conn.prepareStatement(EmailTokenSql.MARK_USED)) {
            pstmt.setLong(1, tokenId);

            return pstmt.executeUpdate();
        }
    }
}