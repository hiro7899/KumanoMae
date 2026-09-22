package com.jsl.exception;

public class BoardException extends RuntimeException{
	
	private static final long serialVersionUID = 1L;

	public BoardException(String massage) {
		super(massage);
	}

	public BoardException(String massage, Throwable cause) {
		super(massage, cause);
	}
}
