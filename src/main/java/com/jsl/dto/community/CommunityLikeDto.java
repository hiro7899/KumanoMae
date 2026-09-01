package com.jsl.dto.community;

import java.time.LocalDateTime;

public class CommunityLikeDto {

	private Long cLikeId; //추천 번호
	private Long cBoardId; //대상 게시글
	private Long memberId; //추천 회원
	private LocalDateTime regDate; //추천일
	
	public Long getcLikeId() {
		return cLikeId;
	}
	public void setcLikeId(Long cLikeId) {
		this.cLikeId = cLikeId;
	}
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
	public LocalDateTime getRegDate() {
		return regDate;
	}
	public void setRegDate(LocalDateTime regDate) {
		this.regDate = regDate;
	}
	
}
