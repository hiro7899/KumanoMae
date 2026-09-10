package com.jsl.sql;

public class MapSql {

    public static final String SELECT_ALL_MARKERS = """
        SELECT SOURCE_TYPE,
               TARGET_ID,
               TITLE,
               DISPLAY_RISK,
               LATITUDE,
               LONGITUDE,
               ADDRESS,
               EVENT_DATE,
               REG_DATE
          FROM V_MAP_MARKER
         ORDER BY EVENT_DATE DESC
        """;
}