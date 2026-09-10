package com.jsl.sql.community;

public class CommunityLikeSql {

    public static final String EXISTS = """
        SELECT 1
          FROM COMMUNITY_LIKE
         WHERE C_BOARD_ID = ?
           AND MEMBER_ID = ?
        """;

    public static final String INSERT_LIKE = """
        INSERT INTO COMMUNITY_LIKE (
            C_LIKE_ID, C_BOARD_ID, MEMBER_ID
        )
        VALUES (
            C_LIKE_ID_SEQ.NEXTVAL, ?, ?
        )
        """;

    public static final String DELETE_LIKE = """
        DELETE FROM COMMUNITY_LIKE
         WHERE C_BOARD_ID = ?
           AND MEMBER_ID = ?
        """;
}