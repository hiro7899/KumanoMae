package com.jsl.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

	//비밀번호 암호화
	public static String hashPassword(String plainPassword) {
		return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
	}
	
	//비밀번호 비교
	public static boolean checkPassword(String plainPassword, String hashPassword) {
		return BCrypt.checkpw(plainPassword, hashPassword);
	}
}
