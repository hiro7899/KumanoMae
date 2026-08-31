package com.jsl.dto.community;

import java.util.Date;

public class CommunityLike {

	private Long cLikeId; //추천 번호
	private Long cBoardId; //대상 게시글
	private Long memberId; //추천 회원
	private Date regDate; //추천일
	
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
	public Date getRegDate() {
		return regDate;
	}
	public void setRegDate(Date regDate) {
		this.regDate = regDate;
	}
	
}
