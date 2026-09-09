package com.jsl.service.admin;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.dao.admin.AdminLogDao;
import com.jsl.dao.community.CommunityBoardDao;
import com.jsl.dao.community.CommunityFileDao;
import com.jsl.dto.community.CommunityFileDto;
import com.jsl.dto.member.LoginUserDto;
import com.jsl.exeption.AdminActionException;
import com.jsl.service.Command;
import com.jsl.util.DBManager;
import com.jsl.util.UploadPathUtil;

public class AdminCommunityDeleteService implements Command {

    private static final String COMMUNITY_SUBDIR = "/community";

    private final CommunityBoardDao communityBoardDao = new CommunityBoardDao();
    private final CommunityFileDao communityFileDao = new CommunityFileDao();
    private final AdminLogDao adminLogDao = new AdminLogDao();

    @Override
    public void doCommand(HttpServletRequest request, HttpServletResponse response) throws IOException {

        LoginUserDto admin = AdminServiceSupport.getLoginAdmin(request);
        Long cBoardId = AdminServiceSupport.parseId(request, "cBoardId");

        // 실제 파일 삭제를 위해, DB 삭제 전에 파일 목록부터 확보
        List<CommunityFileDto> files = communityFileDao.selectFilesByBoardId(cBoardId);
        ServletContext ctx = request.getServletContext();
        File uploadFolder = new File(ctx.getRealPath(UploadPathUtil.getUploadDir() + COMMUNITY_SUBDIR));

        try (Connection conn = DBManager.getConnection()) {
            try {
                conn.setAutoCommit(false);

                String current = communityBoardDao.findStatus(conn, cBoardId);
                if (current == null) throw new AdminActionException("存在しない投稿です。");

                // ON DELETE CASCADE로 COMMUNITY_FILE/COMMUNITY_COMMENT/COMMUNITY_LIKE 행도 함께 삭제됨
                communityBoardDao.deletePhysically(conn, cBoardId);
                adminLogDao.insertLog(conn, admin.getMemberId(), "COMMUNITY", cBoardId, "DELETE", null);

                conn.commit();

                // DB 커밋 성공 후에만 실제 파일 삭제
                for (CommunityFileDto f : files) {
                    new File(uploadFolder, f.getSaveName()).delete();
                }

            } catch (SQLException e) {
                try { conn.rollback(); } catch (SQLException rollbackEx) { e.addSuppressed(rollbackEx); }
                throw new RuntimeException("削除処理中にエラーが発生しました。", e);
            }
        } catch (SQLException e) {
            throw new RuntimeException("データベースへの接続に失敗しました。", e);
        }
    }
}