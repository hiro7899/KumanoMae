package com.jsl.service.admin;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.AdminActionException;

public class AdminServiceSupport {

    public static LoginUserDto getLoginAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        LoginUserDto admin = (session != null) ? (LoginUserDto) session.getAttribute("user") : null;
        if (admin == null) {
            throw new AdminActionException("ログインが必要です。");
        }
        return admin;
    }

    public static Long parseId(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        if (value == null || value.trim().isEmpty()) {
            throw new AdminActionException(paramName + "は必須です。");
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            throw new AdminActionException(paramName + "の形式が正しくありません。");
        }
    }
}