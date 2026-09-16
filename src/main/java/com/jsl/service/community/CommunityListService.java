package com.jsl.service.community;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.dao.community.CommunityFileDao;
import com.jsl.dto.community.CommunityBoardDto;
import com.jsl.service.Command;

public class CommunityListService implements Command {

    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final CommunityFileDao communityFileDao = new CommunityFileDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String category = request.getParameter("category");
        if ("all".equals(category)) category = null;

        List<CommunityBoardDto> communityList = communityBoardDao.selectList(category);

        for (CommunityBoardDto community : communityList) {
            community.setThumbnailUrl(communityFileDao.selectFirstFileUrl(community.getCBoardId()));
        }

        request.setAttribute("communityList", communityList);
        request.setAttribute("currentCategory", category);
    }
}