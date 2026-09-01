package com.jsl.service.login;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.AuthDao;
import com.jsl.dto.member.MemberDto;
import com.jsl.service.Command;
import com.jsl.util.PasswordUtil;

public class SignUpService implements Command {

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        MemberDto member = new MemberDto();

        member.setUserId(request.getParameter("userId"));

        String userPw = request.getParameter("userPw");
        member.setUserPw(PasswordUtil.hashPassword(userPw));

        member.setUserName(request.getParameter("userName"));
        member.setEmail(request.getParameter("email"));

        String phone = request.getParameter("phone");
        member.setPhone(phone != null && !phone.isEmpty() ? phone : null);

        AuthDao dao = new AuthDao();
        dao.signUp(member);
    }
}