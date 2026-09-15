package com.jsl.dto.map;

import java.util.List;

public class MapMarkerResponse {
    private final boolean success;
    private final String message;
    private final List<MapMarkerDto> markers;
    private final int dangerCount;
    private final int warningCount;
    private final int cautionCount;
    private final int clearCount;

    public MapMarkerResponse(List<MapMarkerDto> markers,
                              int dangerCount, int warningCount, int cautionCount, int clearCount) {
        this.success = true;
        this.message = null;
        this.markers = markers;
        this.dangerCount = dangerCount;
        this.warningCount = warningCount;
        this.cautionCount = cautionCount;
        this.clearCount = clearCount;
    }

    // getter 생략 없이 전부 (Gson 직렬화에는 없어도 되지만 관례상 추가)
    public boolean isSuccess() { return success; }
    public String getMessage() { return message; }
    public List<MapMarkerDto> getMarkers() { return markers; }
    public int getDangerCount() { return dangerCount; }
    public int getWarningCount() { return warningCount; }
    public int getCautionCount() { return cautionCount; }
    public int getClearCount() { return clearCount; }
}