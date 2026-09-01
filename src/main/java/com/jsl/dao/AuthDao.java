package com.jsl.dao;

import java.sql.Connection;

import com.jsl.dto.member.MemberDto;
import com.jsl.util.DBManager;

public class AuthDao {
	
	public boolean SignUp(MemberDto member) {
		String sql = """
				INSERT INTO MEMBER (
					MEMBER_ID, USER_ID, USER_PW, USER_NAME, EMAIL, PHONE
					)
					VALUES (
					MEMBER_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?
					)
				""";
		
		try (Connection conn = DBManager.getConnection();
				java.sql.PreparedStatement pstmt = conn.prepareStatement(sql)) {
			
			pstmt.setString(1, member.getUserId());
			pstmt.setString(2, member.getUserPw());
			pstmt.setString(3, member.getUserName());
			pstmt.setString(4, member.getEmail());
			pstmt.setString(5, member.getPhone());
			
			int result = pstmt.executeUpdate();
			
			if (result == 0) {
				return false;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		
		return true;
	}
}
