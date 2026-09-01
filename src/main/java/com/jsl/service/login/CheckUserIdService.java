package com.jsl.service.login;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.AuthDao;
import com.jsl.service.Command;


public class CheckUserIdService implements Command {

	@Override
	public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String userId = request.getParameter("userId");
		
		Integer result = new AuthDao().findUserId(userId);
		
		//dao에서 반환된 result를 클라이언트에게 전달
		PrintWriter out  = response.getWriter();
		out.print(result);
	}

}
