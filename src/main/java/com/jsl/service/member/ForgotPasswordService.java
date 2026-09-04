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

        String email = request.getParameter("email");
        MemberDto member = authDao.findByEmail(email); // 신규 메서드 - AuthDao에 추가 필요

        // ★ 존재하지 않는 이메일이어도 "발송했습니다"로 동일하게 응답 (이메일 존재 여부로 회원 유무 추측 불가하게)
        if (member != null) {
            try (Connection conn = DBManager.getConnection()) {
                conn.setAutoCommit(false);
                String token = UUID.randomUUID().toString();
                emailTokenDao.insertToken(conn, member.getMemberId(), token, "PASSWORD_RESET",
                        LocalDateTime.now().plusHours(1)); // 비밀번호 재설정은 1시간으로 짧게
                conn.commit();

                String resetUrl = baseUrl(request) + "/reset-password?token=" + token;
                EmailUtil.send(email, "【KumanoMae】パスワード再設定のご案内",
                        "<p>下記リンクからパスワードを再設定してください（1時間有効）。</p>"
                        + "<p><a href=\"" + resetUrl + "\">" + resetUrl + "</a></p>");

            } catch (SQLException e) {
                throw new RuntimeException("処理中にエラーが発生しました。", e);
            }
        }

        request.setAttribute("resultMsg", "入力されたメールアドレス宛に再設定用のリンクを送信しました。");
    }

    private String baseUrl(HttpServletRequest request) {
        return request.getScheme() + "://" + request.getServerName()
                + (request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort());
    }
}