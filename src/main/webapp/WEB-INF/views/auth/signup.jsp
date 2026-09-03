<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<!-- 일본어 폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap"
	rel="stylesheet">

<!-- 회원가입 CSS -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/login/signup.css">

<link rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/includes/layout.css">

</head>

<body data-context-path="${pageContext.request.contextPath}">

	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<!-- ===================== Signup ===================== -->

	<main class="signup-main">

		<div class="container">

			<div class="signup-card">

				<div class="signup-header">

					<span class="header-line"></span>

					<p class="signup-eyebrow">― MEMBERSHIP</p>

					<h1>会員登録</h1>

					<p>クマ出没マップをご利用いただくには 会員登録が必要です。</p>

				</div>


				<!-- 회원가입 Form -->

				<form method="post" action="/signup" id="signupForm">



					<!-- ID + 중복 확인 -->
					<div class="form-group">
						<label for="userId">ID</label>

						<div class="availability-row">
							<div class="input-wrapper flex-grow-1">
								<i class="bi bi-person"></i> <input type="text" id="userId"
									name="userId" class="form-control" placeholder="IDを入力"
									autocomplete="username" required>
							</div>

							<button type="button" id="checkUserIdBtn"
								class="availability-btn">重複確認</button>
						</div>

						<p id="userIdCheckMessage" class="availability-message"
							aria-live="polite"></p>
					</div>


					<!-- 이름 -->

					<div class="form-group">

						<label for="userName"> お名前 </label>

						<div class="input-wrapper">

							<i class="bi bi-person"></i> <input type="text" id="userName"
								name="userName" class="form-control" placeholder="お名前を入力"
								required>

						</div>

					</div>


					<!-- 이메일 + 인증번호 발송 -->
					<div class="form-group">
						<label for="email">メールアドレス</label>

						<div class="email-auth-row">
							<div class="input-wrapper flex-grow-1">
								<i class="bi bi-envelope"></i> <input type="email" id="email"
									name="email" class="form-control"
									placeholder="example@email.com" autocomplete="email" required>
							</div>

							<button type="button" id="sendVerificationBtn"
								class="email-auth-btn">重複確認・認証送信</button>

						</div>

						<p id="emailAuthMessage" class="email-auth-message"
							aria-live="polite"></p>
					</div>

					<!-- 인증번호 확인: 발송 후 표시 -->
					<div id="verificationArea"
						class="form-group verification-area d-none">
						<label for="verificationCode">認証番号</label>

						<div class="email-auth-row">
							<div class="input-wrapper flex-grow-1">
								<i class="bi bi-shield-check"></i> <input type="text"
									id="verificationCode" class="form-control"
									placeholder="メールで届いた認証番号を入力" inputmode="numeric" maxlength="6">
							</div>

							<button type="button" id="verifyEmailBtn"
								class="email-auth-btn verify-btn">認証する</button>
						</div>
					</div>


					<!-- 전화번호 -->

					<div class="form-group">

						<label for="phone"> 電話番号 </label>

						<div class="input-wrapper">

							<i class="bi bi-telephone"></i> <input type="tel" id="phone"
								name="phone" class="form-control" placeholder="09012345678"
								inputmode="numeric" pattern="[0-9]*" maxlength="11">

						</div>

					</div>


					<!-- 비밀번호 -->

					<div class="form-group">

						<label for="userPw"> パスワード </label>

						<div class="input-wrapper">

							<i class="bi bi-lock"></i> <input type="password" id="userPw"
								name="userPw" class="form-control password-input"
								placeholder="パスワードを入力" required>
							<button type="button" class="password-toggle"
								data-target="userPw" aria-label="パスワードを表示">
								<i class="bi bi-eye"></i>
							</button>

						</div>

						<p class="form-help">8文字以上で入力してください。</p>

					</div>


					<!-- 비밀번호 확인 -->

					<div class="form-group">

						<label for="passwordConfirm"> パスワード（確認） </label>

						<div class="input-wrapper">

							<i class="bi bi-shield-lock"></i> <input type="password"
								id="passwordConfirm" name="passwordConfirm"
								class="form-control password-input" placeholder="もう一度入力してください"
								required>
							<button type="button" class="password-toggle"
								data-target="passwordConfirm" aria-label="パスワードを表示">
								<i class="bi bi-eye"></i>
							</button>

						</div>

					</div>


					<!-- 약관 -->

					<div class="agreement-box">

						<label class="agreement-label"> <input type="checkbox"
							id="agree" required> <span> 利用規約とプライバシーポリシーに同意します。
						</span>

						</label>

					</div>


					<!-- 가입 버튼 -->


					<button type="submit" id="signupBtn" class="signup-submit-btn"
						disabled>

						会員登録する <i class="bi bi-arrow-right"></i>

					</button>


					<!-- 로그인으로 -->

					<div class="login-link-area">

						<p>すでにアカウントをお持ちの方</p>

						<a href="/login"> ログインはこちら </a>

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

	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>

</body>

</html>
