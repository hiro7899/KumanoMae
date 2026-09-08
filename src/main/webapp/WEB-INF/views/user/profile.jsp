<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>マイページ - 熊の前</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/mypage.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>
<main class="mypage-main">
    <div class="container mypage-container">
        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <section class="mypage-hero">
                    <div class="mypage-avatar"><i class="bi bi-person-fill"></i></div>
                    <div>
                        <p class="mypage-eyebrow">MY PAGE</p>
                        <div class="d-flex align-items-center gap-2 flex-wrap">
                            <h1><c:out value="${userName}"/>さま</h1>
                            <c:if test="${emailVerified == false}">
                                <span class="email-pending-badge">メール認証が必要です</span>
                            </c:if>
                        </div>
                        <p class="mb-0">アカウント情報と投稿した内容を確認できます。</p>
                    </div>
                </section>
                <div class="row g-4">
                    <aside class="col-lg-4">
                        <section class="mypage-card account-card">
                            <h2><i class="bi bi-person-vcard me-2"></i>アカウント</h2>
                            <dl class="account-list mb-0">
                                <div><dt>ID</dt><dd><c:out value="${userId}"/></dd></div>
                                <div><dt>お名前</dt><dd><c:out value="${userName}"/></dd></div>
                                <div><dt>メール</dt><dd><c:out value="${email}"/></dd></div>
                                <div><dt>電話番号</dt><dd><c:choose><c:when test="${not empty phone}"><c:out value="${phone}"/></c:when><c:otherwise>未登録</c:otherwise></c:choose></dd></div>
                                <div><dt>会員区分</dt><dd><c:choose><c:when test="${userGrade eq 'A'}">管理者</c:when><c:otherwise>一般会員</c:otherwise></c:choose></dd></div>
                                <div><dt>登録日</dt><dd><c:out value="${joinDate}"/></dd></div>
                            </dl>
                            <c:if test="${emailVerified == false}">
                                <div id="emailVerificationAction" class="mt-4">
                                    <button type="button" id="resendVerificationButton" class="btn btn-mypage-primary w-100">
                                        <i class="bi bi-envelope-arrow-up me-1"></i>認証メールを再送信する
                                    </button>
                                    <p id="resendVerificationMessage" class="resend-verification-message mb-0" aria-live="polite"></p>
                                </div>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/user/settings" class="btn btn-mypage-outline w-100 mt-2"><i class="bi bi-pencil-square me-1"></i>修正する</a>
                        </section>
                    </aside>
                    <div class="col-lg-8">
                        <section class="mypage-card mb-4">
                            <div class="mypage-section-head">
                                <div><p class="mypage-label">MY REPORTS</p><h2>私の目撃報告</h2></div>
                                <a href="${pageContext.request.contextPath}/board/report" class="btn btn-mypage-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>報告する</a>
                            </div>
                            <div class="mypage-empty"><i class="bi bi-exclamation-triangle"></i><p class="mb-0">目撃報告の履歴は、ここに表示されます。</p></div>
                        </section>
                        <section class="mypage-card">
                            <div class="mypage-section-head">
                                <div><p class="mypage-label">MY COMMUNITY</p><h2>私のコミュニティ投稿</h2></div>
                                <a href="${pageContext.request.contextPath}/community/write" class="btn btn-mypage-primary btn-sm"><i class="bi bi-pencil-square me-1"></i>投稿する</a>
                            </div>
                            <div class="mypage-empty"><i class="bi bi-chat-square-text"></i><p class="mb-0">投稿したコミュニティ記事は、ここに表示されます。</p></div>
                        </section>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <section class="mypage-login-card text-center">
                    <i class="bi bi-person-lock"></i><h1>ログインが必要です</h1>
                    <p>マイページを利用するにはログインしてください。</p>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-mypage-primary">ログインする</a>
                </section>
            </c:otherwise>
        </c:choose>
    </div>
</main>
<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const resendButton = document.getElementById("resendVerificationButton");

    resendButton?.addEventListener("click", async function () {
        const action = document.getElementById("emailVerificationAction");
        const message = document.getElementById("resendVerificationMessage");

        resendButton.disabled = true;
        message.classList.remove("is-error");
        message.textContent = "認証メールを送信しています。";

        try {
            const response = await fetch(
                "${pageContext.request.contextPath}/api/email-verification/resend-self",
                {
                    method: "POST",
                    headers: { "Content-Type": "application/json" }
                }
            );

            const data = await response.json();

            if (data.success) {
                action.innerHTML = '<p class="resend-verification-success mb-0"><i class="bi bi-check-circle-fill me-1"></i>送信しました</p>';
            } else {
                throw new Error(data.message || "メール送信に失敗しました。");
            }
        } catch (error) {
            message.textContent = error.message || "通信エラーが発生しました。しばらくしてから再度お試しください。";
            message.classList.add("is-error");

            window.setTimeout(function () {
                resendButton.disabled = false;
                message.textContent = "";
                message.classList.remove("is-error");
            }, 5000);
        }
    });
</script>
</body>
</html>
