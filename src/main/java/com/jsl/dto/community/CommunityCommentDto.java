package com.jsl.dto.community;

import java.time.LocalDateTime;

public class CommunityCommentDto {

	private Long cCommentId; //댓글 번호
	private Long cBoardId; //소속 게시글
	private Long memberId; //작성자
	private String content; //댓글 내용
	private LocalDateTime regDate; //등록일
	
	public Long getcCommentId() {
		return cCommentId;
	}
	public void setcCommentId(Long cCommentId) {
		this.cCommentId = cCommentId;
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
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public LocalDateTime getRegDate() {
		return regDate;
	}
	public void setRegDate(LocalDateTime regDate) {
		this.regDate = regDate;
	}
	
}
