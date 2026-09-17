package com.jsl.service.user;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.board.BoardDao;
import com.jsl.dao.board.BoardFileDao;
import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.dao.community.CommunityFileDao;
import com.jsl.dto.board.BoardDto;
import com.jsl.dto.board.BoardFileDto;
import com.jsl.dto.community.CommunityBoardDto;
import com.jsl.dto.community.CommunityFileDto;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.service.Command;

public class UserPostsService implements Command {

    private final BoardDao boardDao = new BoardDao();
    private final BoardFileDao boardFileDao = new BoardFileDao();
    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final CommunityFileDao communityFileDao = new CommunityFileDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);
        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("user");
        Long memberId = loginUser.getMemberId();

        List<BoardDto> boardList = boardDao.selectByMemberId(memberId);
        for (BoardDto board : boardList) {
            List<BoardFileDto> files = boardFileDao.selectFilesByBoardId(board.getBoardId());
            board.setFileList(files);
            board.setThumbnailUrl(files.isEmpty() ? null
                    : files.get(0).getFilePath() + "/" + files.get(0).getSaveName());
        }

        List<CommunityBoardDto> communityList = communityBoardDao.selectByMemberId(memberId);
        for (CommunityBoardDto community : communityList) {
            List<CommunityFileDto> files = communityFileDao.selectFilesByBoardId(community.getCBoardId());
            community.setFileList(files);
            community.setThumbnailUrl(files.isEmpty() ? null
                    : files.get(0).getFilePath() + "/" + files.get(0).getSaveName());
        }

        request.setAttribute("boardList", boardList);
        request.setAttribute("communityList", communityList);
    }
}