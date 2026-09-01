package com.jsl.dto.community;

public class CommunityFileDto {

	private Long cFileId; //파일 번호
	private Long cBoardId; //소속 게시글
	private String originName; //원본 파일명
	private String saveName; //서버 저장 파일명
	private String filePath; //저장 경로
	
	public Long getcFileId() {
		return cFileId;
	}
	public void setcFileId(Long cFileId) {
		this.cFileId = cFileId;
	}
	public Long getcBoardId() {
		return cBoardId;
	}
	public void setcBoardId(Long cBoardId) {
		this.cBoardId = cBoardId;
	}
	public String getOriginName() {
		return originName;
	}
	public void setOriginName(String originName) {
		this.originName = originName;
	}
	public String getSaveName() {
		return saveName;
	}
	public void setSaveName(String saveName) {
		this.saveName = saveName;
	}
	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	
}
