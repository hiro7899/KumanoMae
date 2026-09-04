package com.jsl.dto.api;

public class ApiResponse {

    private boolean success;
    private String message;
    private Boolean available; // check-user-id / check-email 전용, 그 외엔 null(Gson이 자동으로 응답에서 생략)

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

    public static ApiResponse fail(String message) {
        ApiResponse r = new ApiResponse();
        r.success = false;
        r.message = message;
        return r;
    }

    public boolean isSuccess() { return success; }
    public String getMessage() { return message; }
    public Boolean getAvailable() { return available; }
}