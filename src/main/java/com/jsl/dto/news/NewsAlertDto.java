package com.jsl.dto.news;

import java.time.LocalDateTime;

public class NewsAlertDto {

	private Long newsId;
	private String title;
	private String summary;
	private String sourceName;
	private String sourceType;
	private String sourceUrl;
	private String riskLevel;
	private double latitude;
	private double longitude;
	private String regionText;
	private LocalDateTime publishedDate;
	private LocalDateTime collectedDate;
	private String dupHash;
	
	public Long getNewsId() {
		return newsId;
	}
	public void setNewsId(Long newsId) {
		this.newsId = newsId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getSummary() {
		return summary;
	}
	public void setSummary(String summary) {
		this.summary = summary;
	}
	public String getSourceName() {
		return sourceName;
	}
	public void setSourceName(String sourceName) {
		this.sourceName = sourceName;
	}
	public String getSourceType() {
		return sourceType;
	}
	public void setSourceType(String sourceType) {
		this.sourceType = sourceType;
	}
	public String getSourceUrl() {
		return sourceUrl;
	}
	public void setSourceUrl(String sourceUrl) {
		this.sourceUrl = sourceUrl;
	}
	public String getRiskLevel() {
		return riskLevel;
	}
	public void setRiskLevel(String riskLevel) {
		this.riskLevel = riskLevel;
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
	public String getRegionText() {
		return regionText;
	}
	public void setRegionText(String regionText) {
		this.regionText = regionText;
	}
	public LocalDateTime getPublishedDate() {
		return publishedDate;
	}
	public void setPublishedDate(LocalDateTime publishedDate) {
		this.publishedDate = publishedDate;
	}
	public LocalDateTime getCollectedDate() {
		return collectedDate;
	}
	public void setCollectedDate(LocalDateTime collectedDate) {
		this.collectedDate = collectedDate;
	}
	public String getDupHash() {
		return dupHash;
	}
	public void setDupHash(String dupHash) {
		this.dupHash = dupHash;
	}
}
