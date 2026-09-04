package com.jsl.service.member;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.AuthDao;
import com.jsl.dao.EmailTokenDao;
import com.jsl.dto.EmailTokenDto;
import com.jsl.service.Command;
import com.jsl.util.DBManager;
import com.jsl.util.JsonResponseUtil;

public class EmailVerifyService implements Command {

    private final EmailTokenDao emailTokenDao = new EmailTokenDao();
    private final AuthDao authDao = new AuthDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String token = request.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            JsonResponseUtil.writeError(response, 400, "認証リンクが正しくありません。");
            return;
        }

        try (Connection conn = DBManager.getConnection()) {
            try {
                conn.setAutoCommit(false);

                EmailTokenDto tokenDto = emailTokenDao.findValidToken(conn, token, "SIGNUP_VERIFY");
                if (tokenDto == null) {
                    JsonResponseUtil.writeError(response, 400, "認証リンクが無効か、期限切れです。");
                    conn.rollback();
                    return;
                }

                authDao.updateEmailVerified(conn, tokenDto.getMemberId(), "Y");
                emailTokenDao.markUsed(conn, tokenDto.getTokenId());

                conn.commit();
                JsonResponseUtil.writeSuccess(response);

            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException rollbackEx) { e.addSuppressed(rollbackEx); }
                throw new RuntimeException("メール認証処理中にエラーが発生しました。", e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("データベースへの接続に失敗しました。", e);
        }
    }
}