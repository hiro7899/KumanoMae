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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/index.css?v=home-sections-3">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/mypage.css">
<style>
/* 마이페이지 카드 전용 오버라이드: 썸네일 세로 길이 축소 + 카드 테두리 강조 */
.mypage-card .preview-card-image {
    height: 140px !important;
    max-height: 140px !important;
    overflow: hidden;
}
.mypage-card .preview-card-image img.preview-card-thumb {
    width: 100% !important;
    height: 100% !important;
    object-fit: cover !important;
}
.mypage-card .preview-card.report-card {
    border: 2px solid #cfc4ae;
}
</style>
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

                        <%-- ===================== 私の目撃報告 ===================== --%>
                        <section class="mypage-card mb-4">
                            <div class="mypage-section-head">
                                <div><p class="mypage-label">MY REPORTS</p><h2>私の目撃報告</h2></div>
                                <a href="${pageContext.request.contextPath}/board/report" class="btn btn-mypage-primary btn-sm"><i class="bi bi-plus-lg me-1"></i>報告する</a>
                            </div>
                            <c:choose>
                                <c:when test="${not empty boardList}">
                                    <div class="row g-4 mt-1">
                                        <c:forEach var="report" items="${boardList}" end="2">
                                            <div class="col-md-4 col-sm-6">
                                                <article class="card h-100 report-card preview-card clickable-card"
                                                    data-card-href="${pageContext.request.contextPath}/board/detail?boardId=${report.boardId}">
                                                    <c:set var="reportFallbackClass" value="preview-card-image-safe" />
                                                    <c:if test="${report.riskLevel eq 'DANGER'}"><c:set var="reportFallbackClass" value="preview-card-image-danger" /></c:if>
                                                    <c:if test="${report.riskLevel eq 'WARNING'}"><c:set var="reportFallbackClass" value="preview-card-image-caution" /></c:if>
                                                    <c:choose>
                                                        <c:when test="${not empty report.fileList}">
                                                            <c:forEach var="rf" items="${report.fileList}" varStatus="rfStatus">
                                                                <c:if test="${rfStatus.index eq 0}">
                                                                    <div class="preview-card-image" data-fallback-class="${reportFallbackClass}">
                                                                        <img src="${pageContext.request.contextPath}${rf.filePath}/${rf.saveName}"
                                                                            class="preview-card-thumb" alt="目撃情報画像"
                                                                            onerror="this.onerror=null;var box=this.closest('.preview-card-image');this.remove();box.classList.add('preview-card-image-fallback', box.dataset.fallbackClass);box.innerHTML='<i class=&quot;bi bi-image-alt&quot;></i>';">
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:choose>
                                                                <c:when test="${report.riskLevel eq 'DANGER'}">
                                                                    <div class="preview-card-image preview-card-image-danger">
                                                                        <i class="bi bi-exclamation-triangle-fill"></i>
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${report.riskLevel eq 'WARNING'}">
                                                                    <div class="preview-card-image preview-card-image-caution">
                                                                        <i class="bi bi-signpost-split-fill"></i>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="preview-card-image preview-card-image-safe">
                                                                        <i class="bi bi-shield-check"></i>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div class="card-body d-flex flex-column">
                                                        <div class="mypage-post-badges">
                                                            <c:choose>
                                                                <c:when test="${report.riskLevel eq 'DANGER'}"><span class="badge badge-danger-custom">危険</span></c:when>
                                                                <c:when test="${report.riskLevel eq 'WARNING'}"><span class="badge badge-warning-custom">警戒</span></c:when>
                                                                <c:otherwise><span class="badge badge-caution-custom">注意</span></c:otherwise>
                                                            </c:choose>
                                                            <c:if test="${report.status eq 'W'}"><span class="badge bg-warning text-dark">承認待ち</span></c:if>
                                                            <c:if test="${report.status eq 'N'}"><span class="badge bg-danger">反려됨</span></c:if>
                                                            <c:if test="${report.clearYn eq 'Y'}"><span class="badge bg-secondary">危険解除済み</span></c:if>
                                                        </div>
                                                        <h3 class="card-title mypage-post-title"><c:out value="${report.title}"/></h3>
                                                        <p class="mypage-post-date mb-0"><i class="bi bi-clock-fill me-1"></i><c:out value="${report.regDate}"/></p>
                                                    </div>
                                                </article>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="mypage-empty"><i class="bi bi-exclamation-triangle"></i><p class="mb-0">目撃報告の履歴は、ここに表示されます。</p></div>
                                </c:otherwise>
                            </c:choose>
                        </section>

                        <%-- ===================== 私のコミュニティ投稿 ===================== --%>
                        <section class="mypage-card">
                            <div class="mypage-section-head">
                                <div><p class="mypage-label">MY COMMUNITY</p><h2>私のコミュニティ投稿</h2></div>
                                <a href="${pageContext.request.contextPath}/community/write" class="btn btn-mypage-primary btn-sm"><i class="bi bi-pencil-square me-1"></i>投稿する</a>
                            </div>
                            <c:choose>
                                <c:when test="${not empty communityList}">
                                    <div class="row g-4 mt-1">
                                        <c:forEach var="post" items="${communityList}" end="2">
                                            <div class="col-md-4 col-sm-6">
                                                <article class="card h-100 report-card preview-card clickable-card"
                                                    data-card-href="${pageContext.request.contextPath}/community/detail?cBoardId=${post.cBoardId}">
                                                    <c:set var="postFallbackClass" value="preview-card-image-talk" />
                                                    <c:if test="${post.category eq 'GEAR'}"><c:set var="postFallbackClass" value="preview-card-image-gear" /></c:if>
                                                    <c:if test="${post.category eq 'REVIEW'}"><c:set var="postFallbackClass" value="preview-card-image-trail" /></c:if>
                                                    <c:choose>
                                                        <c:when test="${not empty post.fileList}">
                                                            <c:forEach var="pf" items="${post.fileList}" varStatus="pfStatus">
                                                                <c:if test="${pfStatus.index eq 0}">
                                                                    <div class="preview-card-image" data-fallback-class="${postFallbackClass}">
                                                                        <img src="${pageContext.request.contextPath}${pf.filePath}/${pf.saveName}"
                                                                            class="preview-card-thumb" alt="コミュニティ投稿画像"
                                                                            onerror="this.onerror=null;var box=this.closest('.preview-card-image');this.remove();box.classList.add('preview-card-image-fallback', box.dataset.fallbackClass);box.innerHTML='<i class=&quot;bi bi-image-alt&quot;></i>';">
                                                                    </div>
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:choose>
                                                                <c:when test="${post.category eq 'GEAR'}">
                                                                    <div class="preview-card-image preview-card-image-gear">
                                                                        <i class="bi bi-backpack-fill"></i>
                                                                    </div>
                                                                </c:when>
                                                                <c:when test="${post.category eq 'REVIEW'}">
                                                                    <div class="preview-card-image preview-card-image-trail">
                                                                        <i class="bi bi-map-fill"></i>
                                                                    </div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="preview-card-image preview-card-image-talk">
                                                                        <i class="bi bi-people-fill"></i>
                                                                    </div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <div class="card-body d-flex flex-column">
                                                        <h3 class="card-title mypage-post-title"><c:out value="${post.title}"/></h3>
                                                        <p class="mypage-post-date"><i class="bi bi-clock-fill me-1"></i><c:out value="${post.regDate}"/></p>
                                                        <div class="mypage-post-meta mt-auto">
                                                            <span><i class="bi bi-eye-fill me-1"></i><c:out value="${post.viewCnt}"/></span>
                                                            <span><i class="bi bi-heart-fill me-1"></i><c:out value="${post.likeCnt}"/></span>
                                                            <span><i class="bi bi-chat-fill me-1"></i><c:out value="${post.commentCnt}"/></span>
                                                        </div>
                                                    </div>
                                                </article>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="mypage-empty"><i class="bi bi-chat-square-text"></i><p class="mb-0">投稿したコミュニティ記事は、ここに表示されます。</p></div>
                                </c:otherwise>
                            </c:choose>
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

            // 서버는 success / message 형태의 JSON을 내려줌
            const data = await response.json();

            if (data.success) {
                action.innerHTML = '<p class="resend-verification-success mb-0"><i class="bi bi-check-circle-fill me-1"></i>送信しました</p>';
                // 버튼 자체가 사라지므로 재클릭은 자연히 불가능 (최소 5초 요건 충족)
            } else {
                // 서버가 내려준 메시지를 그대로 표시 (예: 이미 인증됨, 세션 만료 등)
                throw new Error(data.message || "メール送信に失敗しました。");
            }
        } catch (error) {
            message.textContent = error.message || "通信エラーが発生しました。しばらくしてから再度お試しください。";
            message.classList.add("is-error");

            // 실패 시 연타 방지: 최소 5초간 버튼 비활성화 유지
            window.setTimeout(function () {
                resendButton.disabled = false;
                message.textContent = "";
                message.classList.remove("is-error");
            }, 5000);
        }
    });

    // 카드 클릭 시 상세 페이지로 이동 (index.jsp와 동일한 방식)
    document.querySelectorAll('.clickable-card').forEach(function (card) {
        card.addEventListener('click', function () { location.href = card.dataset.cardHref; });
        card.addEventListener('keydown', function (event) {
            if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); location.href = card.dataset.cardHref; }
        });
    });
</script>
</body>
</html>
