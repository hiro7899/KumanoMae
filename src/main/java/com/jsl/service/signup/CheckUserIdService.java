package com.jsl.service.signup;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.AuthDao;
import com.jsl.dto.api.UserIdRequest;
import com.jsl.service.Command;
import com.jsl.util.JsonRequestUtil;
import com.jsl.util.JsonResponseUtil;

public class CheckUserIdService implements Command {

    private final AuthDao authDao = new AuthDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        UserIdRequest body = JsonRequestUtil.parseBody(request, UserIdRequest.class);
        String userId = body.getUserId();

        if (userId == null || userId.trim().isEmpty()) {
            JsonResponseUtil.writeError(response, 400, "ユーザーIDを入力してください。");
            return;
        }
        boolean exists = authDao.existsUserId(userId);
        JsonResponseUtil.writeSuccess(response, !exists);
    }
}