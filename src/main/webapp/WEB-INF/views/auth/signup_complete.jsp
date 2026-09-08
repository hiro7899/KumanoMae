<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>会員登録完了 - 熊の前</title>

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
        href="${pageContext.request.contextPath}/resources/css/login/signup.css">

    <link rel="stylesheet"
        href="${pageContext.request.contextPath}/resources/css/login/signup_complete.css">
</head>

<body>

    <%@ include file="/WEB-INF/views/includes/header.jsp"%>

    <main class="signup-complete-main">
        <div class="container">

            <section class="signup-complete-card">

                <div class="complete-icon" aria-hidden="true">
                    <i class="bi bi-check-lg"></i>
                </div>

                <p class="complete-eyebrow">― MEMBERSHIP</p>

                <h1>会員登録を<br>受け付けました</h1>

                <p class="complete-lead">
                    ご登録ありがとうございます。<br>
                    認証メールを送信しました。
                </p>

                <div class="complete-notice">
                    <i class="bi bi-envelope-check-fill"></i>

                    <div>
                        <strong>メール認証を完了してください</strong>
                        <p>
                            ご登録いただいたメールアドレス宛に届いた<br>
                            認証リンクをクリックすると、サービスをご利用いただけます。
                        </p>
                    </div>
                </div>

                <div class="complete-steps">
                    <div class="complete-step">
                        <span>01</span>
                        <p>受信トレイを確認する</p>
                    </div>

                    <div class="complete-step">
                        <span>02</span>
                        <p>認証リンクをクリックする</p>
                    </div>

                    <div class="complete-step">
                        <span>03</span>
                        <p>ログインして利用を開始する</p>
                    </div>
                </div>

                <p class="complete-help">
                    <i class="bi bi-info-circle"></i>
                    メールが届かない場合は、迷惑メールフォルダもご確認ください。
                </p>

                <div class="complete-actions">
                    <a href="${pageContext.request.contextPath}/"
                        class="complete-home-btn">
                        トップページへ
                        <i class="bi bi-arrow-right"></i>
                    </a>

                    <a href="${pageContext.request.contextPath}/login"
                        class="complete-login-link">
                        認証済みの方はこちらからログイン
                    </a>
                </div>

            </section>

        </div>
    </main>

    <%@ include file="/WEB-INF/views/includes/footer.jsp"%>

    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
    </script>

</body>
</html>