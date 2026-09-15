package com.jsl.service.map;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.board.BoardDao;
import com.jsl.service.Command;

public class MapBoardListService implements Command {

    private static final int MAP_LIST_LIMIT = 20;

    private final BoardDao boardDao = new BoardDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setAttribute("boardList", boardDao.selectRecentApproved(MAP_LIST_LIMIT));
    }
}