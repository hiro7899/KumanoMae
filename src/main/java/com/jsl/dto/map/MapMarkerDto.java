package com.jsl.dto.map;

import java.time.LocalDateTime;

public class MapMarkerDto {
    private String sourceType;   // USER / OFFICIAL_NEWS / OFFICIAL_GOV
    private Long targetId;
    private String title;
    private String displayRisk;  // DANGER / WARNING / CAUTION / CLEAR
    private String clearYn;      // Y / N
    private double latitude;
    private double longitude;
    private String address;
    private LocalDateTime eventDate;
    private String riskLevel; // 원본 위험도 (해제 여부와 무관) - null 아님, CLEAR여도 원래 등급 보존
    
	public String getSourceType() {
		return sourceType;
	}
	public void setSourceType(String sourceType) {
		this.sourceType = sourceType;
	}
	public Long getTargetId() {
		return targetId;
	}
	public void setTargetId(Long targetId) {
		this.targetId = targetId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDisplayRisk() {
		return displayRisk;
	}
	public void setDisplayRisk(String displayRisk) {
		this.displayRisk = displayRisk;
	}
	public String getClearYn() {
		return clearYn;
	}
	public void setClearYn(String clearYn) {
		this.clearYn = clearYn;
	}
	public double getLatitude() {
		return latitude;
	}
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	public double getLongitude() {
		return longitude;
	}
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public LocalDateTime getEventDate() {
		return eventDate;
	}
	public void setEventDate(LocalDateTime eventDate) {
		this.eventDate = eventDate;
	}
	public String getRiskLevel() {
		return riskLevel;
	}
	public void setRiskLevel(String riskLevel) {
		this.riskLevel = riskLevel;
	}
    
}