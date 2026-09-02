<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="ja">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>会員登録 - クマ出没マップ</title>

    <!-- Bootstrap 5 -->
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link
        rel="stylesheet"
        href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

    <!-- 일본어 폰트 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link
        href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap"
        rel="stylesheet">

    <!-- 회원가입 CSS -->
    <link rel="stylesheet" href="/resources/css/login/signup.css">

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

        <div class="signup-card">

            <div class="signup-header">

                <span class="header-line"></span>

                <p class="signup-eyebrow">
                    ― MEMBERSHIP
                </p>

                <h1>
                    会員登録
                </h1>

                <p>
                    クマ出没マップをご利用いただくには
                    会員登録が必要です。
                </p>

            </div>


            <!-- 회원가입 Form -->

            <form method="post" action="/signup" id="signupForm">
            
            

                <!-- 아이디 -->

                <div class="form-group">

                    <label for="userId">
                        ID
                    </label>

                    <div class="input-wrapper">

                        <i class="bi bi-person"></i>

                        <input
                            type="text"
                            id="userId"
                            name="userId"
                            class="form-control"
                            placeholder="IDを入力"
                            required>

                    </div>

                </div>


                <!-- 이름 -->

                <div class="form-group">

                    <label for="userName">
                        お名前
                    </label>

                    <div class="input-wrapper">

                        <i class="bi bi-person"></i>

                        <input
                            type="text"
                            id="userName"
                            name="userName"
                            class="form-control"
                            placeholder="お名前を入力"
                            required>

                    </div>

                </div>


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
                            name="email"
                            class="form-control"
                            placeholder="example@email.com"
                            required>

                    </div>

                </div>


                <!-- 전화번호 -->

                <div class="form-group">

                    <label for="phone">
                        電話番号
                    </label>

                    <div class="input-wrapper">

                        <i class="bi bi-telephone"></i>

                        <input
                            type="tel"
                            id="phone"
                            name="phone"
                            class="form-control"
                            placeholder="電話番号を入力">

                    </div>

                </div>


                <!-- 비밀번호 -->

                <div class="form-group">

                    <label for="userPw">
                        パスワード
                    </label>

                    <div class="input-wrapper">

                        <i class="bi bi-lock"></i>

                        <input
                            type="password"
                            id="userPw"
                            name="userPw"
                            class="form-control"
                            placeholder="パスワードを入力"
                            required>

                    </div>

                    <p class="form-help">
                        8文字以上で入力してください。
                    </p>

                </div>


                <!-- 비밀번호 확인 -->

                <div class="form-group">

                    <label for="passwordConfirm">
                        パスワード（確認）
                    </label>

                    <div class="input-wrapper">

                        <i class="bi bi-shield-lock"></i>

                        <input
                            type="password"
                            id="passwordConfirm"
                            name="passwordConfirm"
                            class="form-control"
                            placeholder="もう一度入力してください"
                            required>

                    </div>

                </div>


                <!-- 약관 -->

                <div class="agreement-box">

                    <label class="agreement-label">

                        <input
                            type="checkbox"
                            id="agree"
                            required>

                        <span>
                            利用規約とプライバシーポリシーに同意します。
                        </span>

                    </label>

                </div>


                <!-- 가입 버튼 -->


                <button
                    type="submit"
                    id="signupBtn"
                    class="signup-submit-btn">

                    会員登録する

                    <i class="bi bi-arrow-right"></i>

                </button>


                <!-- 로그인으로 -->

                <div class="login-link-area">

                    <p>
                        すでにアカウントをお持ちの方
                    </p>

                    <a href="/login">
                        ログインはこちら
                    </a>

                </div>

            </form>

        </div>

    </div>

</main>


<!-- Bootstrap 5 JS -->

<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

<!-- 회원가입 화면 전용 JS -->

<script src="/resources/js/login/signup.js"></script>

</body>

</html>
