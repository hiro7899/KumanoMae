package com.jsl.service;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.board.BoardDao;
import com.jsl.dao.board.BoardFileDao;
import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.dao.community.CommunityFileDao;
import com.jsl.dto.board.BoardDto;
import com.jsl.dto.community.CommunityBoardDto;

public class IndexService implements Command {

    private static final int MAIN_LIST_LIMIT = 3;

    private final BoardDao boardDao = new BoardDao();
    private final BoardFileDao boardFileDao = new BoardFileDao();
    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final CommunityFileDao communityFileDao = new CommunityFileDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        List<BoardDto> boardList = boardDao.selectRecentApproved(MAIN_LIST_LIMIT);
        for (BoardDto board : boardList) {
            board.setThumbnailUrl(boardFileDao.selectFirstFileUrl(board.getBoardId()));
        }

        List<CommunityBoardDto> communityList = communityBoardDao.selectRecentActive(MAIN_LIST_LIMIT);
        for (CommunityBoardDto community : communityList) {
            community.setThumbnailUrl(communityFileDao.selectFirstFileUrl(community.getCBoardId()));
        }

        request.setAttribute("boardList", boardList);
        request.setAttribute("communityList", communityList);
    }
}