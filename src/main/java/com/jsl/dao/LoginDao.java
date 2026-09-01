package com.jsl.dao;

import java.sql.Connection;

import com.jsl.dto.member.MemberDto;
import com.jsl.util.DBManager;

public class LoginDao {
	
	public boolean SingUp(MemberDto member) {
		// 회원가입 로직 구현
		String sql = """
				INSERT INTO MEMBER (
					MEMBER_ID, USER_ID, USER_PW, USER_NAME, EMAIL, PHONE
					)
					VALUES (
					MEMBER_ID_SEQ, ?, ?, ?, ?, ?
					)
				""";
		
		try (Connection conn = DBManager.getConnection();
				java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			pstmt.setString(1, member.getUserId());
			pstmt.setString(2, member.getUserPw());
			pstmt.setString(3, member.getUserName());
			pstmt.setString(4, member.getEmail());
			pstmt.setString(5, member.getPhone());
			
			int rowsAffected = pstmt.executeUpdate();
			
			if (rowsAffected == 0) {
				return false; // 회원가입 실패 시 false 반환
			}
			
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return true; // 회원가입 성공 시 true 반환
	}
}
