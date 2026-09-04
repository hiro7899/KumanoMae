package com.jsl.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailUtil {

    private static final String SENDER_EMAIL;
    private static final String SENDER_PASSWORD;

    static {
        Properties config = new Properties();

        try (InputStream in = EmailUtil.class.getClassLoader()
                .getResourceAsStream("mail.properties")) {

            if (in == null) {
                throw new ExceptionInInitializerError(
                        "mail.properties를 찾을 수 없습니다 (WEB-INF/classes 확인).");
            }

            config.load(in);

        } catch (IOException e) {
            throw new ExceptionInInitializerError(
                    "mail.properties 로딩 실패: " + e.getMessage());
        }

        SENDER_EMAIL = config.getProperty("mail.smtp.username");
        SENDER_PASSWORD = config.getProperty("mail.smtp.password");
    }

    public static void send(String toEmail, String subject, String htmlBody) {

        Properties props = new Properties();

        props.put("mail.smtp.auth", "true");

        // Gmail SMTP STARTTLS
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");

        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        // TLS 1.2 명시
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {

            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(
                        SENDER_EMAIL,
                        SENDER_PASSWORD
                );
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);

            message.setFrom(
                    new InternetAddress(SENDER_EMAIL, "KumanoMae")
            );

            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(toEmail)
            );

            message.setSubject(subject, "UTF-8");
            message.setContent(
                    htmlBody,
                    "text/html; charset=UTF-8"
            );

            Transport.send(message);

        } catch (Exception e) {
            throw new RuntimeException(
                    "メール送信に失敗しました。",
                    e
            );
        }
    }
}