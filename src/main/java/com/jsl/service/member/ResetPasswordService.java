package com.jsl.service.member;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.AuthDao;
import com.jsl.dao.EmailTokenDao;
import com.jsl.dto.EmailTokenDto;
import com.jsl.exeption.EmailTokenException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;
import com.jsl.util.PasswordUtil;

public class ResetPasswordService implements Command {

    private final EmailTokenDao emailTokenDao = new EmailTokenDao();
    private final AuthDao authDao = new AuthDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String token = request.getParameter("token");
        String newPw = request.getParameter("newPw");
        String newPwConfirm = request.getParameter("newPwConfirm");

        if (newPw == null || newPw.trim().length() < 8) {
            throw new EmailTokenException("パスワードは8文字以上で入力してください。");
        }
        if (!newPw.equals(newPwConfirm)) {
            throw new EmailTokenException("パスワードが一致しません。");
        }

        if (token == null || token.trim().isEmpty()) {
            throw new EmailTokenException("リンクが正しくありません。");
        }

        try (Connection conn = DBManager.getConnection()) {
            try {
                conn.setAutoCommit(false);

                EmailTokenDto tokenDto = emailTokenDao.findValidToken(conn, token, "PASSWORD_RESET");
                if (tokenDto == null) {
                    throw new EmailTokenException("リンクが無効か、期限切れです。もう一度お試しください。");
                }

                authDao.updatePassword(conn, tokenDto.getMemberId(), PasswordUtil.hashPassword(newPw));
                emailTokenDao.markUsed(conn, tokenDto.getTokenId());

                conn.commit();

            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException rollbackEx) { e.addSuppressed(rollbackEx); }
                throw new RuntimeException("パスワード再設定処理中にエラーが発生しました。", e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("データベースへの接続に失敗しました。", e);
        }
    }
}