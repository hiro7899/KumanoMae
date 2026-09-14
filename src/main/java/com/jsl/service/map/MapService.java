package com.jsl.service.map;

import java.util.List;

import com.jsl.dao.map.MapDao;
import com.jsl.dto.map.MapMarkerDto;
import com.jsl.dto.map.MapMarkerResponse;

public class MapService {

    private final MapDao mapDao = new MapDao();

    public MapMarkerResponse getMarkers(String period) {

        List<MapMarkerDto> markers = "realtime".equals(period) ? mapDao.selectMarkersByPeriod(3.0 / 24.0)
                : "1d".equals(period)       ? mapDao.selectMarkersByPeriod(1.0)
                : "7d".equals(period)       ? mapDao.selectMarkersByPeriod(7.0)
                : "30d".equals(period)      ? mapDao.selectMarkersByPeriod(30.0)
                : mapDao.selectAllMarkers();

        int dangerCount = 0, warningCount = 0, cautionCount = 0, clearCount = 0;
        for (MapMarkerDto m : markers) {
            switch (m.getDisplayRisk()) {
                case "DANGER":  dangerCount++;  break;
                case "WARNING": warningCount++; break;
                case "CAUTION": cautionCount++; break;
                case "CLEAR":   clearCount++;   break;
                default: break;
            }
        }

        return new MapMarkerResponse(markers, dangerCount, warningCount, cautionCount, clearCount);
    }
}