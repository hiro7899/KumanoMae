package com.jsl.dto.api;

public class ApiResponse {

    private boolean success;
    private String message;
    private boolean available;
    private boolean verified; // ★ 추가

    private boolean liked;
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
    public boolean getAvailable() { return available; }
    public boolean getVerified() { return verified; }
    
    public static ApiResponse likeResult(boolean liked, int likeCnt) {
        ApiResponse r = new ApiResponse();
        r.success = true;
        r.liked = liked;
        r.likeCnt = likeCnt;
        return r;
    }

    public boolean getLiked() { return liked; }
    public Integer getLikeCnt() { return likeCnt; }
}