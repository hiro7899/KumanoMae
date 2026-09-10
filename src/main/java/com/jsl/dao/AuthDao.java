package com.jsl.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.jsl.dto.member.MemberDto;
import com.jsl.sql.AuthSql;
import com.jsl.util.DBManager;

public class AuthDao {

    // 아이디 존재 여부 검색
    public boolean existsUserId(String userId) {

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(AuthSql.EXISTS_USER_ID)) {

            pstmt.setString(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 이메일 존재 여부 검색
    public boolean existsEmail(String email) {

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(AuthSql.EXISTS_EMAIL)) {

            pstmt.setString(1, email);

            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 회원가입.
     * Connection은 Service에서 전달받아 그대로 사용한다.
     * 생성된 MEMBER_ID를 Long으로 반환한다.
     */
    public Long signUp(Connection conn, MemberDto member) throws SQLException {

        try (PreparedStatement pstmt =
                conn.prepareStatement(
                    AuthSql.SIGN_UP,
                    new String[] { "MEMBER_ID" })) {

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

    // 로그인
    public MemberDto login(String userId) {

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(AuthSql.LOGIN)) {

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
                    member.setEmailVerifiedYn(
                        rs.getString("EMAIL_VERIFIED_YN")
                    );

                    return member;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // 이메일 인증 상태 변경
    public int updateEmailVerified(
            Connection conn,
            Long memberId,
            String yn) throws SQLException {

        try (PreparedStatement pstmt =
                conn.prepareStatement(AuthSql.UPDATE_EMAIL_VERIFIED)) {

            pstmt.setString(1, yn);
            pstmt.setLong(2, memberId);

            return pstmt.executeUpdate();
        }
    }

    /**
     * 비밀번호 재설정 흐름.
     * 트랜잭션 시작 전 이메일로 회원 존재 여부만 확인하는 용도
     */
    public MemberDto findByEmail(String email) {

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt =
                conn.prepareStatement(AuthSql.SELECT_BY_EMAIL)) {

            pstmt.setString(1, email);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    MemberDto member = new MemberDto();

                    member.setMemberId(rs.getLong("MEMBER_ID"));
                    member.setUserId(rs.getString("USER_ID"));
                    member.setUserName(rs.getString("USER_NAME"));
                    member.setEmail(rs.getString("EMAIL"));
                    member.setEmailVerifiedYn(
                        rs.getString("EMAIL_VERIFIED_YN")
                    );

                    return member;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * 비밀번호 재설정.
     * Connection은 Service에서 전달받아 토큰 처리와 같은 트랜잭션으로 묶음
     */
    public int updatePassword(
            Connection conn,
            Long memberId,
            String hashedPassword) throws SQLException {

        try (PreparedStatement pstmt =
                conn.prepareStatement(AuthSql.UPDATE_PASSWORD)) {

            pstmt.setString(1, hashedPassword);
            pstmt.setLong(2, memberId);

            return pstmt.executeUpdate();
        }
    }

    // 이름 + 이메일로 회원 조회
    public MemberDto findByNameAndEmail(
            String userName,
            String email) {

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt =
                conn.prepareStatement(AuthSql.SELECT_BY_NAME_AND_EMAIL)) {

            pstmt.setString(1, userName);
            pstmt.setString(2, email);

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

    // 회원 ID로 회원 조회
    public MemberDto findById(Long memberId) {

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt =
                conn.prepareStatement(AuthSql.SELECT_BY_ID)) {

            pstmt.setLong(1, memberId);

            try (ResultSet rs = pstmt.executeQuery()) {

                if (rs.next()) {
                    MemberDto member = new MemberDto();

                    member.setMemberId(rs.getLong("MEMBER_ID"));
                    member.setUserId(rs.getString("USER_ID"));
                    member.setUserName(rs.getString("USER_NAME"));
                    member.setEmail(rs.getString("EMAIL"));
                    member.setPhone(rs.getString("PHONE"));
                    member.setUserGrade(rs.getString("USER_GRADE"));

                    if (rs.getTimestamp("JOIN_DATE") != null) {
                        member.setJoinDate(
                            rs.getTimestamp("JOIN_DATE").toLocalDateTime()
                        );
                    }

                    member.setEmailVerifiedYn(
                        rs.getString("EMAIL_VERIFIED_YN")
                    );

                    return member;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}