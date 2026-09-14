package com.jsl.service.member;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.AuthDao;
import com.jsl.dto.member.MemberDto;
import com.jsl.exeption.FindIdException;
import com.jsl.service.Command;

public class FindIdService implements Command {

    private final AuthDao authDao = new AuthDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            throw new FindIdException("メールアドレスを入力してください。");
        }

        email = email.trim();

        if (!isValidEmail(email)) {
            throw new FindIdException("正しいメールアドレスを入力してください。");
        }

        MemberDto member = authDao.findByEmail(email);

        if (member == null) {
            throw new FindIdException("登録されていないメールアドレスです。");
        }

        request.setAttribute("foundUserId", maskUserId(member.getUserId()));
    }

    private boolean isValidEmail(String email) {
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }

    private String maskUserId(String userId) {

        if (userId == null || userId.isEmpty()) {
            return "";
        }

        if (userId.length() <= 2) {
            return userId.charAt(0)
                    + "*".repeat(Math.max(0, userId.length() - 1));
        }

        String visible = userId.substring(0, 2);
        String masked = "*".repeat(userId.length() - 2);

        return visible + masked;
    }
}