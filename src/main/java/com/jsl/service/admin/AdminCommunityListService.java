package com.jsl.service.admin;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.service.Command;

public class AdminCommunityListService implements Command {
    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String status = request.getParameter("status"); // null/all/"Y"/"N" 필터 - 선택
        request.setAttribute("communityList", communityBoardDao.selectAllForAdmin(status));
    }
}