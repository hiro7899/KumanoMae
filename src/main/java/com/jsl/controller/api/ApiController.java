package com.jsl.controller.api;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.service.member.EmailVerificationSendService;
import com.jsl.service.member.EmailVerifyService;
import com.jsl.service.signup.CheckEmailService;
import com.jsl.service.signup.CheckUserIdService;
import com.jsl.util.JsonResponseUtil;

@WebServlet("/api/*")
public class ApiController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final CheckUserIdService checkUserIdService = new CheckUserIdService();
    private final CheckEmailService checkEmailService = new CheckEmailService();
    private final EmailVerificationSendService emailVerificationSendService = new EmailVerificationSendService();
    private final EmailVerifyService emailVerifyService = new EmailVerifyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doAction(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doAction(request, response);
    }

    private void doAction(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getPathInfo();
        if (path == null) {
            JsonResponseUtil.writeError(response, 404, "존재하지 않는 API입니다.");
            return;
        }

        try {
            switch (path) {
                case "/signup/check-user-id":
                    checkUserIdService.doCommand(request, response);
                    break;

                case "/signup/check-email":
                    checkEmailService.doCommand(request, response);
                    break;

                case "/email-verification/send":
                    emailVerificationSendService.doCommand(request, response);
                    break;

                case "/email-verification/verify":
                	emailVerifyService.doCommand(request, response);
                    break;

                default:
                    JsonResponseUtil.writeError(response, 404, "존재하지 않는 API입니다.");
            }
        } catch (RuntimeException e) {
            e.printStackTrace();
            JsonResponseUtil.writeError(response, 500, "サーバーエラーが発生しました。");
        }
    }
}