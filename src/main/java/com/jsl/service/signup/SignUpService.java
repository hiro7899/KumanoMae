package com.jsl.service.signup;

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
import com.jsl.exeption.SignUpException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;
import com.jsl.util.EmailUtil;
import com.jsl.util.PasswordUtil;

public class SignUpService implements Command {

    private final AuthDao authDao = new AuthDao();
    private final EmailTokenDao emailTokenDao = new EmailTokenDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        MemberDto member = new MemberDto();
        member.setUserId(request.getParameter("userId"));
        member.setUserPw(PasswordUtil.hashPassword(request.getParameter("userPw")));
        member.setUserName(request.getParameter("userName"));
        member.setEmail(request.getParameter("email"));
        member.setPhone(request.getParameter("phone"));

        try (Connection conn = DBManager.getConnection()) {
            try {
                conn.setAutoCommit(false);

                Long memberId = authDao.signUp(conn, member);

                String token = UUID.randomUUID().toString();
                emailTokenDao.insertToken(conn, memberId, token, "SIGNUP_VERIFY",
                        LocalDateTime.now().plusHours(24));

                conn.commit();

                String verifyUrl = baseUrl(request) + "/verify-email?token=" + token;
                EmailUtil.send(member.getEmail(), "【KumanoMae】メール認証のお願い",
                        "<p>下記リンクをクリックして会員登録を完了してください（24時間有効）。</p>"
                        + "<p><a href=\"" + verifyUrl + "\">" + verifyUrl + "</a></p>");

            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException rollbackEx) { e.addSuppressed(rollbackEx); }
                throw new SignUpException("会員登録処理中にエラーが発生しました。", e);
            }
        } catch (SQLException e) {
            throw new SignUpException("データベースへの接続に失敗しました。", e);
        }
    }

    private String baseUrl(HttpServletRequest request) {
        return request.getScheme() + "://" + request.getServerName()
                + (request.getServerPort() == 80 || request.getServerPort() == 443 ? "" : ":" + request.getServerPort());
        // ROOT 컨텍스트 배포 전제이므로 contextPath는 붙이지 않음
    }
}