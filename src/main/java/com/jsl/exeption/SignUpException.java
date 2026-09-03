package com.jsl.exeption;

import java.sql.SQLException;

public class SignUpException extends RuntimeException {
    private static final long serialVersionUID = 1L;

    public SignUpException(String message, SQLException e) {
        super(message);
    }
}
