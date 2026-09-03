package com.jsl.exeption;

public class AdminActionException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public AdminActionException(String message) {
        super(message);
    }
}