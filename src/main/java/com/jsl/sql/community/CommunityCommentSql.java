package com.jsl.sql.community;

public class CommunityCommentSql {

    public static final String SELECT_BY_BOARD_ID = """
        SELECT C_COMMENT_ID, C_BOARD_ID, MEMBER_ID, CONTENT, REG_DATE
          FROM COMMUNITY_COMMENT
         WHERE C_BOARD_ID = ?
         ORDER BY REG_DATE ASC
        """;

    public static final String INSERT_COMMENT = """
        INSERT INTO COMMUNITY_COMMENT (
            C_COMMENT_ID, C_BOARD_ID, MEMBER_ID, CONTENT
        )
        VALUES (
            C_COMMENT_ID_SEQ.NEXTVAL, ?, ?, ?
        )
        """;

    public static final String SELECT_WRITER_ID = """
        SELECT MEMBER_ID
          FROM COMMUNITY_COMMENT
         WHERE C_COMMENT_ID = ?
        """;

    public static final String SELECT_BOARD_ID = """
        SELECT C_BOARD_ID
          FROM COMMUNITY_COMMENT
         WHERE C_COMMENT_ID = ?
        """;

    public static final String DELETE_COMMENT = """
        DELETE FROM COMMUNITY_COMMENT
         WHERE C_COMMENT_ID = ?
        """;
}