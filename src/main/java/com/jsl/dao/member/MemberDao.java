package com.jsl.dao.member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.jsl.dto.member.MemberDto;
import com.jsl.util.DBManager;

//회원관리 DAO 로그인은 AuthDao에서 처리
public class MemberDao {

    public List<MemberDto> selectAllMembers() {
        String sql = """
            SELECT MEMBER_ID, USER_ID, USER_NAME, EMAIL, PHONE, USER_GRADE, STATUS, JOIN_DATE
              FROM MEMBER
             ORDER BY JOIN_DATE DESC
            """;

        List<MemberDto> list = new ArrayList<>();

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
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
                    member.setJoinDate(rs.getTimestamp("JOIN_DATE").toLocalDateTime());
                }
                list.add(member);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public String findStatus(Connection conn, Long memberId) throws SQLException {
        String sql = "SELECT STATUS FROM MEMBER WHERE MEMBER_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, memberId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getString("STATUS") : null;
            }
        }
    }

    public String findGrade(Connection conn, Long memberId) throws SQLException {
        String sql = "SELECT USER_GRADE FROM MEMBER WHERE MEMBER_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setLong(1, memberId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getString("USER_GRADE") : null;
            }
        }
    }

    public int updateGrade(Connection conn, Long memberId, String grade) throws SQLException {
        String sql = "UPDATE MEMBER SET USER_GRADE = ? WHERE MEMBER_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, grade);
            pstmt.setLong(2, memberId);
            return pstmt.executeUpdate();
        }
    }

    /** 물리 DELETE가 아닌 소프트 삭제(STATUS='N') */
    public int updateStatus(Connection conn, Long memberId, String status) throws SQLException {
        String sql = "UPDATE MEMBER SET STATUS = ? WHERE MEMBER_ID = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setLong(2, memberId);
            return pstmt.executeUpdate();
        }
    }
}