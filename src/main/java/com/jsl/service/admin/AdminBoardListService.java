package com.jsl.service.admin;

import java.io.IOException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.board.BoardDao;
import com.jsl.dao.board.BoardFileDao;
import com.jsl.dto.board.BoardDto;
import com.jsl.service.Command;

public class AdminBoardListService implements Command {

    private final BoardDao boardDao = new BoardDao();
    private final BoardFileDao boardFileDao = new BoardFileDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String status = request.getParameter("status");
        String clearYn = request.getParameter("clearYn");
        String keyword = request.getParameter("keyword");

        List<BoardDto> boardList = boardDao.selectAllBoard(status, clearYn, keyword);

        for (BoardDto board : boardList) {
            board.setThumbnailUrl(boardFileDao.selectFirstFileUrl(board.getBoardId()));
        }

        request.setAttribute("boardList", boardList);
    }
}