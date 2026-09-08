package com.jsl.exeption;

public class BoardReportException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public BoardReportException(String message) {
        super(message);
    }
}
