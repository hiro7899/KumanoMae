package com.jsl.dto.community;

public class CommunityFileDto {

	private Long cFileId;
    private Long cBoardId;
    private String originName;
    private String saveName;
    private String filePath;
    private int fileSize;
    
	public Long getCFileId() {
		return cFileId;
	}
	public void setCFileId(Long cFileId) {
		this.cFileId = cFileId;
	}
	public Long getCBoardId() {
		return cBoardId;
	}
	public void setCBoardId(Long cBoardId) {
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
	public int getFileSize() {
		return fileSize;
	}
	public void setFileSize(int fileSize) {
		this.fileSize = fileSize;
	}
}
