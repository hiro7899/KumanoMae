package com.jsl.controller.api;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jsl.service.community.CommunityLikeToggleService;
import com.jsl.service.member.EmailVerificationSendService;
import com.jsl.service.member.EmailVerificationStatusService;
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
    private final EmailVerificationStatusService emailVerificationStatusService = new EmailVerificationStatusService();
    
    private final CommunityLikeToggleService communityLikeToggleService = new CommunityLikeToggleService();

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
            JsonResponseUtil.writeError(response, 404, "存在しないAPIです。");
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
                case "/email-verification/status":
                    emailVerificationStatusService.doCommand(request, response);
                    break;
                    
                case "/community/like/toggle":
                    communityLikeToggleService.doCommand(request, response);
                    break;
                default:
                    JsonResponseUtil.writeError(response, 404, "存在しないAPIです。");
            }
        } catch (IOException e) {
            // JsonRequestUtil.parseBody()가 JSON 형식 오류 시 던지는 IOException
            JsonResponseUtil.writeError(response, 400, e.getMessage());
        } catch (RuntimeException e) {
            e.printStackTrace();
            JsonResponseUtil.writeError(response, 500, "サーバーエラーが発生しました。");
        }
    }
}