package com.jsl.exeption;

public class EmailTokenException extends RuntimeException {
	private static final long serialVersionUID = 1L;

    public EmailTokenException(String message) {
        super(message);
    }
}
