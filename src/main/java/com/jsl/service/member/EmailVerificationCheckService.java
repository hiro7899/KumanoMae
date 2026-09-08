package com.jsl.service.member;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.AuthDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.dto.member.MemberDto;
import com.jsl.service.Command;

public class EmailVerificationCheckService implements Command {

    private final AuthDao authDao = new AuthDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        LoginUserDto loginUser = (session != null) ? (LoginUserDto) session.getAttribute("user") : null;
        if (loginUser == null) {
            throw new RuntimeException("로그인이 필요합니다."); // RootController에서 미리 세션 체크할 예정이라 실제로는 도달 안 함
        }

        MemberDto member = authDao.findById(loginUser.getMemberId());
        request.setAttribute("email", member.getEmail());
        request.setAttribute("emailVerified", "Y".equals(member.getEmailVerifiedYn()));
    }
}