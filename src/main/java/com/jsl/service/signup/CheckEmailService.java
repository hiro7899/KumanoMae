package com.jsl.service.signup;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.AuthDao;
import com.jsl.dto.api.EmailRequest;
import com.jsl.service.Command;
import com.jsl.util.JsonRequestUtil;
import com.jsl.util.JsonResponseUtil;

public class CheckEmailService implements Command {

    private final AuthDao authDao = new AuthDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        EmailRequest body = JsonRequestUtil.parseBody(request, EmailRequest.class);
        String email = body.getEmail();

        if (email == null || email.trim().isEmpty()) {
            JsonResponseUtil.writeError(response, 400, "メールアドレスを入力してください。");
            return;
        }
        boolean exists = authDao.existsEmail(email);
        JsonResponseUtil.writeSuccess(response, !exists);
    }
}