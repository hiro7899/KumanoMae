package com.jsl.service.login;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.AuthDao;
import com.jsl.service.Command;

public class CheckUserIdService implements Command {

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String userId = request.getParameter("userId");

        AuthDao dao = new AuthDao();

        if (dao.existsUserId(userId)) {
            response.getWriter().write("duplicate");
        } else {
            response.getWriter().write("available");
        }
    }
}