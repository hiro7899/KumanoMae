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

        String userName = request.getParameter("userName");
        String email = request.getParameter("email");

        if (userName == null || userName.trim().isEmpty()) {
            throw new FindIdException("お名前を入力してください。");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new FindIdException("メールアドレスを入力してください。");
        }

        MemberDto member = authDao.findByNameAndEmail(userName.trim(), email.trim());

        if (member == null) {
            throw new FindIdException("入力された情報と一致する会員が見つかりません。");
        }

        request.setAttribute("foundUserId", maskUserId(member.getUserId()));
    }

    /** 앞 2자만 노출, 나머지는 전부 마스킹. 예: "hiro7899" → "hi******" */
    private String maskUserId(String userId) {
        if (userId.length() <= 2) {
            return userId.charAt(0) + "*".repeat(Math.max(0, userId.length() - 1));
        }
        String visible = userId.substring(0, 2);
        String masked = "*".repeat(userId.length() - 2);
        return visible + masked;
    }
}