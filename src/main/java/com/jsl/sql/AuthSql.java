package com.jsl.sql;

public class AuthSql {

    // 아이디 존재 여부
    public static final String EXISTS_USER_ID = """
        SELECT USER_ID
          FROM MEMBER
         WHERE USER_ID = ?
        """;

    // 이메일 존재 여부
    public static final String EXISTS_EMAIL = """
        SELECT 1
          FROM MEMBER
         WHERE EMAIL = ?
        """;

    // 회원가입
    public static final String SIGN_UP = """
        INSERT INTO MEMBER (
            MEMBER_ID, USER_ID, USER_PW, USER_NAME, EMAIL, PHONE
        )
        VALUES (
            MEMBER_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?
        )
        """;

    // 로그인
    public static final String LOGIN = """
        SELECT MEMBER_ID, USER_ID, USER_PW, USER_NAME, EMAIL,
               USER_GRADE, EMAIL_VERIFIED_YN
          FROM MEMBER
         WHERE USER_ID = ? OR EMAIL = ?
        """;

    // 이메일 인증 상태 변경
    public static final String UPDATE_EMAIL_VERIFIED = """
        UPDATE MEMBER
           SET EMAIL_VERIFIED_YN = ?
         WHERE MEMBER_ID = ?
        """;

    // 이메일로 회원 조회
    public static final String SELECT_BY_EMAIL = """
        SELECT MEMBER_ID, USER_ID, USER_NAME, EMAIL, EMAIL_VERIFIED_YN
          FROM MEMBER
         WHERE EMAIL = ?
        """;

    // 비밀번호 변경
    public static final String UPDATE_PASSWORD = """
        UPDATE MEMBER
           SET USER_PW = ?
         WHERE MEMBER_ID = ?
        """;

    // 이름 + 이메일로 회원 조회
    public static final String SELECT_BY_NAME_AND_EMAIL = """
        SELECT MEMBER_ID, USER_ID, USER_NAME, EMAIL
          FROM MEMBER
         WHERE USER_NAME = ? AND EMAIL = ? AND STATUS = 'Y'
        """;

    // 회원 ID로 회원 조회
    public static final String SELECT_BY_ID = """
        SELECT MEMBER_ID, USER_ID, USER_NAME, EMAIL, PHONE,
               USER_GRADE, JOIN_DATE, EMAIL_VERIFIED_YN
          FROM MEMBER
         WHERE MEMBER_ID = ?
        """;
}