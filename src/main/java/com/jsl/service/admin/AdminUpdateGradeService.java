package com.jsl.service.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.admin.AdminLogDao;
import com.jsl.dao.member.MemberDao;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.AdminActionException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class AdminUpdateGradeService implements Command {

    private static final Set<String> VALID_GRADES = Set.of("M", "A");

    private final MemberDao memberDao = new MemberDao();
    private final AdminLogDao adminLogDao = new AdminLogDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        LoginUserDto admin = getLoginAdmin(request);
        Long targetMemberId = parseMemberId(request);
        String newGrade = request.getParameter("grade");

        if (newGrade == null || !VALID_GRADES.contains(newGrade)) {
            throw new AdminActionException("会員等級の値が正しくありません。");
        }

        // ★ 관리자가 자기 자신의 등급을 낮춰서 스스로 관리자 페이지에 못 들어가게 되는 상황 방지
        if (targetMemberId.equals(admin.getMemberId()) && !"A".equals(newGrade)) {
            throw new AdminActionException("自分自身の管理者権限は解除できません。");
        }

        try (Connection conn = DBManager.getConnection()) {
            try {
                conn.setAutoCommit(false);

                String currentStatus = memberDao.findStatus(conn, targetMemberId);
                if (currentStatus == null) {
                    throw new AdminActionException("存在しない会員です。");
                }
                if ("N".equals(currentStatus)) {
                    throw new AdminActionException("退会した会員の等級は変更できません。");
                }

                String currentGrade = memberDao.findGrade(conn, targetMemberId);
                if (newGrade.equals(currentGrade)) {
                    throw new AdminActionException("既に同じ等級です。");
                }

                memberDao.updateGrade(conn, targetMemberId, newGrade);
                adminLogDao.insertLog(conn, admin.getMemberId(), "MEMBER", targetMemberId,
                        "UPDATE_GRADE", "grade -> " + newGrade);

                conn.commit();

            } catch (SQLException e) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    e.addSuppressed(rollbackEx);
                }
                throw new RuntimeException("等級変更処理中にエラーが発生しました。", e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("データベースへの接続に失敗しました。", e);
        }
    }

    private LoginUserDto getLoginAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        LoginUserDto admin = (session != null) ? (LoginUserDto) session.getAttribute("user") : null;
        if (admin == null) {
            throw new AdminActionException("ログインが必要です。");
        }
        return admin;
    }

    private Long parseMemberId(HttpServletRequest request) {
        String value = request.getParameter("memberId");
        if (value == null || value.trim().isEmpty()) {
            throw new AdminActionException("memberIdは必須です。");
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            throw new AdminActionException("memberIdの形式が正しくありません。");
        }
    }
}