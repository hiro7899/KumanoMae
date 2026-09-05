package com.jsl.dto.api;

public class ApiResponse {

    private boolean success;
    private String message;
    private Boolean available;
    private Boolean verified; // ★ 추가

    private Boolean liked;
    private Integer likeCnt;
    
    public static ApiResponse ok() {
        ApiResponse r = new ApiResponse();
        r.success = true;
        return r;
    }

    public static ApiResponse ok(boolean available) {
        ApiResponse r = new ApiResponse();
        r.success = true;
        r.available = available;
        return r;
    }

    public static ApiResponse verified(boolean verified) { // ★ 추가
        ApiResponse r = new ApiResponse();
        r.success = true;
        r.verified = verified;
        return r;
    }

    public static ApiResponse fail(String message) {
        ApiResponse r = new ApiResponse();
        r.success = false;
        r.message = message;
        return r;
    }

    public boolean isSuccess() { return success; }
    public String getMessage() { return message; }
    public Boolean getAvailable() { return available; }
    public Boolean getVerified() { return verified; }
    
    public static ApiResponse likeResult(boolean liked, int likeCnt) {
        ApiResponse r = new ApiResponse();
        r.success = true;
        r.liked = liked;
        r.likeCnt = likeCnt;
        return r;
    }

    public Boolean getLiked() { return liked; }
    public Integer getLikeCnt() { return likeCnt; }
}