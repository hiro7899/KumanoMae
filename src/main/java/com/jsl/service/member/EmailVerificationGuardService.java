package com.jsl.service.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.jsl.dao.AuthDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.dto.member.MemberDto;
import com.jsl.exeption.EmailNotVerifiedException;

/**
 * Command 인터페이스(doCommand 시그니처)를 따르지 않는 이유:
 * 이건 "요청을 처리"하는 게 아니라 "통과 가능 여부만 검사"하는 가드(guard)라서
 * void 반환 + boolean 결과가 더 명확함. 검증 실패 시 예외를 던져 Controller가 잡도록 함.
 */
public class EmailVerificationGuardService {

    private final AuthDao authDao = new AuthDao();

    /** 로그인 + 이메일 인증 완료 여부를 함께 검사. 실패 시 예외를 던짐 */
    public LoginUserDto checkVerified(HttpServletRequest request) {

        HttpSession session = request.getSession(false);
        LoginUserDto loginUser = (session != null) ? (LoginUserDto) session.getAttribute("user") : null;

        if (loginUser == null) {
            throw new EmailNotVerifiedException("LOGIN_REQUIRED", "ログインが必要です。");
        }

        MemberDto member = authDao.findById(loginUser.getMemberId());
        if (member == null || !"Y".equals(member.getEmailVerifiedYn())) {
            throw new EmailNotVerifiedException("EMAIL_NOT_VERIFIED", "メール認証が完了していません。");
        }

        return loginUser;
    }
}