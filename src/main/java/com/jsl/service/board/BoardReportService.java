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
import java.util.Set;
import java.util.UUID;

import javax.servlet.ServletContext;
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
import com.jsl.util.UploadPathUtil;

public class BoardReportService implements Command {

    private static final int MAX_FILE_COUNT = 3;
    private static final String BOARD_SUBDIR = "/board"; // upload.dir 하위 폴더명

    private final BoardDao boardDao = new BoardDao();
    private final BoardFileDao boardFileDao = new BoardFileDao();

    private static final Set<String> VALID_RISK_LEVELS = Set.of("DANGER", "WARNING", "CAUTION");

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            throw new BoardReportException("ログインが必要です。");
        }
        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("user");
        Long memberId = loginUser.getMemberId();

        BoardDto board = buildBoardDto(request, memberId);

        List<Part> fileParts = new ArrayList<>();
        for (Part part : request.getParts()) {
            if ("photoFile".equals(part.getName()) && part.getSize() > 0) {
                fileParts.add(part);
            }
        }

        if (fileParts.size() > MAX_FILE_COUNT) {
            throw new BoardReportException("写真は最大" + MAX_FILE_COUNT + "枚まで添付できます。");
        }

        // ★ 물리 경로: 각자 PC의 Tomcat 배포 위치를 webapp 기준 상대경로로 자동 해석
        String webRelativeDir = UploadPathUtil.getUploadDir() + BOARD_SUBDIR; // /resources/img/uploads/board
        ServletContext ctx = request.getServletContext();
        File uploadFolder = new File(ctx.getRealPath(webRelativeDir));

        if (!uploadFolder.exists() && !uploadFolder.mkdirs()) {
            throw new IOException("アップロードフォルダの作成に失敗しました。");
        }

        List<BoardFileDto> fileList = new ArrayList<>();
        List<File> savedFiles = new ArrayList<>();

        try {
            for (Part part : fileParts) {
                String originName = part.getSubmittedFileName();
                String ext = extractExtension(originName);
                String saveName = UUID.randomUUID().toString() + ext;

                File target = new File(uploadFolder, saveName);
                savedFiles.add(target); // 복사 시도 전에 먼저 등록 - 실패해도 정리 대상에 포함

                try (InputStream in = part.getInputStream()) {
                    Files.copy(in, target.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }

                BoardFileDto fileDto = new BoardFileDto();
                fileDto.setOriginName(originName);
                fileDto.setSaveName(saveName);
                fileDto.setFilePath(webRelativeDir); // ★ DB엔 웹 경로만 저장
                fileDto.setFileSize((int) part.getSize());
                fileList.add(fileDto);
            }

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
                    try {
                        conn.rollback();
                    } catch (SQLException rollbackEx) {
                        e.addSuppressed(rollbackEx);
                    }
                    throw new RuntimeException("通報の登録処理中にエラーが発生しました。", e);
                }
            } catch (SQLException e) {
                throw new RuntimeException("データベースへの接続に失敗しました。", e);
            }

        } catch (IOException | RuntimeException e) {
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

            String riskLevel = require(request, "riskLevel");
            if (!VALID_RISK_LEVELS.contains(riskLevel)) {
                throw new BoardReportException("危険度の値が正しくありません。");
            }
            board.setRiskLevel(riskLevel);

            board.setLatitude(Double.parseDouble(require(request, "latitude")));
            board.setLongitude(Double.parseDouble(require(request, "longitude")));
            board.setAddress(request.getParameter("address"));
            board.setSightingDate(LocalDateTime.parse(require(request, "sightingDate")));
            board.setSituationTag(request.getParameter("situationTag"));
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