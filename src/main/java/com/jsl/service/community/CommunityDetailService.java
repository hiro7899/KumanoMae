package com.jsl.service.community;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.dao.community.CommunityCommentDao;
import com.jsl.dao.community.CommunityFileDao;
import com.jsl.dao.community.CommunityLikeDao;
import com.jsl.dto.community.CommunityBoardDto;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.CommunityException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class CommunityDetailService implements Command {

    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final CommunityFileDao communityFileDao = new CommunityFileDao();
    private final CommunityCommentDao communityCommentDao = new CommunityCommentDao();
    private final CommunityLikeDao communityLikeDao = new CommunityLikeDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        Long cBoardId = parseId(request);

        CommunityBoardDto dto = communityBoardDao.selectById(cBoardId);
        if (dto == null) {
            throw new CommunityException("存在しない投稿です。");
        }

        communityBoardDao.increaseViewCnt(cBoardId);

        request.setAttribute("communityBoard", dto);
        request.setAttribute("fileList", communityFileDao.selectFilesByBoardId(cBoardId));
        request.setAttribute("commentList", communityCommentDao.selectByBoardId(cBoardId));

        HttpSession session = request.getSession(false);
        LoginUserDto loginUser = (session != null) ? (LoginUserDto) session.getAttribute("user") : null;

        if (loginUser != null) {
            try (Connection conn = DBManager.getConnection()) {
                boolean liked = communityLikeDao.exists(conn, cBoardId, loginUser.getMemberId());
                request.setAttribute("liked", liked);
            } catch (SQLException e) {
                throw new RuntimeException("いいね状態の確認中にエラーが発生しました。", e);
            }
        } else {
            request.setAttribute("liked", false);
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