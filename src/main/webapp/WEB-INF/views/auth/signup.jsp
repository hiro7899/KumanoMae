<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>会員登録 - クマ出没マップ</title>

<!-- Bootstrap 5 CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">

<!-- Bootstrap Icons -->
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<!-- 일본어 폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap"
      rel="stylesheet">

<!-- 회원가입 화면 전용 CSS -->
<link rel="stylesheet" href="/resources/css/signup.css">

</head>

<body>

<!-- ===================== Navbar ===================== -->
<nav class="navbar navbar-jp">

    <div class="container d-flex align-items-center justify-content-between">

        <a href="/" class="d-flex align-items-center text-decoration-none">

            <div class="logo-badge me-2">
                熊
            </div>

            <div class="brand-jp">

                <div class="jp-title">
                    クマ出没マップ
                </div>

                <div class="jp-sub">
                    KUMA SHUTSUBOTSU MAP
                </div>

            </div>

        </a>

        <a href="/" class="back-home">
            <i class="bi bi-house-door-fill"></i>
            ホームへ戻る
        </a>

    </div>

</nav>


<!-- ===================== Signup ===================== -->
<main class="signup-main">

    <div class="container">

        <div class="signup-header">

            <p>
                ― MEMBERS
            </p>

            <h1>
                会員登録
            </h1>

            <span>
                クマ出没マップのサービスをご利用いただくには
                会員登録が必要です。
            </span>

        </div>


        <div class="signup-card">

            <form>

                <!-- ユーザー名 -->
                <div class="form-section">

                    <label for="username">
                        ユーザー名
                        <span class="required">必須</span>
                    </label>

                    <div class="input-wrapper">

                        <i class="bi bi-person"></i>

                        <input
                            type="text"
                            id="username"
                            class="form-control"
                            placeholder="ユーザー名を入力してください"
                        >

                    </div>

                    <p class="form-help">
                        画面上で表示される名前です。
                    </p>

                </div>


                <!-- 이메일 -->
                <div class="form-section">

                    <label for="email">
                        メールアドレス
                        <span class="required">必須</span>
                    </label>

                    <div class="input-wrapper">

                        <i class="bi bi-envelope"></i>

                        <input
                            type="email"
                            id="email"
                            class="form-control"
                            placeholder="example@email.com"
                        >

                    </div>

                </div>


                <!-- 비밀번호 -->
                <div class="form-section">

                    <label for="password">
                        パスワード
                        <span class="required">必須</span>
                    </label>

                    <div class="input-wrapper">

                        <i class="bi bi-lock"></i>

                        <input
                            type="password"
                            id="password"
                            class="form-control"
                            placeholder="パスワードを入力してください"
                        >

                    </div>

                    <p class="form-help">
                        8文字以上のパスワードを設定してください。
                    </p>

                </div>


                <!-- 비밀번호 확인 -->
                <div class="form-section">

                    <label for="passwordConfirm">
                        パスワード確認
                        <span class="required">必須</span>
                    </label>

                    <div class="input-wrapper">

                        <i class="bi bi-lock-fill"></i>

                        <input
                            type="password"
                            id="passwordConfirm"
                            class="form-control"
                            placeholder="もう一度入力してください"
                        >

                    </div>

                </div>


                <!-- 이용약관 -->
                <div class="agreement-box">

                    <label class="agreement-label">

                        <input
                            type="checkbox"
                            id="agree"
                        >

                        <span>
                            利用規約とプライバシーポリシーに同意します。
                        </span>

                    </label>

                </div>


                <!-- 회원가입 버튼 -->
                <button type="button" class="signup-submit">
                    会員登録
                    <i class="bi bi-arrow-right"></i>
                </button>


                <!-- 로그인으로 -->
                <div class="login-link-area">

                    <span>
                        すでにアカウントをお持ちですか？
                    </span>

                    <a href="/login.jsp">
                        ログインはこちら
                    </a>

                </div>

            </form>

        </div>

    </div>

</main>


<!-- ===================== Footer ===================== -->
<footer class="signup-footer">

    <div class="container text-center">

        <div class="footer-logo">
            <span>熊</span>
            クマ出没マップ
        </div>

        <p>
            里山に近づく足音を見逃さない。
        </p>

        <div class="footer-copy">
            © 2026 BearSafe Inc. All Rights Reserved.
        </div>

    </div>

</footer>
```

</body>
</html>
