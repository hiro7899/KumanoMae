package com.jsl.service.board;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.board.BoardDao;
import com.jsl.dto.board.BoardDto;
import com.jsl.service.Command;

public class BoardListService implements Command {

    private final BoardDao boardDao = new BoardDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<BoardDto> boardList = boardDao.selectApprovedBoard();

        request.setAttribute("boardList", boardList);
    }
}