package com.jsl.service.login;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.AuthDao;
import com.jsl.dto.member.MemberDto;
import com.jsl.service.Command;

public class SignUpService implements Command{

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

		MemberDto member = new MemberDto();
		member.setUserId(request.getParameter("userId"));
		member.setUserPw(request.getParameter("userPw"));
		member.setUserName(request.getParameter("userName"));
		member.setEmail(request.getParameter("email"));
		
		if(request.getParameter("phone") != null && !request.getParameter("phone").isEmpty()) {
		    member.setPhone(request.getParameter("phone"));
		} else {
		    member.setPhone(null);
		}
		
		AuthDao dao = new AuthDao();
		
		dao.SignUp(member);
		
	}

}
