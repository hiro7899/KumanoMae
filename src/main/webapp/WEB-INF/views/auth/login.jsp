<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>ログイン - クマ出没マップ</title>

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

<!-- 로그인 화면 전용 CSS -->
<link rel="stylesheet" href="/resources/css/login.css">

</head>

<body>

<!-- ===================== Navbar ===================== -->
<nav class="navbar navbar-jp">
    <div class="container d-flex align-items-center justify-content-between">

        <!-- 로고 -->
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

        <!-- 메인으로 -->
        <a href="/" class="back-home">
            <i class="bi bi-house-door-fill"></i>
            ホームへ戻る
        </a>

    </div>
</nav>


<!-- ===================== Login ===================== -->
<main class="login-main">

    <div class="container">

        <div class="login-wrapper">

            <!-- 왼쪽 설명 영역 -->
            <div class="login-intro">

                <p class="intro-eyebrow">
                    ― MEMBERS
                </p>

                <h1>
                    ログイン
                </h1>

                <p class="intro-title">
                    クマ出没マップへ<br>
                    ようこそ。
                </p>

                <p class="intro-text">
                    ログインすると、目撃情報の確認や
                    今後追加される会員向けサービスを
                    ご利用いただけます。
                </p>

                <div class="intro-warning">
                    <i class="bi bi-shield-exclamation"></i>

                    <span>
                        安全のため、アカウント情報を
                        他人と共有しないでください。
                    </span>
                </div>

            </div>


            <!-- 오른쪽 로그인 폼 -->
            <div class="login-card">

                <div class="login-card-header">
                    <span class="header-line"></span>
                    <h2>ログイン</h2>
                    <p>アカウント情報を入力してください</p>
                </div>


                <form>

                    <!-- 이메일 -->
                    <div class="form-group">

                        <label for="email">
                            メールアドレス
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
                    <div class="form-group">

                        <div class="password-label">

                            <label for="password">
                                パスワード
                            </label>

                            <a href="#" class="forgot-password">
                                パスワードを忘れた方
                            </a>

                        </div>

                        <div class="input-wrapper">

                            <i class="bi bi-lock"></i>

                            <input
                                type="password"
                                id="password"
                                class="form-control"
                                placeholder="パスワードを入力"
                            >

                        </div>

                    </div>


                    <!-- 로그인 버튼 -->
                    <button type="button" class="login-btn">
                        ログイン
                        <i class="bi bi-arrow-right"></i>
                    </button>


                    <!-- 구분선 -->
                    <div class="form-divider">
                        <span>または</span>
                    </div>


                    <!-- 회원가입 -->
                    <div class="signup-area">

                        <p>
                            アカウントをお持ちでない方
                        </p>

                        <a href="/signup.jsp" class="signup-btn">
                            会員登録はこちら
                        </a>

                    </div>

                </form>

            </div>

        </div>

    </div>

</main>


<!-- ===================== Footer ===================== -->
<footer class="login-footer">

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
