package com.jsl.service.admin;

import java.io.IOException;
import java.time.LocalDateTime;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.member.MemberDao;
import com.jsl.dao.board.BoardDao;
import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.service.Command;

public class AdminMainService implements Command {

    private final BoardDao boardDao = new BoardDao();
    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final MemberDao memberDao = new MemberDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setAttribute("pendingCount", boardDao.countByStatus("W"));
        request.setAttribute("activeDangerCount", boardDao.countActiveDanger());
        request.setAttribute("totalCommunityCount", communityBoardDao.countActive());
        request.setAttribute("totalMemberCount", memberDao.countActive());
        request.setAttribute("dashboardUpdatedAt", LocalDateTime.now());
    }
}