package com.jsl.util;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DBManager {

    private static DataSource dataSource;

    static {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            dataSource = (DataSource) envContext.lookup("jdbc/kumanomae");
        } catch (NamingException e) {
            throw new ExceptionInInitializerError("DataSource 초기화 실패: " + e.getMessage());
        }
    }

    private DBManager() {
    }

    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
}