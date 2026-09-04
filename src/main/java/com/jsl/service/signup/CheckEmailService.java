package com.jsl.service.signup;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.AuthDao;
import com.jsl.service.Command;
import com.jsl.util.JsonResponseUtil;

public class CheckEmailService implements Command {

    private final AuthDao authDao = new AuthDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            JsonResponseUtil.writeError(response, 400, "メールアドレスを入力してください。");
            return;
        }
        boolean exists = authDao.existsEmail(email);
        JsonResponseUtil.writeSuccess(response, "available", !exists);
    }
}