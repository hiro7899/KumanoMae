package com.jsl.sql.board;

public class BoardFileSql {

    // 제보 첨부파일 등록
    public static final String INSERT_FILE = """
        INSERT INTO BOARD_FILE (
            FILE_ID, BOARD_ID, ORIGIN_NAME, SAVE_NAME, FILE_PATH, FILE_SIZE
        ) VALUES (
            FILE_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?
        )
        """;

    // 제보 대표 이미지 조회
    public static final String SELECT_FIRST_FILE_URL = """
        SELECT FILE_PATH, SAVE_NAME
          FROM (
                SELECT FILE_PATH, SAVE_NAME
                  FROM BOARD_FILE
                 WHERE BOARD_ID = ?
                 ORDER BY FILE_ID ASC
          )
         WHERE ROWNUM = 1
        """;
}