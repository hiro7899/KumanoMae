package com.jsl.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class UploadPathUtil {

    private static final String UPLOAD_DIR; // 웹 경로 기준, 예: /resources/img/uploads

    static {
        Properties config = new Properties();
        try (InputStream in = UploadPathUtil.class.getClassLoader().getResourceAsStream("upload.properties")) {
            if (in == null) {
                throw new ExceptionInInitializerError("upload.properties를 찾을 수 없습니다 (WEB-INF/classes 확인).");
            }
            config.load(in);
        } catch (IOException e) {
            throw new ExceptionInInitializerError("upload.properties 로딩 실패: " + e.getMessage());
        }
        UPLOAD_DIR = config.getProperty("upload.dir");
    }

    public static String getUploadDir() {
        return UPLOAD_DIR;
    }
}