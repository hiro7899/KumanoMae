package com.jsl.service.member;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.AuthDao;
import com.jsl.dao.EmailTokenDao;
import com.jsl.dto.member.MemberDto;
import com.jsl.service.Command;
import com.jsl.util.DBManager;
import com.jsl.util.EmailUtil;
import com.jsl.util.JsonResponseUtil;

public class EmailVerificationSendService implements Command {

    private final AuthDao authDao = new AuthDao();
    private final EmailTokenDao emailTokenDao = new EmailTokenDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            JsonResponseUtil.writeError(response, 400, "メールアドレスを入力してください。");
            return;
        }

        MemberDto member = authDao.findByEmail(email);

        // ★ 계정 존재 여부를 추측할 수 없도록, 존재하지 않아도 같은 성공 응답을 준다
        if (member != null && !"Y".equals(member.getEmailVerifiedYn())) {
            try (Connection conn = DBManager.getConnection()) {
                conn.setAutoCommit(false);

                String token = UUID.randomUUID().toString();
                emailTokenDao.insertToken(conn, member.getMemberId(), token, "SIGNUP_VERIFY",
                        LocalDateTime.now().plusHours(24));
                conn.commit();

                String verifyUrl = baseUrl(request) + "/verify-email?token=" + token;
                EmailUtil.send(email, "【KumanoMae】メール認証のお願い",
                        "<p>下記リンクをクリックして会員登録を完了してください（24時間有効）。</p>"
                        + "<p><a href=\"" + verifyUrl + "\">" + verifyUrl + "</a></p>");

            } catch (SQLException e) {
                throw new RuntimeException("メール再送信中にエラーが発生しました。", e);
            }
        }

        JsonResponseUtil.writeSuccess(response);
    }

    private String baseUrl(HttpServletRequest request) {
        return request.getScheme() + "://" + request.getServerName()
                + (request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort());
    }
}