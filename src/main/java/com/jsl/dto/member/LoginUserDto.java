package com.jsl.dto.member;

public class LoginUserDto {

	private Long memberId; 
    private String userId;
    private String userName;
    private String userGrade;

    public LoginUserDto(Long memberId, String userId, String userName, String userGrade) {
        this.memberId = memberId;
        this.userId = userId;
        this.userName = userName;
        this.userGrade = userGrade;
    }

	public Long getMemberId() {
		return memberId;
	}

	public void setMemberId(Long memberId) {
		this.memberId = memberId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserGrade() {
		return userGrade;
	}

	public void setUserGrade(String userGrade) {
		this.userGrade = userGrade;
	}
}