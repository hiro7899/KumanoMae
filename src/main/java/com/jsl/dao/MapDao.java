package com.jsl.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.jsl.dto.map.MapMarkerDto;
import com.jsl.util.DBManager;

public class MapDao {

	public List<MapMarkerDto> selectAllMarkers() {

	    String sql = """
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

	    List<MapMarkerDto> list = new ArrayList<>();

	    try (Connection conn = DBManager.getConnection();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {

	        while (rs.next()) {
	            MapMarkerDto marker = new MapMarkerDto();

	            marker.setSourceType(rs.getString("SOURCE_TYPE"));
	            marker.setTargetId(rs.getLong("TARGET_ID"));
	            marker.setTitle(rs.getString("TITLE"));
	            marker.setDisplayRisk(rs.getString("DISPLAY_RISK"));
	            marker.setLatitude(rs.getDouble("LATITUDE"));
	            marker.setLongitude(rs.getDouble("LONGITUDE"));
	            marker.setAddress(rs.getString("ADDRESS"));
	            marker.setEventDate(
	                rs.getTimestamp("EVENT_DATE").toLocalDateTime()
	            );
	            marker.setRegDate(
	                rs.getTimestamp("REG_DATE").toLocalDateTime()
	            );

	            list.add(marker);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
}
