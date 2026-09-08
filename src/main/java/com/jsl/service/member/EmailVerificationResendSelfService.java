package com.jsl.service.member;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.AuthDao;
import com.jsl.dao.EmailTokenDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.dto.member.MemberDto;
import com.jsl.service.Command;
import com.jsl.util.DBManager;
import com.jsl.util.EmailUtil;
import com.jsl.util.JsonResponseUtil;

public class EmailVerificationResendSelfService implements Command {

    private final AuthDao authDao = new AuthDao();
    private final EmailTokenDao emailTokenDao = new EmailTokenDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        LoginUserDto loginUser = (session != null) ? (LoginUserDto) session.getAttribute("user") : null;
        if (loginUser == null) {
            JsonResponseUtil.writeError(response, 401, "ログインが必要です。");
            return;
        }

        MemberDto member = authDao.findById(loginUser.getMemberId());
        if (member == null) {
            JsonResponseUtil.writeError(response, 400, "会員情報が見つかりません。");
            return;
        }

        if ("Y".equals(member.getEmailVerifiedYn())) {
            JsonResponseUtil.writeError(response, 400, "既にメール認証が完了しています。");
            return;
        }

        try (Connection conn = DBManager.getConnection()) {
            conn.setAutoCommit(false);
            try {
                String token = UUID.randomUUID().toString();
                emailTokenDao.insertToken(conn, member.getMemberId(), token, "SIGNUP_VERIFY",
                        LocalDateTime.now().plusHours(24));
                conn.commit();

                String verifyUrl = baseUrl(request) + "/verify-email?token=" + token;
                EmailUtil.send(member.getEmail(), "【KumanoMae】メール認証のお願い",
                        "<p>下記リンクをクリックして認証を完了してください（24時間有効）。</p>"
                        + "<p><a href=\"" + verifyUrl + "\">" + verifyUrl + "</a></p>");

                JsonResponseUtil.writeSuccess(response);

            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException rollbackEx) { e.addSuppressed(rollbackEx); }
                throw new RuntimeException("再送信処理中にエラーが発生しました。", e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("データベースへの接続に失敗しました。", e);
        }
    }

    private String baseUrl(HttpServletRequest request) {
        return request.getScheme() + "://" + request.getServerName()
                + (request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort());
    }
}