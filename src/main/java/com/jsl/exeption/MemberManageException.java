package com.jsl.exeption;

public class MemberManageException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public MemberManageException(String message) {
		super(message);
	}

	public MemberManageException(String message, Throwable cause) {
		super(message, cause);
	}
}