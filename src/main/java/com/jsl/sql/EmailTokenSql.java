package com.jsl.sql;

public class EmailTokenSql {

    public static final String INSERT_TOKEN = """
        INSERT INTO EMAIL_TOKEN (
            TOKEN_ID, MEMBER_ID, TOKEN, TOKEN_TYPE, EXPIRE_DATE
        )
        VALUES (
            EMAIL_TOKEN_ID_SEQ.NEXTVAL, ?, ?, ?, ?
        )
        """;

    public static final String SELECT_VALID_TOKEN = """
        SELECT TOKEN_ID, MEMBER_ID, TOKEN, TOKEN_TYPE, EXPIRE_DATE, USED_YN
          FROM EMAIL_TOKEN
         WHERE TOKEN = ?
           AND TOKEN_TYPE = ?
           AND USED_YN = 'N'
           AND EXPIRE_DATE >= SYSDATE
        """;

    public static final String MARK_USED = """
        UPDATE EMAIL_TOKEN
           SET USED_YN = 'Y'
         WHERE TOKEN_ID = ?
        """;
}