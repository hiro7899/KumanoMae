package com.jsl.service.member;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.AuthDao;
import com.jsl.dto.member.MemberDto;
import com.jsl.service.Command;
import com.jsl.util.JsonResponseUtil;

public class EmailVerificationStatusService implements Command {

    private final AuthDao authDao = new AuthDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String email = request.getParameter("email"); // ★ GET 쿼리스트링이므로 JsonRequestUtil 안 씀

        if (email == null || email.trim().isEmpty()) {
            JsonResponseUtil.writeError(response, 400, "メールアドレスが指定されていません。");
            return;
        }

        MemberDto member = authDao.findByEmail(email);

        // 존재하지 않는 이메일이어도 계정 존재 여부를 추측 못 하게 verified:false로 동일하게 응답
        boolean verified = member != null && "Y".equals(member.getEmailVerifiedYn());

        JsonResponseUtil.writeVerified(response, verified);
    }
}