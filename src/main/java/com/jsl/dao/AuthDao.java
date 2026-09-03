package com.jsl.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.jsl.dto.member.MemberDto;
import com.jsl.util.DBManager;

public class AuthDao {

    // 아이디 존재 여부 검색
    public boolean existsUserId(String userId) {
        String sql = "SELECT USER_ID FROM MEMBER WHERE USER_ID = ?";
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 회원가입. Connection은 Service에서 전달받아 그대로 사용한다 (트랜잭션 공유).
     * 생성된 MEMBER_ID를 Long으로 반환한다 (JDBC Generated Keys 방식).
     */
    public Long signUp(Connection conn, MemberDto member) throws SQLException {

        String sql = """
                INSERT INTO MEMBER (
                    MEMBER_ID, USER_ID, USER_PW, USER_NAME, EMAIL, PHONE
                )
                VALUES (
                    MEMBER_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?
                )
                """;
        // USER_GRADE('M'), STATUS('Y'), EMAIL_VERIFIED_YN('N'), JOIN_DATE(SYSDATE)는
        // DB DEFAULT 값을 그대로 사용하므로 여기서 지정하지 않음

        try (PreparedStatement pstmt = conn.prepareStatement(sql, new String[] { "MEMBER_ID" })) {

            pstmt.setString(1, member.getUserId());
            pstmt.setString(2, member.getUserPw());
            pstmt.setString(3, member.getUserName());
            pstmt.setString(4, member.getEmail());
            pstmt.setString(5, member.getPhone());

            pstmt.executeUpdate();

            try (ResultSet keys = pstmt.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getLong(1);
                }
            }
            throw new SQLException("MEMBER_ID 채번에 실패했습니다.");
        }
    }

    public MemberDto login(String userId) {
        String sql = """
                SELECT MEMBER_ID, USER_ID, USER_PW, USER_NAME, EMAIL, USER_GRADE, EMAIL_VERIFIED_YN
                FROM MEMBER
                WHERE USER_ID = ? OR EMAIL = ?
                """;
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    MemberDto member = new MemberDto();
                    member.setMemberId(rs.getLong("MEMBER_ID"));
                    member.setUserId(rs.getString("USER_ID"));
                    member.setUserPw(rs.getString("USER_PW"));
                    member.setUserName(rs.getString("USER_NAME"));
                    member.setEmail(rs.getString("EMAIL"));
                    member.setUserGrade(rs.getString("USER_GRADE"));
                    member.setEmailVerifiedYn(rs.getString("EMAIL_VERIFIED_YN")); // ★ 추가
                    return member;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int updateEmailVerified(Connection conn, Long memberId, String yn) throws SQLException {
        String sql = "UPDATE MEMBER SET EMAIL_VERIFIED_YN = ? WHERE MEMBER_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, yn);
            pstmt.setLong(2, memberId);
            return pstmt.executeUpdate();
        }
    }

    /** 비밀번호 재설정 흐름 - 트랜잭션 시작 전 이메일로 회원 존재 여부만 확인하는 용도 */
    public MemberDto findByEmail(String email) {
        String sql = "SELECT MEMBER_ID, USER_ID, USER_NAME, EMAIL FROM MEMBER WHERE EMAIL = ?";
        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    MemberDto member = new MemberDto();
                    member.setMemberId(rs.getLong("MEMBER_ID"));
                    member.setUserId(rs.getString("USER_ID"));
                    member.setUserName(rs.getString("USER_NAME"));
                    member.setEmail(rs.getString("EMAIL"));
                    return member;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /** 비밀번호 재설정 - Connection은 Service(ResetPasswordService)에서 전달받아 토큰 처리와 같은 트랜잭션으로 묶음 */
    public int updatePassword(Connection conn, Long memberId, String hashedPassword) throws SQLException {
        String sql = "UPDATE MEMBER SET USER_PW = ? WHERE MEMBER_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, hashedPassword);
            pstmt.setLong(2, memberId);
            return pstmt.executeUpdate();
        }
    }
}