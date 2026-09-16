<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>メール認証 - 熊の前</title>

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
	href="${pageContext.request.contextPath}/resources/css/login/signup.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/includes/layout.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/login/verify_email.css">
</head>

<body data-context-path="${pageContext.request.contextPath}">

	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<main class="verify-email-main">
		<div class="container">
			<section class="verify-email-card">

				<div id="verificationIcon" class="verification-icon is-loading"
					aria-hidden="true">
					<i class="bi bi-envelope-check"></i>
				</div>

				<p class="verification-eyebrow">― EMAIL VERIFICATION</p>

				<h1 id="verificationTitle">
					メール認証を<br>確認しています
				</h1>

				<p id="verificationMessage" class="verification-message"
					aria-live="polite">
					認証リンクを確認しています。<br> しばらくお待ちください。
				</p>

				<div id="verificationGuide" class="verification-guide">
					<i class="bi bi-shield-check"></i>
					<div>
						<strong>安全にサービスをご利用いただくために</strong>
						<p>
							メール認証が完了すると、投稿・コメントなどの<br> 会員機能をご利用いただけるようになります。
						</p>
					</div>
				</div>

				<div id="verificationActions" class="verification-actions" hidden>
					<a id="loginLink"
						href="${pageContext.request.contextPath}/login?verified=true"
						class="verification-login-btn"> ログイン画面へ <i
						class="bi bi-arrow-right"></i>
					</a> <a href="${pageContext.request.contextPath}/"
						class="verification-home-link"> トップページへ戻る </a>
				</div>

			</section>
		</div>
	</main>

	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>

	<script>
        document.addEventListener("DOMContentLoaded", async function () {
            const contextPath = document.body.dataset.contextPath || "";
            const token = new URLSearchParams(location.search).get("token");

            const icon = document.getElementById("verificationIcon");
            const title = document.getElementById("verificationTitle");
            const message = document.getElementById("verificationMessage");
            const guide = document.getElementById("verificationGuide");
            const actions = document.getElementById("verificationActions");

            function showError(errorMessage) {
                icon.className = "verification-icon is-error";
                icon.innerHTML = '<i class="bi bi-exclamation-lg"></i>';

                title.innerHTML = "メール認証を<br>完了できませんでした";
                message.textContent = errorMessage;
                message.className = "verification-message is-error";

                guide.innerHTML =
                    '<i class="bi bi-info-circle"></i>' +
                    '<div>' +
                    '<strong>認証リンクをご確認ください</strong>' +
                    '<p>認証リンクは有効期限が切れているか、すでに使用されている可能性があります。<br>再送はログイン後、マイページから行えます。</p>' +
                    '</div>';

                actions.hidden = false;
            }

            function showSuccess() {
                icon.className = "verification-icon is-success";
                icon.innerHTML = '<i class="bi bi-check-lg"></i>';

                title.innerHTML = "メール認証が<br>完了しました";
                message.innerHTML =
                    "認証が完了しました。<br>下のボタンからログインしてください。";
                message.className = "verification-message is-success";

                guide.innerHTML =
                    '<i class="bi bi-check-circle-fill"></i>' +
                    '<div>' +
                    '<strong>すべての会員機能をご利用いただけます</strong>' +
                    '<p>目撃情報の投稿、コミュニティへの投稿・コメントなどを<br>ご利用いただけるようになりました。</p>' +
                    '</div>';

                actions.hidden = false;

            }

            if (!token) {
                showError("認証情報が見つかりません。メール内の認証リンクをもう一度ご確認ください。");
                return;
            }

            try {
                const response = await fetch(
                    contextPath + "/api/email-verification/verify",
                    {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                        },
                        body: new URLSearchParams({ token: token })
                    }
                );

                const result = await response.json();

                if (!response.ok || !result.success) {
                    throw new Error(
                        result.message || "メール認証に失敗しました。"
                    );
                }

                showSuccess();

            } catch (error) {
                showError(error.message);
            }
        });
    </script>
</body>
</html>