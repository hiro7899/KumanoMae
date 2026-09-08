<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>情報修正 - 熊の前</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<!-- 마이페이지와 같은 카드/버튼 스타일을 그대로 사용 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/mypage.css">
<!-- 이 페이지의 폼 입력 요소 전용 스타일만 추가 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/user/settings.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>
<main class="mypage-main">
    <div class="container mypage-container settings-container">

        <section class="mypage-hero">
            <div class="mypage-avatar"><i class="bi bi-gear-fill"></i></div>
            <div>
                <p class="mypage-eyebrow">SETTINGS</p>
                <h1>情報修正</h1>
                <p class="mb-0">お名前・電話番号・パスワードを変更できます。</p>
            </div>
        </section>

        <c:if test="${not empty errorMessage}">
            <div class="settings-alert is-error">
                <i class="bi bi-exclamation-circle-fill me-2"></i>${errorMessage}
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="settings-alert is-success">
                <i class="bi bi-check-circle-fill me-2"></i>${successMessage}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/settings" method="post">

            <section class="mypage-card">
                <h2><i class="bi bi-person-vcard me-2"></i>基本情報</h2>

                <div class="settings-field">
                    <label for="userName">お名前</label>
                    <input type="text" id="userName" name="userName" class="settings-input"
                           value="${userName}" maxlength="30" required>
                </div>

                <div class="settings-field">
                    <label for="phone">電話番号</label>
                    <input type="tel" id="phone" name="phone" class="settings-input"
                           value="${phone}" placeholder="例）01012345678" pattern="[0-9\-]{9,13}">
                    <p class="settings-help">ハイフンなしでも入力できます。</p>
                </div>

                <hr class="settings-divider">

                <h2><i class="bi bi-shield-lock me-2"></i>パスワード変更</h2>
                <p class="settings-help mb-3">変更しない場合は空欄のままにしてください。</p>

                <div class="settings-field">
                    <label for="currentPassword">現在のパスワード</label>
                    <input type="password" id="currentPassword" name="currentPassword"
                           class="settings-input" autocomplete="current-password">
                </div>

                <div class="settings-field">
                    <label for="newPassword">新しいパスワード</label>
                    <input type="password" id="newPassword" name="newPassword"
                           class="settings-input" autocomplete="new-password"
                           minlength="8" placeholder="8文字以上">
                </div>

                <div class="settings-field">
                    <label for="newPasswordConfirm">新しいパスワード（確認）</label>
                    <input type="password" id="newPasswordConfirm" name="newPasswordConfirm"
                           class="settings-input" autocomplete="new-password">
                    <p id="passwordMismatchMsg" class="settings-help is-error" hidden>
                        パスワードが一致しません。
                    </p>
                </div>
            </section>

            <div class="settings-actions">
                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-mypage-outline">
                    <i class="bi bi-arrow-left me-1"></i>戻る
                </a>
                <button type="submit" class="btn btn-mypage-primary">
                    <i class="bi bi-check2-circle me-1"></i>保存する
                </button>
            </div>
        </form>

    </div>
</main>
<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const newPw = document.getElementById("newPassword");
    const newPwConfirm = document.getElementById("newPasswordConfirm");
    const mismatchMsg = document.getElementById("passwordMismatchMsg");
    const form = document.querySelector(".settings-container form");

    function checkPasswordMatch() {
        const hasInput = newPw.value.length > 0 || newPwConfirm.value.length > 0;
        const mismatch = hasInput && newPw.value !== newPwConfirm.value;
        mismatchMsg.hidden = !mismatch;
        return !mismatch;
    }

    newPw?.addEventListener("input", checkPasswordMatch);
    newPwConfirm?.addEventListener("input", checkPasswordMatch);

    form?.addEventListener("submit", function (e) {
        if (!checkPasswordMatch()) {
            e.preventDefault();
            newPwConfirm.focus();
        }
    });
</script>
</body>
</html>
