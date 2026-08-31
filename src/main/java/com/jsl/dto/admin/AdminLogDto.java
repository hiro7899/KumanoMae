package com.jsl.dto.admin;

import java.util.Date;

public class AdminLogDto {
	
	private Long logId; //로그 번호
	private Long adminId; //처리 관리자
	private String targetType; //처리 대상 구분: BOARD/COMMUNITY
	private int targetId; //대상 글 번호
	private String actionType; //APPROVE/REJECT/DELETE/CLEAR
	private String actionMemo; //처리 사유 메모
	private Date actionDate; //처리 일시
	
	public Long getLogId() {
		return logId;
	}
	public void setLogId(Long logId) {
		this.logId = logId;
	}
	public Long getAdminId() {
		return adminId;
	}
	public void setAdminId(Long adminId) {
		this.adminId = adminId;
	}
	public String getTargetType() {
		return targetType;
	}
	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}
	public int getTargetId() {
		return targetId;
	}
	public void setTargetId(int targetId) {
		this.targetId = targetId;
	}
	public String getActionType() {
		return actionType;
	}
	public void setActionType(String actionType) {
		this.actionType = actionType;
	}
	public String getActionMemo() {
		return actionMemo;
	}
	public void setActionMemo(String actionMemo) {
		this.actionMemo = actionMemo;
	}
	public Date getActionDate() {
		return actionDate;
	}
	public void setActionDate(Date actionDate) {
		this.actionDate = actionDate;
	}
	
}
