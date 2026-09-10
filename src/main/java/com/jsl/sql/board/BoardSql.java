package com.jsl.sql.board;

public class BoardSql {

    // 전체 제보 조회
    public static final String SELECT_ALL_BOARD = """
        SELECT BOARD_ID, MEMBER_ID, TITLE, CONTENT, RISK_LEVEL, LATITUDE, LONGITUDE,
               ADDRESS, SIGHTING_DATE, SITUATION_TAG, VIEW_CNT, STATUS, CLEAR_YN,
               CLEAR_DATE, CLEAR_MEMO, REG_DATE, MOD_DATE
          FROM BOARD
         ORDER BY REG_DATE DESC
        """;

    // 승인된 제보 조회
    public static final String SELECT_APPROVED_BOARD = """
        SELECT BOARD_ID, MEMBER_ID, TITLE, CONTENT, RISK_LEVEL, LATITUDE, LONGITUDE,
               ADDRESS, SIGHTING_DATE, SITUATION_TAG, VIEW_CNT, STATUS, CLEAR_YN,
               CLEAR_DATE, CLEAR_MEMO, REG_DATE, MOD_DATE
          FROM BOARD
         WHERE STATUS = 'Y'
         ORDER BY REG_DATE DESC
        """;

    // 제보 등록
    public static final String INSERT_REPORT = """
        INSERT INTO BOARD (
            BOARD_ID, MEMBER_ID, TITLE, CONTENT, RISK_LEVEL,
            LATITUDE, LONGITUDE, ADDRESS, SIGHTING_DATE, SITUATION_TAG, STATUS
        ) VALUES (
            BOARD_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'W'
        )
        """;

    // 제보 상태 변경
    public static final String UPDATE_STATUS = """
        UPDATE BOARD
           SET STATUS = ?, MOD_DATE = SYSDATE
         WHERE BOARD_ID = ?
        """;

    // 위험 해제 처리
    public static final String UPDATE_CLEAR = """
        UPDATE BOARD
           SET CLEAR_YN = 'Y',
               CLEAR_DATE = SYSDATE,
               CLEAR_MEMO = ?,
               MOD_DATE = SYSDATE
         WHERE BOARD_ID = ?
        """;

    // 제보 상태 조회
    public static final String SELECT_STATUS = """
        SELECT STATUS
          FROM BOARD
         WHERE BOARD_ID = ?
        """;

    // 상태별 제보 개수
    public static final String COUNT_BY_STATUS = """
        SELECT COUNT(*)
          FROM BOARD
         WHERE STATUS = ?
        """;

    // 현재 위험 제보 개수
    public static final String COUNT_ACTIVE_DANGER = """
        SELECT COUNT(*)
          FROM BOARD
         WHERE STATUS = 'Y'
           AND RISK_LEVEL = 'DANGER'
           AND CLEAR_YN = 'N'
        """;

    // 메인 화면 최신 승인 제보 조회
    public static final String SELECT_RECENT_APPROVED = """
        SELECT * FROM (
            SELECT b.BOARD_ID, b.MEMBER_ID, b.TITLE, b.CONTENT, b.RISK_LEVEL,
                   b.LATITUDE, b.LONGITUDE, b.ADDRESS, b.SIGHTING_DATE,
                   b.SITUATION_TAG, b.VIEW_CNT, b.STATUS, b.CLEAR_YN,
                   b.CLEAR_DATE, b.CLEAR_MEMO, b.REG_DATE, b.MOD_DATE,
                   m.USER_NAME AS WRITER_NAME
              FROM BOARD b
              JOIN MEMBER m ON m.MEMBER_ID = b.MEMBER_ID
             WHERE b.STATUS = 'Y'
             ORDER BY b.REG_DATE DESC
        )
        WHERE ROWNUM <= ?
        """;
}