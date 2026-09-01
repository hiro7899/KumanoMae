package com.jsl.service.login;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.AuthDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.dto.member.MemberDto;
import com.jsl.service.Command;
import com.jsl.util.PasswordUtil;

public class LoginService implements Command {

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String userId = request.getParameter("userId");
        String userPw = request.getParameter("userPw");

        MemberDto member = new AuthDao().login(userId);

        if (member != null && PasswordUtil.checkPassword(userPw, member.getUserPw())) {

            HttpSession session = request.getSession();

            LoginUserDto user = new LoginUserDto(
                member.getUserId(),
                member.getUserName(),
                member.getUserGrade()
            );

            session.setAttribute("user", user);
        }
    }
}
