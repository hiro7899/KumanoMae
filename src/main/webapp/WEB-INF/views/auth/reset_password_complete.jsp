<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>パスワード再設定完了 - 熊の前</title>

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
    rel="stylesheet">

<link rel="stylesheet"
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
    href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap"
    rel="stylesheet">

<link rel="stylesheet"
    href="${pageContext.request.contextPath}/resources/css/includes/layout.css">

<link rel="stylesheet"
    href="${pageContext.request.contextPath}/resources/css/login/reset_password_complete.css">
</head>

<body>
    <%@ include file="/WEB-INF/views/includes/header.jsp"%>

    <main class="reset-complete-main">
        <div class="container">
            <section class="reset-complete-card" aria-labelledby="completeTitle">

                <div class="reset-complete-icon" aria-hidden="true">
                    <i class="bi bi-check-lg"></i>
                </div>

                <p class="reset-complete-eyebrow">― ACCOUNT RECOVERY</p>

                <h1 id="completeTitle">
                    パスワードを<br>再設定しました
                </h1>

                <p class="reset-complete-message">
                    パスワードの再設定が完了しました。<br>
                    下のボタンからログインしてください。
                </p>

                <a id="completeLoginButton"
                    href="${pageContext.request.contextPath}/login"
                    class="reset-complete-login-btn">
                    ログインする
                    <i class="bi bi-arrow-right" aria-hidden="true"></i>
                </a>
            </section>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/includes/footer.jsp"%>

    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script
        src="${pageContext.request.contextPath}/resources/js/login/reset_password_complete.js"></script>
</body>
</html>