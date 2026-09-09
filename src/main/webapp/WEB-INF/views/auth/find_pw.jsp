<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>パスワードを忘れた方 - 熊の前</title>

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
	href="${pageContext.request.contextPath}/resources/css/login/find_pw.css">
</head>

<body>

	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<main class="findpw-main">
		<div class="container">
			<div class="findpw-card">

				<div class="findpw-header">
					<span class="header-line"></span>
					<p class="findpw-eyebrow">― ACCOUNT RECOVERY</p>
					<h1>パスワードを忘れた方</h1>
					<p>
						ご登録のIDとメールアドレスを入力してください。<br> パスワード再設定の手続きをご案内します。
					</p>
				</div>


				<%-- 백엔드 담당자가 /find_pw POST 처리 예정 --%>
				<form method="post"
					action="${pageContext.request.contextPath}/find_pw" id="findPwForm"
					novalidate>

					<div class="form-group">
						<label for="userId">ID</label>
						<div class="input-wrapper">
							<i class="bi bi-person"></i> <input type="text" id="userId"
								name="userId" class="form-control" placeholder="IDを入力"
								autocomplete="username" required>
						</div>
					</div>

					<p id="findPwUserIdMessage" class="findpw-input-message"
						aria-live="polite"></p>

					<c:if test="${errorField eq 'userId'}">
						<p class="findpw-input-message error" role="alert">
							<i class="bi bi-exclamation-circle-fill"></i>
							<c:out value="${errorMsg}" />
						</p>
					</c:if>

					<div class="form-group">
						<label for="email">メールアドレス</label>
						<div class="input-wrapper">
							<i class="bi bi-envelope"></i> <input type="email" id="email"
								name="email" class="form-control"
								placeholder="example@email.com" autocomplete="email" required>
						</div>
					</div>

					<p id="findPwEmailMessage" class="findpw-input-message"
						aria-live="polite"></p>

					<c:if test="${errorField eq 'email'}">
						<p class="findpw-input-message error" role="alert">
							<i class="bi bi-exclamation-circle-fill"></i>
							<c:out value="${errorMsg}" />
						</p>
					</c:if>

					<c:if test="${not empty resultMsg}">
						<p class="findpw-input-message success" role="status">
							<i class="bi bi-check-circle-fill"></i>
							<c:out value="${resultMsg}" />
						</p>
					</c:if>

					<button type="submit" id="findPwBtn" class="findpw-submit-btn">
						再設定手続きを進める <i class="bi bi-arrow-right"></i>
					</button>

					<div class="find-link-area">
						<a href="${pageContext.request.contextPath}/find_id"> IDをお忘れの方
						</a> <a href="${pageContext.request.contextPath}/login"> ログインはこちら
						</a>
					</div>
				</form>
			</div>
		</div>
	</main>

	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
		
	</script>
	<script
		src="${pageContext.request.contextPath}/resources/js/login/find_pw.js">
		
	</script>
</body>
</html>