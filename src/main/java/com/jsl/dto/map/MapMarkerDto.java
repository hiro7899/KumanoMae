package com.jsl.dto.map;

import java.time.LocalDateTime;

public class MapMarkerDto {

    private String sourceType;
    private Long targetId;
    private String title;
    private String displayRisk;
    private double latitude;
    private double longitude;
    private String address;
    private LocalDateTime eventDate;
    private LocalDateTime regDate;
    	
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
	public LocalDateTime getRegDate() {
		return regDate;
	}
	public void setRegDate(LocalDateTime regDate) {
		this.regDate = regDate;
	}
}
