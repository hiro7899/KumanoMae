package com.jsl.exeption;

public class FindIdException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public FindIdException(String message) {
        super(message);
    }
}