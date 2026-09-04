package com.jsl.util;

import java.io.IOException;
import java.io.Reader;

import javax.servlet.http.HttpServletRequest;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

public class JsonRequestUtil {

    private static final Gson gson = new Gson();

    public static <T> T parseBody(HttpServletRequest request, Class<T> clazz) throws IOException {
        try (Reader reader = request.getReader()) {
            T body = gson.fromJson(reader, clazz);
            if (body == null) {
                throw new JsonSyntaxException("empty body");
            }
            return body;
        } catch (JsonSyntaxException e) {
            throw new IOException("リクエストの形式が正しくありません。", e);
        }
    }
}