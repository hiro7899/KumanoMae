package com.jsl.dao.map;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.jsl.dto.map.MapMarkerDto;
import com.jsl.sql.MapSql;
import com.jsl.util.DBManager;

public class MapDao {

    public List<MapMarkerDto> selectAllMarkers() {
        return selectMarkers(MapSql.SELECT_ALL_MARKERS, null);
    }

    public List<MapMarkerDto> selectMarkersByPeriod(double days) {
        return selectMarkers(MapSql.SELECT_MARKERS_BY_PERIOD, days);
    }

    private List<MapMarkerDto> selectMarkers(String sql, Double days) {

        List<MapMarkerDto> list = new ArrayList<>();

        try (Connection conn = DBManager.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if (days != null) {
                pstmt.setDouble(1, days);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    MapMarkerDto marker = new MapMarkerDto();

                    marker.setSourceType(rs.getString("SOURCE_TYPE"));
                    marker.setTargetId(rs.getLong("TARGET_ID"));
                    marker.setTitle(rs.getString("TITLE"));
                    marker.setRiskLevel(rs.getString("RISK_LEVEL"));
                    marker.setClearYn(rs.getString("CLEAR_YN"));
                    marker.setDisplayRisk(rs.getString("DISPLAY_RISK"));
                    marker.setLatitude(rs.getDouble("LATITUDE"));
                    marker.setLongitude(rs.getDouble("LONGITUDE"));
                    marker.setAddress(rs.getString("ADDRESS"));
                    if (rs.getTimestamp("EVENT_DATE") != null) {
                        marker.setEventDate(rs.getTimestamp("EVENT_DATE").toLocalDateTime());
                    }
                    list.add(marker);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}