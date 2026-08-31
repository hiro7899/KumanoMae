package com.jsl.dto.community;

import java.time.LocalDateTime;

public class CommunityBoardDto {
	
	private Long cBoardId; //커뮤니티 글 번호
	private Long memberId; //작성자
	private String category; //REVIEW:탐방후기, GEAR:장비추천, FREE:자유
	private String title; //제목
	private String content; //본문
	private String gearName; //장비추천 글의 제품명
	private int viewCnt; //조회수
	private int likeCnt; //추천수
	private String status; //Y:노출, N:삭제
	private LocalDateTime regDate; //등록일
	private LocalDateTime modDate; //수정일
	
	public Long getcBoardId() {
		return cBoardId;
	}
	public void setcBoardId(Long cBoardId) {
		this.cBoardId = cBoardId;
	}
	public Long getMemberId() {
		return memberId;
	}
	public void setMemberId(Long memberId) {
		this.memberId = memberId;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
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
	public String getGearName() {
		return gearName;
	}
	public void setGearName(String gearName) {
		this.gearName = gearName;
	}
	public int getViewCnt() {
		return viewCnt;
	}
	public void setViewCnt(int viewCnt) {
		this.viewCnt = viewCnt;
	}
	public int getLikeCnt() {
		return likeCnt;
	}
	public void setLikeCnt(int likeCnt) {
		this.likeCnt = likeCnt;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public LocalDateTime getRegDate() {
		return regDate;
	}
	public void setRegDate(LocalDateTime regDate) {
		this.regDate = regDate;
	}
	public LocalDateTime getModDate() {
		return modDate;
	}
	public void setModDate(LocalDateTime modDate) {
		this.modDate = modDate;
	}
	
}
