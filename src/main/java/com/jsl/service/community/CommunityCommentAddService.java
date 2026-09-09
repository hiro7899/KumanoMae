package com.jsl.service.community;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.dao.community.CommunityCommentDao;
import com.jsl.dto.community.CommunityCommentDto;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.CommunityException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class CommunityCommentAddService implements Command {

    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final CommunityCommentDao communityCommentDao = new CommunityCommentDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            throw new CommunityException("ログインが必要です。");
        }
        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("user");

        Long cBoardId = parseId(request);
        String content = request.getParameter("content");
        if (content == null || content.trim().isEmpty()) {
            throw new CommunityException("コメント内容は必須です。");
        }

        try (Connection conn = DBManager.getConnection()) {
            String status = communityBoardDao.findStatus(conn, cBoardId);
            if (!"Y".equals(status)) {
                throw new CommunityException("削除された投稿にはコメントできません。");
            }

            CommunityCommentDto dto = new CommunityCommentDto();
            dto.setCBoardId(cBoardId);
            dto.setMemberId(loginUser.getMemberId());
            dto.setContent(content);

            communityCommentDao.insertComment(conn, dto);

        } catch (SQLException e) {
            throw new RuntimeException("コメント登録中にエラーが発生しました。", e);
        }
    }

    private Long parseId(HttpServletRequest request) {
        String value = request.getParameter("cBoardId");
        if (value == null || value.trim().isEmpty()) {
            throw new CommunityException("cBoardIdは必須です。");
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            throw new CommunityException("cBoardIdの形式が正しくありません。");
        }
    }
}