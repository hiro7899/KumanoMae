package com.jsl.dto.board;

import java.util.Date;

public class BoardDto {

	private Long boardId; //제보번호
	private Long memberId; //작성자
	private String title; //제목
	private String content; //상세 내용
	private String riskLevel; //위험도: DANGER/WARNING/CAUTION
	private int latitude; //위도
	private int longitude; //경도
	private String address; //Geocoder 자동 변환 주소
	private Date sightingDate; //목격 일시
	private String situationTag; //목격 당시 상황 태그
	private int viewCnt; //조회수
	private String status; //W:승인대기, Y:승인, N:반려
	private String clearYn; //위험 해제 여부(Y=안심마커 전환)
	private Date clearDate; //위험 해제 처리일
	private String clearMemo; //위험 해제 사유
	private Date regDate; //등록일
	private Date modDate; //수정일
	
	public Long getBoardId() {
		return boardId;
	}
	public void setBoardId(Long boardId) {
		this.boardId = boardId;
	}
	public Long getMemberId() {
		return memberId;
	}
	public void setMemberId(Long memberId) {
		this.memberId = memberId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getRiskLevel() {
		return riskLevel;
	}
	public void setRiskLevel(String riskLevel) {
		this.riskLevel = riskLevel;
	}
	public int getLatitude() {
		return latitude;
	}
	public void setLatitude(int latitude) {
		this.latitude = latitude;
	}
	public int getLongitude() {
		return longitude;
	}
	public void setLongitude(int longitude) {
		this.longitude = longitude;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public Date getSightingDate() {
		return sightingDate;
	}
	public void setSightingDate(Date sightingDate) {
		this.sightingDate = sightingDate;
	}
	public String getSituationTag() {
		return situationTag;
	}
	public void setSituationTag(String situationTag) {
		this.situationTag = situationTag;
	}
	public int getViewCnt() {
		return viewCnt;
	}
	public void setViewCnt(int viewCnt) {
		this.viewCnt = viewCnt;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getClearYn() {
		return clearYn;
	}
	public void setClearYn(String clearYn) {
		this.clearYn = clearYn;
	}
	public Date getClearDate() {
		return clearDate;
	}
	public void setClearDate(Date clearDate) {
		this.clearDate = clearDate;
	}
	public String getClearMemo() {
		return clearMemo;
	}
	public void setClearMemo(String clearMemo) {
		this.clearMemo = clearMemo;
	}
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	public Date getModDate() {
		return modDate;
	}
	public void setModDate(Date modDate) {
		this.modDate = modDate;
	}
	
}
