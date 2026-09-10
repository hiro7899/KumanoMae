package com.jsl.sql.community;

public class CommunityBoardSql {

    // 커뮤니티 게시글 목록 조회
    public static final String SELECT_LIST = """
        SELECT cb.C_BOARD_ID, cb.MEMBER_ID, cb.CATEGORY, cb.TITLE, cb.GEAR_NAME,
               cb.VIEW_CNT, cb.LIKE_CNT, cb.REG_DATE,
               m.USER_NAME AS WRITER_NAME,
               (SELECT COUNT(*)
                  FROM COMMUNITY_COMMENT cc
                 WHERE cc.C_BOARD_ID = cb.C_BOARD_ID) AS COMMENT_CNT
          FROM COMMUNITY_BOARD cb
          JOIN MEMBER m
            ON m.MEMBER_ID = cb.MEMBER_ID
         WHERE cb.STATUS = 'Y'
        """;

    // 커뮤니티 게시글 상세 조회
    public static final String SELECT_BY_ID = """
        SELECT cb.C_BOARD_ID, cb.MEMBER_ID, cb.CATEGORY, cb.TITLE, cb.CONTENT, cb.GEAR_NAME,
               cb.VIEW_CNT, cb.LIKE_CNT, cb.STATUS, cb.REG_DATE, cb.MOD_DATE,
               m.USER_NAME AS WRITER_NAME,
               (SELECT COUNT(*)
                  FROM COMMUNITY_COMMENT cc
                 WHERE cc.C_BOARD_ID = cb.C_BOARD_ID) AS COMMENT_CNT
          FROM COMMUNITY_BOARD cb
          JOIN MEMBER m
            ON m.MEMBER_ID = cb.MEMBER_ID
         WHERE cb.C_BOARD_ID = ?
           AND cb.STATUS = 'Y'
        """;

    // 커뮤니티 게시글 등록
    public static final String INSERT_BOARD = """
        INSERT INTO COMMUNITY_BOARD (
            C_BOARD_ID, MEMBER_ID, CATEGORY, TITLE, CONTENT, GEAR_NAME
        )
        VALUES (
            C_BOARD_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?
        )
        """;

    // 커뮤니티 게시글 수정
    public static final String UPDATE_BOARD = """
        UPDATE COMMUNITY_BOARD
           SET CATEGORY = ?,
               TITLE = ?,
               CONTENT = ?,
               GEAR_NAME = ?,
               MOD_DATE = SYSDATE
         WHERE C_BOARD_ID = ?
        """;

    // 커뮤니티 게시글 상태 변경
    public static final String UPDATE_STATUS = """
        UPDATE COMMUNITY_BOARD
           SET STATUS = ?,
               MOD_DATE = SYSDATE
         WHERE C_BOARD_ID = ?
        """;

    // 조회수 증가
    public static final String INCREASE_VIEW_CNT = """
        UPDATE COMMUNITY_BOARD
           SET VIEW_CNT = VIEW_CNT + 1
         WHERE C_BOARD_ID = ?
        """;

    // 작성자 ID 조회
    public static final String SELECT_WRITER_ID = """
        SELECT MEMBER_ID
          FROM COMMUNITY_BOARD
         WHERE C_BOARD_ID = ?
        """;

    // 게시글 상태 조회
    public static final String SELECT_STATUS = """
        SELECT STATUS
          FROM COMMUNITY_BOARD
         WHERE C_BOARD_ID = ?
        """;

    // 좋아요 수 변경
    public static final String UPDATE_LIKE_CNT = """
        UPDATE COMMUNITY_BOARD
           SET LIKE_CNT = LIKE_CNT + ?
         WHERE C_BOARD_ID = ?
        """;

    // 활성 게시글 수 조회
    public static final String COUNT_ACTIVE = """
        SELECT COUNT(*)
          FROM COMMUNITY_BOARD
         WHERE STATUS = 'Y'
        """;

    // 관리자용 전체 게시글 조회
    public static final String SELECT_ALL_FOR_ADMIN = """
        SELECT C_BOARD_ID, MEMBER_ID, CATEGORY, TITLE, GEAR_NAME,
               VIEW_CNT, LIKE_CNT, STATUS, REG_DATE
          FROM COMMUNITY_BOARD
        """;

    // 관리자용 게시글 상세 조회
    public static final String SELECT_BY_ID_FOR_ADMIN = """
        SELECT C_BOARD_ID, MEMBER_ID, CATEGORY, TITLE, CONTENT, GEAR_NAME,
               VIEW_CNT, LIKE_CNT, STATUS, REG_DATE, MOD_DATE
          FROM COMMUNITY_BOARD
         WHERE C_BOARD_ID = ?
        """;

    // 커뮤니티 게시글 물리 삭제
    public static final String DELETE_PHYSICALLY = """
        DELETE FROM COMMUNITY_BOARD
         WHERE C_BOARD_ID = ?
        """;

    // 메인 화면 최신 게시글 조회
    public static final String SELECT_RECENT_ACTIVE = """
        SELECT * FROM (
            SELECT cb.C_BOARD_ID, cb.MEMBER_ID, cb.CATEGORY, cb.TITLE, cb.GEAR_NAME,
                   cb.VIEW_CNT, cb.LIKE_CNT, cb.REG_DATE,
                   m.USER_NAME AS WRITER_NAME,
                   (SELECT COUNT(*)
                      FROM COMMUNITY_COMMENT cc
                     WHERE cc.C_BOARD_ID = cb.C_BOARD_ID) AS COMMENT_CNT
              FROM COMMUNITY_BOARD cb
              JOIN MEMBER m
                ON m.MEMBER_ID = cb.MEMBER_ID
             WHERE cb.STATUS = 'Y'
             ORDER BY cb.REG_DATE DESC
        ) WHERE ROWNUM <= ?
        """;
}