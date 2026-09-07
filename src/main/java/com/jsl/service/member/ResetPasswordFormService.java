package com.jsl.service.member;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.EmailTokenDao;
import com.jsl.dto.EmailTokenDto;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class ResetPasswordFormService implements Command {

    private final EmailTokenDao emailTokenDao = new EmailTokenDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String token = request.getParameter("token");
        boolean valid = false;

        if (token != null && !token.trim().isEmpty()) {
            try (Connection conn = DBManager.getConnection()) {
                EmailTokenDto tokenDto = emailTokenDao.findValidToken(conn, token, "PASSWORD_RESET");
                valid = (tokenDto != null);
            } catch (SQLException e) {
                throw new RuntimeException("トークン確認中にエラーが発生しました。", e);
            }
        }

        request.setAttribute("token", token);
        request.setAttribute("tokenValid", valid);
    }
}