package com.jsl.util;

import java.io.IOException;
import javax.servlet.http.HttpServletResponse;

public class JsonResponseUtil {

    public static void writeSuccess(HttpServletResponse response) throws IOException {
        write(response, 200, "{\"success\":true}");
    }

    public static void writeSuccess(HttpServletResponse response, String key, boolean value) throws IOException {
        write(response, 200, "{\"success\":true,\"" + key + "\":" + value + "}");
    }

    public static void writeError(HttpServletResponse response, int statusCode, String message) throws IOException {
        write(response, statusCode, "{\"success\":false,\"message\":\"" + escape(message) + "\"}");
    }

    private static void write(HttpServletResponse response, int statusCode, String json) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(json);
    }

    private static String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", "");
    }
}