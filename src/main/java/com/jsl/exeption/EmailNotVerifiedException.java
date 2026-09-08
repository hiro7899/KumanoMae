package com.jsl.exeption;

public class EmailNotVerifiedException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    private final String code; // "LOGIN_REQUIRED" 또는 "EMAIL_NOT_VERIFIED" - Controller가 redirect 대상을 구분하는 용도

    public EmailNotVerifiedException(String code, String message) {
        super(message);
        this.code = code;
    }

    public String getCode() {
        return code;
    }
}