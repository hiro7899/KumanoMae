package com.jsl.sql.admin;

public class AdminLogSql {
	
	public static final String INSERT_LOG = """
			INSERT INTO ADMIN_LOG (
                LOG_ID, ADMIN_ID, TARGET_TYPE, TARGET_ID, ACTION_TYPE, ACTION_MEMO
            ) VALUES (
                LOG_ID_SEQ.NEXTVAL, ?, ?, ?, ?, ?
            )
			""";
}
