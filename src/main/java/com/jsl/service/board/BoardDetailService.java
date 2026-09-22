package com.jsl.service.board;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jsl.dao.board.BoardDao;
import com.jsl.dao.board.BoardFileDao;
import com.jsl.dto.board.BoardDto;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exception.BoardException;
import com.jsl.service.Command;

public class BoardDetailService implements Command {

    private final BoardDao boardDao = new BoardDao();
    private final BoardFileDao boardFileDao = new BoardFileDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        Long boardId = parseId(request);
        BoardDto board = boardDao.selectById(boardId);

        if (board == null) {
            throw new BoardException("存在しない通報です。");
        }

        HttpSession session = request.getSession(false);
        LoginUserDto loginUser = (session != null) ? (LoginUserDto) session.getAttribute("user") : null;
        boolean isAdmin = loginUser != null && "A".equals(loginUser.getUserGrade());

        if (!"Y".equals(board.getStatus()) && !isAdmin) {
            throw new BoardException("公開されていない通報です。");
        }

        boardDao.increaseViewCnt(boardId);

        request.setAttribute("board", board);
        request.setAttribute("fileList", boardFileDao.selectFilesByBoardId(boardId));
    }

    private Long parseId(HttpServletRequest request) {
        String value = request.getParameter("boardId");
        if (value == null || value.trim().isEmpty()) {
            throw new BoardException("boardIdは必須です。");
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            throw new BoardException("boardIdの形式が正しくありません。");
        }
    }
}