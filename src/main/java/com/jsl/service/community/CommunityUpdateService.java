package com.jsl.service.community;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.dao.community.CommunityFileDao;
import com.jsl.dto.community.CommunityBoardDto;
import com.jsl.dto.community.CommunityFileDto;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.CommunityException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;

public class CommunityUpdateService implements Command {

    private static final int MAX_FILE_COUNT = 5;
    private static final String UPLOAD_ROOT = "D:/upload";
    private static final String COMMUNITY_UPLOAD_DIR = "/community";
    private static final String COMMUNITY_WEB_PATH = "/uploads/community";
    private static final Set<String> VALID_CATEGORIES = Set.of("REVIEW", "GEAR", "FREE");

    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final CommunityFileDao communityFileDao = new CommunityFileDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            throw new CommunityException("ログインが必要です。");
        }
        LoginUserDto loginUser = (LoginUserDto) session.getAttribute("user");

        Long cBoardId = parseId(request, "cBoardId");
        Long writerId = communityBoardDao.findWriterId(cBoardId);
        if (writerId == null) {
            throw new CommunityException("存在しない投稿です。");
        }
        boolean isOwner = writerId.equals(loginUser.getMemberId());
        boolean isAdmin = "A".equals(loginUser.getUserGrade());
        if (!isOwner && !isAdmin) {
            throw new CommunityException("修正権限がありません。");
        }

        CommunityBoardDto dto = new CommunityBoardDto();
        dto.setCBoardId(cBoardId);

        String category = require(request, "category");
        if (!VALID_CATEGORIES.contains(category)) {
            throw new CommunityException("カテゴリの値が正しくありません。");
        }
        dto.setCategory(category);
        dto.setTitle(require(request, "title"));
        dto.setContent(require(request, "content"));
        dto.setGearName(request.getParameter("gearName"));

        // 새 파일이 업로드된 경우에만 기존 파일을 교체. 없으면 기존 파일 유지.
        List<Part> fileParts = new ArrayList<Part>();
        for (Part part : request.getParts()) {
            if ("photoFile".equals(part.getName()) && part.getSize() > 0) {
                fileParts.add(part);
            }
        }
        if (fileParts.size() > MAX_FILE_COUNT) {
            throw new CommunityException("写真は最大" + MAX_FILE_COUNT + "枚まで添付できます。");
        }

        List<CommunityFileDto> newFileList = new ArrayList<>();
        List<File> savedFiles = new ArrayList<File>();
        List<File> oldPhysicalFiles = new ArrayList<File>();

        try {
            if (!fileParts.isEmpty()) {
                File uploadFolder = new File(UPLOAD_ROOT + COMMUNITY_UPLOAD_DIR);
                if (!uploadFolder.exists() && !uploadFolder.mkdirs()) {
                    throw new IOException("アップロードフォルダの作成に失敗しました。");
                }

                // 교체 대상이 될 기존 파일들의 실제 경로를 미리 확보 (커밋 후 삭제)
                for (var f : communityFileDao.selectFilesByBoardId(cBoardId)) {
                    oldPhysicalFiles.add(new File(uploadFolder, f.getSaveName()));
                }

                for (Part part : fileParts) {
                    String originName = part.getSubmittedFileName();
                    String ext = extractExtension(originName);
                    String saveName = UUID.randomUUID().toString() + ext;

                    File target = new File(uploadFolder, saveName);
                    savedFiles.add(target);

                    try (InputStream in = part.getInputStream()) {
                        Files.copy(in, target.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }

                    CommunityFileDto fileDto = new CommunityFileDto();
                    fileDto.setOriginName(originName);
                    fileDto.setSaveName(saveName);
                    fileDto.setFilePath(COMMUNITY_WEB_PATH);
                    fileDto.setFileSize((int) part.getSize());
                    newFileList.add(fileDto);
                }
            }

            try (Connection conn = DBManager.getConnection()) {
                try {
                    conn.setAutoCommit(false);

                    communityBoardDao.updateBoard(conn, dto);

                    if (!fileParts.isEmpty()) {
                        communityFileDao.deleteFilesByBoardId(conn, cBoardId);
                        for (CommunityFileDto fileDto : newFileList) {
                            fileDto.setCBoardId(cBoardId);
                            communityFileDao.insertFile(conn, fileDto);
                        }
                    }

                    conn.commit();

                    // 새 파일 교체가 성공적으로 커밋된 뒤에만 기존 물리 파일 삭제
                    for (File old : oldPhysicalFiles) old.delete();

                } catch (SQLException e) {
                    try { conn.rollback(); } catch (SQLException rollbackEx) { e.addSuppressed(rollbackEx); }
                    throw new RuntimeException("投稿修正処理中にエラーが発生しました。", e);
                }
            } catch (SQLException e) {
                throw new RuntimeException("データベースへの接続に失敗しました。", e);
            }

        } catch (IOException | RuntimeException e) {
            for (File f : savedFiles) f.delete(); // 이번에 새로 저장한 파일만 정리
            if (e instanceof IOException) throw (IOException) e;
            throw (RuntimeException) e;
        }
    }

    private Long parseId(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()) {
            throw new CommunityException(name + "は必須です。");
        }
        try {
            return Long.parseLong(value);
        } catch (NumberFormatException e) {
            throw new CommunityException(name + "の形式が正しくありません。");
        }
    }

    private String require(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()) {
            throw new CommunityException(name + "は必須項目です。");
        }
        return value;
    }

    private String extractExtension(String originName) {
        if (originName == null) return "";
        int dot = originName.lastIndexOf('.');
        return (dot != -1) ? originName.substring(dot) : "";
    }
}