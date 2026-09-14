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

public class ForgotPasswordService implements Command {

    private final AuthDao authDao = new AuthDao();
    private final EmailTokenDao emailTokenDao = new EmailTokenDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String userId = request.getParameter("userId");
        String email = request.getParameter("email");

        if (userId == null || userId.trim().isEmpty()) {
            request.setAttribute("errorField", "userId");
            request.setAttribute("errorMsg", "IDを入力してください。");
            return;
        }

        userId = userId.trim();

        MemberDto member = authDao.findByUserId(userId);

        if (member == null) {
            request.setAttribute("errorField", "userId");
            request.setAttribute("errorMsg", "登録されていないIDです。");
            return;
        }

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("errorField", "email");
            request.setAttribute("errorMsg", "正しいメールアドレスを入力してください。");
            return;
        }

        email = email.trim();

        if (!isValidEmail(email)) {
            request.setAttribute("errorField", "email");
            request.setAttribute("errorMsg", "正しいメールアドレスを入力してください。");
            return;
        }

        if (!email.equalsIgnoreCase(member.getEmail())) {
            request.setAttribute("errorField", "email");
            request.setAttribute("errorMsg", "登録されていないメールアドレスです。");
            return;
        }

        try (Connection conn = DBManager.getConnection()) {

            conn.setAutoCommit(false);

            String token = UUID.randomUUID().toString();

            emailTokenDao.insertToken(
                    conn,
                    member.getMemberId(),
                    token,
                    "PASSWORD_RESET",
                    LocalDateTime.now().plusHours(1)
            );

            conn.commit();

            String resetUrl = baseUrl(request)
                    + "/reset-password?token=" + token;

            EmailUtil.send(
                    email,
                    "【KumanoMae】パスワード再設定のご案内",
                    "<p>下記リンクからパスワードを再設定してください（1時間有効）。</p>"
                    + "<p><a href=\"" + resetUrl + "\">"
                    + resetUrl
                    + "</a></p>"
            );

            request.setAttribute(
                    "resultMsg",
                    "入力されたメールアドレス宛に再設定用のリンクを送信しました。"
            );

        } catch (SQLException e) {
            throw new RuntimeException("処理中にエラーが発生しました。", e);
        }
    }

    /**
     * 이메일 형식 확인
     */
    private boolean isValidEmail(String email) {
        return email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }

    private String baseUrl(HttpServletRequest request) {
        return request.getScheme() + "://"
                + request.getServerName()
                + (request.getServerPort() == 80 || request.getServerPort() == 443
                        ? ""
                        : ":" + request.getServerPort());
    }
}