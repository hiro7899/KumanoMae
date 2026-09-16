<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>パスワード再設定 - 熊の前</title>

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
	href="${pageContext.request.contextPath}/resources/css/login/reset_password.css">
</head>

<body>

	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<main class="reset-password-main">
		<div class="container">
			<section class="reset-password-card">

				<c:choose>
					<c:when test="${param.success eq 'true'}">

						<div class="reset-success-icon">
							<i class="bi bi-check-lg"></i>
						</div>

						<p class="reset-eyebrow">― ACCOUNT RECOVERY</p>

						<h1 class="reset-success-title">
							パスワードを<br>再設定しました
						</h1>

						<p class="reset-success-text">
							パスワードの再設定が完了しました。<br> 下のボタンからログインしてください。
						</p>

						<a href="${pageContext.request.contextPath}/login"
							class="reset-request-btn"> ログインする <i
							class="bi bi-arrow-right"></i>
						</a>

					</c:when>

					<c:when test="${tokenValid}">

						<div class="reset-password-header">
							<span class="reset-header-line"></span>

							<h1>パスワードを再設定</h1>

							<p>
								新しいパスワードを入力してください。<br> 8文字以上で設定できます。
							</p>
						</div>

						<c:if test="${not empty errorMsg}">
							<div class="reset-server-message" role="alert">
								<i class="bi bi-exclamation-circle-fill"></i>
								<c:out value="${errorMsg}" />
							</div>
						</c:if>

						<form method="post"
							action="${pageContext.request.contextPath}/reset-password"
							id="resetPasswordForm" novalidate>

							<input type="hidden" name="token"
								value="<c:out value='${token}'/>">

							<div class="reset-form-group">
								<label for="newPw">新しいパスワード</label>

								<div class="reset-input-wrapper">
									<i class="bi bi-lock"></i> <input type="password" id="newPw"
										name="newPw" class="form-control" placeholder="新しいパスワードを入力"
										autocomplete="new-password" minlength="8" required>

									<button type="button" class="reset-password-toggle"
										data-target="newPw" aria-label="パスワードを表示">
										<i class="bi bi-eye"></i>
									</button>
								</div>

								<p id="newPwMessage" class="reset-input-message"
									aria-live="polite">8文字以上で入力してください。</p>
							</div>

							<div class="reset-form-group">
								<label for="newPwConfirm">新しいパスワード（確認）</label>

								<div class="reset-input-wrapper">
									<i class="bi bi-shield-lock"></i> <input type="password"
										id="newPwConfirm" name="newPwConfirm" class="form-control"
										placeholder="もう一度入力してください" autocomplete="new-password"
										minlength="8" required>

									<button type="button" class="reset-password-toggle"
										data-target="newPwConfirm" aria-label="パスワードを表示">
										<i class="bi bi-eye"></i>
									</button>
								</div>

								<p id="newPwConfirmMessage" class="reset-input-message"
									aria-live="polite"></p>
							</div>

							<button type="submit" class="reset-submit-btn">
								パスワードを再設定する <i class="bi bi-arrow-right"></i>
							</button>

							<div class="reset-link-area">
								<a href="${pageContext.request.contextPath}/login">
									ログイン画面へ戻る </a>
							</div>
						</form>

					</c:when>

					<c:otherwise>

						<div class="reset-invalid-icon">
							<i class="bi bi-link-45deg"></i>
						</div>

						<p class="reset-eyebrow">― ACCOUNT RECOVERY</p>

						<h1 class="reset-invalid-title">
							再設定リンクを<br>確認してください
						</h1>

						<p class="reset-invalid-text">
							このリンクは無効か、有効期限が切れています。<br> もう一度パスワード再設定を行ってください。
						</p>

						<div class="reset-invalid-notice">
							<i class="bi bi-info-circle"></i> <span>再設定リンクの有効期限は1時間です。</span>
						</div>

						<div class="reset-invalid-actions">
							<a href="${pageContext.request.contextPath}/find_pw"
								class="reset-request-btn"> 再設定メールを送信する <i
								class="bi bi-arrow-right"></i>
							</a> <a href="${pageContext.request.contextPath}/login"
								class="reset-login-link"> ログイン画面へ戻る </a>
						</div>

					</c:otherwise>
				</c:choose>

			</section>
		</div>
	</main>

	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

	<script
		src="${pageContext.request.contextPath}/resources/js/login/reset_password.js"></script>
</body>
</html>