package com.jsl.service.community;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.service.Command;

public class CommunityListService implements Command {
    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String category = request.getParameter("category"); // null 또는 "all"이면 전체
        if ("all".equals(category)) category = null;

        request.setAttribute("communityList", communityBoardDao.selectList(category));
        request.setAttribute("currentCategory", category);
    }
}