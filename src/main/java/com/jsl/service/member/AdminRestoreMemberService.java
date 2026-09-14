package com.jsl.service.member;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.member.MemberDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.AdminActionException;
import com.jsl.exeption.MemberManageException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class AdminRestoreMemberService implements Command {

    private final MemberDao memberDao = new MemberDao();

    @Override
    public void doCommand(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);

        LoginUserDto user = (session != null)
                ? (LoginUserDto) session.getAttribute("user")
                : null;

        if (user == null || !"A".equals(user.getUserGrade())) {
            throw new AdminActionException(
                    "管理者権限が必要です。"
            );
        }

        String memberIdParam = request.getParameter("memberId");

        if (memberIdParam == null || memberIdParam.trim().isEmpty()) {
            throw new MemberManageException(
                    "会員情報が指定されていません。"
            );
        }

        Long memberId;

        try {
            memberId = Long.parseLong(memberIdParam.trim());
        } catch (NumberFormatException e) {
            throw new MemberManageException(
                    "正しい会員情報を指定してください。"
            );
        }

        try (Connection conn = DBManager.getConnection()) {

            String status = memberDao.findStatus(conn, memberId);

            if (status == null) {
                throw new MemberManageException(
                        "会員が存在しません。"
                );
            }

            if ("Y".equals(status)) {
                throw new MemberManageException(
                        "すでに利用中の会員です。"
                );
            }

            if (!"N".equals(status)) {
                throw new MemberManageException(
                        "利用停止を解除できません。"
                );
            }

            int result = memberDao.restoreMember(conn, memberId);

            if (result == 0) {
                throw new MemberManageException(
                        "利用停止を解除できません。"
                );
            }

        } catch (SQLException e) {
            throw new AdminActionException(
                    "利用停止の解除中にエラーが発生しました。",
                    e
            );
        }
    }
}