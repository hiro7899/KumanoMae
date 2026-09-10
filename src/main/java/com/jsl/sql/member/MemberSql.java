package com.jsl.sql.member;

public class MemberSql {

    public static final String SELECT_ALL_MEMBERS = """
        SELECT MEMBER_ID, USER_ID, USER_NAME, EMAIL, PHONE, USER_GRADE, STATUS, JOIN_DATE
          FROM MEMBER
         ORDER BY JOIN_DATE DESC
        """;

    public static final String SELECT_STATUS = """
        SELECT STATUS
          FROM MEMBER
         WHERE MEMBER_ID = ?
        """;

    public static final String SELECT_GRADE = """
        SELECT USER_GRADE
          FROM MEMBER
         WHERE MEMBER_ID = ?
        """;

    public static final String UPDATE_GRADE = """
        UPDATE MEMBER
           SET USER_GRADE = ?
         WHERE MEMBER_ID = ?
        """;

    public static final String UPDATE_STATUS = """
        UPDATE MEMBER
           SET STATUS = ?
         WHERE MEMBER_ID = ?
        """;

    public static final String COUNT_ACTIVE = """
        SELECT COUNT(*)
          FROM MEMBER
         WHERE STATUS = 'Y'
        """;
}