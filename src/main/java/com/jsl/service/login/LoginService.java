package com.jsl.service.login;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.AuthDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.dto.member.MemberDto;
import com.jsl.exeption.LoginException;
import com.jsl.service.Command;
import com.jsl.util.PasswordUtil;

public class LoginService implements Command {

    private final AuthDao authDao = new AuthDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String userId = request.getParameter("userId");
        String userPw = request.getParameter("userPw");

        if (userId == null || userId.trim().isEmpty() || userPw == null || userPw.trim().isEmpty()) {
            throw new LoginException("IDまたはパスワードを入力してください。");
        }

        MemberDto member = authDao.login(userId);

        if (member == null || !PasswordUtil.checkPassword(userPw, member.getUserPw())) {
            throw new LoginException("IDまたはパスワードが正しくありません。");
        }

        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        HttpSession session = request.getSession(true);

        LoginUserDto user = new LoginUserDto(
            member.getMemberId(),
            member.getUserId(),
            member.getUserName(),
            member.getUserGrade()
        );

        session.setAttribute("user", user);
    }
}