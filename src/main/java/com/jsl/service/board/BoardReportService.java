package com.jsl.service.board;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.jsl.dao.board.BoardDao;
import com.jsl.dao.board.BoardFileDao;
import com.jsl.dto.board.BoardDto;
import com.jsl.dto.board.BoardFileDto;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.BoardReportException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class BoardReportService implements Command {

    private static final int MAX_FILE_COUNT = 3;
    private static final String UPLOAD_ROOT = "D:/upload";
    private static final String BOARD_UPLOAD_DIR = "/board";
    private static final String BOARD_WEB_PATH = "/uploads/board";

    private final BoardDao boardDao = new BoardDao();
    private final BoardFileDao boardFileDao = new BoardFileDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        HttpSession session = request.getSession(false);

        // TODO: 세션에 실제로 저장된 로그인 객체 타입에 맞춰 캐스팅 수정

        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("user");
        Long memberId = loginUser.getMemberId();

        BoardDto board = buildBoardDto(request, memberId);

        // 첨부파일 파트만 추려내기 (input name="photoFile" 기준, 빈 파일 제외)
        List<Part> fileParts = new ArrayList<Part>();
        for (Part part : request.getParts()) {
            if ("photoFile".equals(part.getName()) && part.getSize() > 0) {
                fileParts.add(part);
            }
        }

        if (fileParts.size() > MAX_FILE_COUNT) {
            throw new BoardReportException("写真は最大" + MAX_FILE_COUNT + "枚まで添付できます。");
        }

        File uploadFolder = new File(UPLOAD_ROOT + BOARD_UPLOAD_DIR);

        if (!uploadFolder.exists() && !uploadFolder.mkdirs()) {
            throw new IOException("アップロードフォルダの作成に失敗しました。");
        }

        List<BoardFileDto> fileList = new ArrayList<BoardFileDto>();
        List<File> savedFiles = new ArrayList<File>(); // 실패 시 삭제 대상

        try {
            // 1) 실제 파일 저장 (DB 작업 이전)
            for (Part part : fileParts) {
                String originName = part.getSubmittedFileName();
                String ext = extractExtension(originName);
                String saveName = UUID.randomUUID().toString() + ext;

                File target = new File(uploadFolder, saveName);
                try (InputStream in = part.getInputStream()) {
                    Files.copy(in, target.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
                savedFiles.add(target);

                BoardFileDto fileDto = new BoardFileDto();
                fileDto.setOriginName(originName);
                fileDto.setSaveName(saveName);
                fileDto.setFilePath(BOARD_WEB_PATH);
                fileDto.setFileSize((int) part.getSize());
                fileList.add(fileDto);
            }

            // 2) BOARD + BOARD_FILE 트랜잭션
            try (Connection conn = DBManager.getConnection()) {
                try {
                    conn.setAutoCommit(false);

                    Long boardId = boardDao.insertReport(conn, board);

                    for (BoardFileDto fileDto : fileList) {
                        fileDto.setBoardId(boardId);
                        boardFileDao.insertFile(conn, fileDto);
                    }

                    conn.commit();

                } catch (SQLException e) {
                    conn.rollback();
                    throw new RuntimeException("通報の登録処理中にエラーが発生しました。", e);
                }
            } catch (SQLException e) {
            	throw new RuntimeException("データベースへの接続に失敗しました。", e);
            }

        } catch (IOException | RuntimeException e) {
            // 파일 저장 성공 + DB 실패(또는 파일 저장 도중 실패) → 이번 요청에서 만든 파일만 정리
            for (File f : savedFiles) {
                f.delete();
            }
            if (e instanceof IOException) {
                throw (IOException) e;
            }
            throw (RuntimeException) e;
        }
    }

    private BoardDto buildBoardDto(HttpServletRequest request, Long memberId) {
        try {
            BoardDto board = new BoardDto();
            board.setMemberId(memberId);
            board.setTitle(require(request, "title"));
            board.setContent(require(request, "content"));
            board.setRiskLevel(require(request, "riskLevel"));
            board.setLatitude(Double.parseDouble(require(request, "latitude")));
            board.setLongitude(Double.parseDouble(require(request, "longitude")));
            board.setAddress(request.getParameter("address")); // 선택값
            board.setSightingDate(LocalDateTime.parse(require(request, "sightingDate")));
            board.setSituationTag(request.getParameter("situationTag")); // 선택값
            // status / clearYn / clearDate / clearMemo / viewCnt 는 절대 요청값에서 읽지 않음
            return board;

        } catch (NumberFormatException e) {
        	throw new BoardReportException("緯度・経度の値が正しくありません。");
        } catch (DateTimeParseException e) {
        	throw new BoardReportException("目撃日時の形式が正しくありません。");
        }
    }

    private String require(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()) {
        	throw new BoardReportException(name + "は必須項目です。");
        }
        return value;
    }

    private String extractExtension(String originName) {
        if (originName == null) return "";
        int dot = originName.lastIndexOf('.');
        return (dot != -1) ? originName.substring(dot) : "";
    }
}