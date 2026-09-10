package com.jsl.sql.community;

public class CommunityFileSql {

    public static final String INSERT_FILE = """
        INSERT INTO COMMUNITY_FILE (
            C_FILE_ID, C_BOARD_ID, ORIGIN_NAME, SAVE_NAME, FILE_PATH
        )
        VALUES (
            C_FILE_ID_SEQ.NEXTVAL, ?, ?, ?, ?
        )
        """;

    public static final String SELECT_FILES_BY_BOARD_ID = """
        SELECT C_FILE_ID,
               C_BOARD_ID,
               ORIGIN_NAME,
               SAVE_NAME,
               FILE_PATH
          FROM COMMUNITY_FILE
         WHERE C_BOARD_ID = ?
        """;

    public static final String DELETE_FILES_BY_BOARD_ID = """
        DELETE FROM COMMUNITY_FILE
         WHERE C_BOARD_ID = ?
        """;

    public static final String SELECT_FIRST_FILE_URL = """
        SELECT FILE_PATH, SAVE_NAME
          FROM (
                SELECT FILE_PATH, SAVE_NAME
                  FROM COMMUNITY_FILE
                 WHERE C_BOARD_ID = ?
                 ORDER BY C_FILE_ID ASC
               )
         WHERE ROWNUM = 1
        """;
}