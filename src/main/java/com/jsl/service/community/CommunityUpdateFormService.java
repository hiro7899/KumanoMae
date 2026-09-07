package com.jsl.service.community;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.dao.community.CommunityFileDao;
import com.jsl.dto.community.CommunityBoardDto;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.CommunityException;
import com.jsl.service.Command;

/** GET /community/update - 수정 폼 채우기용 (작성 완료가 아니라 조회만) */
public class CommunityUpdateFormService implements Command {

    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final CommunityFileDao communityFileDao = new CommunityFileDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        LoginUserDto loginUser = (session != null) ? (LoginUserDto) session.getAttribute("user") : null;
        if (loginUser == null) {
            throw new CommunityException("ログインが必要です。");
        }

        Long cBoardId = parseId(request);
        CommunityBoardDto dto = communityBoardDao.selectById(cBoardId);
        if (dto == null) {
            throw new CommunityException("存在しない投稿です。");
        }

        boolean isOwner = dto.getMemberId().equals(loginUser.getMemberId());
        boolean isAdmin = "A".equals(loginUser.getUserGrade());
        if (!isOwner && !isAdmin) {
            throw new CommunityException("修正権限がありません。");
        }

        request.setAttribute("communityBoard", dto);
        request.setAttribute("fileList", communityFileDao.selectFilesByBoardId(cBoardId));
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