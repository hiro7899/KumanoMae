package com.jsl.sql;

public class MapSql {

    private MapSql() {
    }

    public static final String SELECT_ALL_MARKERS = """
        SELECT SOURCE_TYPE, TARGET_ID, TITLE, RISK_LEVEL, CLEAR_YN, DISPLAY_RISK,
               LATITUDE, LONGITUDE, ADDRESS, EVENT_DATE
          FROM V_MAP_MARKER
        """;

    public static final String SELECT_MARKERS_BY_PERIOD = """
        SELECT SOURCE_TYPE, TARGET_ID, TITLE, RISK_LEVEL, CLEAR_YN, DISPLAY_RISK,
               LATITUDE, LONGITUDE, ADDRESS, EVENT_DATE
          FROM V_MAP_MARKER
         WHERE EVENT_DATE >= SYSDATE - ?
        """;
}