package com.jsl.util;

import java.io.IOException;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.jsl.dto.api.ApiResponse;

public class JsonResponseUtil {

    private static final Gson gson = new Gson();

    public static void writeSuccess(HttpServletResponse response) throws IOException {
        write(response, 200, ApiResponse.ok());
    }

    public static void writeSuccess(HttpServletResponse response, boolean available) throws IOException {
        write(response, 200, ApiResponse.ok(available));
    }

    public static void writeError(HttpServletResponse response, int statusCode, String message) throws IOException {
        write(response, statusCode, ApiResponse.fail(message));
    }

    private static void write(HttpServletResponse response, int statusCode, ApiResponse body) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(gson.toJson(body));
    }
}