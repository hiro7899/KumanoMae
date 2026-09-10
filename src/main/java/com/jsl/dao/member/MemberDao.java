package com.jsl.dao.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.jsl.dto.member.MemberDto;
import com.jsl.sql.member.MemberSql;
import com.jsl.util.DBManager;

// 회원관리 DAO
// 로그인은 AuthDao에서 처리
public class MemberDao {

    public List<MemberDto> selectAllMembers() {
        List<MemberDto> list = new ArrayList<>();

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(MemberSql.SELECT_ALL_MEMBERS);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                MemberDto member = new MemberDto();

                member.setMemberId(rs.getLong("MEMBER_ID"));
                member.setUserId(rs.getString("USER_ID"));
                member.setUserName(rs.getString("USER_NAME"));
                member.setEmail(rs.getString("EMAIL"));
                member.setPhone(rs.getString("PHONE"));
                member.setUserGrade(rs.getString("USER_GRADE"));
                member.setStatus(rs.getString("STATUS"));

                if (rs.getTimestamp("JOIN_DATE") != null) {
                    member.setJoinDate(
                        rs.getTimestamp("JOIN_DATE").toLocalDateTime()
                    );
                }

                list.add(member);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public String findStatus(Connection conn, Long memberId) throws SQLException {

        try (PreparedStatement pstmt = conn.prepareStatement(MemberSql.SELECT_STATUS)) {

            pstmt.setLong(1, memberId);

            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getString("STATUS") : null;
            }
        }
    }

    public String findGrade(Connection conn, Long memberId) throws SQLException {

        try (PreparedStatement pstmt = conn.prepareStatement(MemberSql.SELECT_GRADE)) {

            pstmt.setLong(1, memberId);

            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getString("USER_GRADE") : null;
            }
        }
    }

    public int updateGrade(
            Connection conn,
            Long memberId,
            String grade) throws SQLException {

        try (PreparedStatement pstmt = conn.prepareStatement(MemberSql.UPDATE_GRADE)) {

            pstmt.setString(1, grade);
            pstmt.setLong(2, memberId);

            return pstmt.executeUpdate();
        }
    }

    /** 물리 DELETE가 아닌 소프트 삭제(STATUS='N') */
    public int updateStatus(
            Connection conn,
            Long memberId,
            String status) throws SQLException {

        try (PreparedStatement pstmt = conn.prepareStatement(MemberSql.UPDATE_STATUS)) {

            pstmt.setString(1, status);
            pstmt.setLong(2, memberId);

            return pstmt.executeUpdate();
        }
    }

    public int countActive() {

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(MemberSql.COUNT_ACTIVE);
             ResultSet rs = pstmt.executeQuery()) {

            return rs.next() ? rs.getInt(1) : 0;

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}