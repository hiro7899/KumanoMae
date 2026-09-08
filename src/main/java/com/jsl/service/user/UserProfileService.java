package com.jsl.service.user;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.AuthDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.dto.member.MemberDto;
import com.jsl.exeption.EmailNotVerifiedException;
import com.jsl.service.Command;

public class UserProfileService implements Command {

	private final AuthDao authDao = new AuthDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        LoginUserDto loginUser = (session != null) ? (LoginUserDto) session.getAttribute("user") : null;
        if (loginUser == null) {
            throw new EmailNotVerifiedException("LOGIN_REQUIRED", "ログインが必要です。");
        }

        MemberDto member = authDao.findById(loginUser.getMemberId());
        if (member == null) {
            throw new EmailNotVerifiedException("LOGIN_REQUIRED", "会員情報が見つかりません。");
        }

        request.setAttribute("userId", member.getUserId());
        request.setAttribute("userName", member.getUserName());
        request.setAttribute("email", member.getEmail());
        request.setAttribute("phone", member.getPhone());
        request.setAttribute("userGrade", member.getUserGrade());
        request.setAttribute("joinDate", member.getJoinDate());
        request.setAttribute("emailVerified", "Y".equals(member.getEmailVerifiedYn()));
    }
}
