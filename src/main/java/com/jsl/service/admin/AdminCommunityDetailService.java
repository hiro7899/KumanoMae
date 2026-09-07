package com.jsl.service.admin;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.dao.community.CommunityCommentDao;
import com.jsl.dao.community.CommunityFileDao;
import com.jsl.dto.community.CommunityBoardDto;
import com.jsl.exeption.AdminActionException;
import com.jsl.service.Command;

public class AdminCommunityDetailService implements Command {
    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final CommunityFileDao communityFileDao = new CommunityFileDao();
    private final CommunityCommentDao communityCommentDao = new CommunityCommentDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long cBoardId = AdminServiceSupport.parseId(request, "cBoardId");

        CommunityBoardDto dto = communityBoardDao.selectByIdForAdmin(cBoardId);
        if (dto == null) {
            throw new AdminActionException("存在しない投稿です。");
        }

        request.setAttribute("communityBoard", dto);
        request.setAttribute("fileList", communityFileDao.selectFilesByBoardId(cBoardId));
        request.setAttribute("commentList", communityCommentDao.selectByBoardId(cBoardId));
    }
}