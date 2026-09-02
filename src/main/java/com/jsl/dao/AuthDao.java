package com.jsl.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

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
	
	public boolean signUp(MemberDto member) {
	    String sql = """
	            INSERT INTO MEMBER (
	                MEMBER_ID, USER_ID, USER_PW, USER_NAME, EMAIL, PHONE
	            )
	            VALUES (
	                MEMBER_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?
	            )
	            """;

	    try (Connection conn = DBManager.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {

	        pstmt.setString(1, member.getUserId());
	        pstmt.setString(2, member.getUserPw());
	        pstmt.setString(3, member.getUserName());
	        pstmt.setString(4, member.getEmail());
	        pstmt.setString(5, member.getPhone());

	        return pstmt.executeUpdate() > 0;

	    } catch (Exception e) {
	        e.printStackTrace();
	        return false;
	    }
	}
	
	public MemberDto login(String userId) {

		String sql = """
			    SELECT MEMBER_ID, USER_ID, USER_PW, USER_NAME, EMAIL, USER_GRADE
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

	                return member;
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return null;
	}
}
