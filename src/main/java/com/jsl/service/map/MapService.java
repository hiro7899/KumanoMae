package com.jsl.service.map;

import java.util.List;

import com.jsl.dao.MapDao;
import com.jsl.dto.map.MapMarkerDto;

public class MapService {

    private final MapDao mapDao = new MapDao();

    public List<MapMarkerDto> findAllMarkers() {
        return mapDao.selectAllMarkers();
    }
}