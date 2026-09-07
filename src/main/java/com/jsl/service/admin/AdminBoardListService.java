package com.jsl.service.admin;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.board.BoardDao;
import com.jsl.service.Command;

public class AdminBoardListService implements Command {

    private final BoardDao boardDao = new BoardDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setAttribute("boardList", boardDao.selectAllBoard());
    }
}