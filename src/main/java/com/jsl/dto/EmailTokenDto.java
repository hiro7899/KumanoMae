package com.jsl.dto;

import java.time.LocalDateTime;

public class EmailTokenDto {
    private Long tokenId;
    private Long memberId;
    private String token;
    private String tokenType; // SIGNUP_VERIFY / PASSWORD_RESET
    private LocalDateTime expireDate;
    private String usedYn;
    private LocalDateTime regDate;
    
	public Long getTokenId() {
		return tokenId;
	}
	public void setTokenId(Long tokenId) {
		this.tokenId = tokenId;
	}
	public Long getMemberId() {
		return memberId;
	}
	public void setMemberId(Long memberId) {
		this.memberId = memberId;
	}
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
	public String getTokenType() {
		return tokenType;
	}
	public void setTokenType(String tokenType) {
		this.tokenType = tokenType;
	}
	public LocalDateTime getExpireDate() {
		return expireDate;
	}
	public void setExpireDate(LocalDateTime expireDate) {
		this.expireDate = expireDate;
	}
	public String getUsedYn() {
		return usedYn;
	}
	public void setUsedYn(String usedYn) {
		this.usedYn = usedYn;
	}
	public LocalDateTime getRegDate() {
		return regDate;
	}
	public void setRegDate(LocalDateTime regDate) {
		this.regDate = regDate;
	}
}