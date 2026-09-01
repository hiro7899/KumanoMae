package com.jsl.dto.member;

public class LoginUserDto {

    private String userId;
    private String userName;
    private String userGrade;

    public LoginUserDto(String userId, String userName, String userGrade) {
        this.userId = userId;
        this.userName = userName;
        this.userGrade = userGrade;
    }

    public String getUserId() {
        return userId;
    }

    public String getUserName() {
        return userName;
    }

    public String getUserGrade() {
        return userGrade;
    }
}