login.js
document.addEventListener("DOMContentLoaded", function() {
	const loginForm = document.querySelector("form[action='/login']");
	const userIdInput = document.getElementById("userId");
	const passwordInput = document.getElementById("userPw");

	document.querySelectorAll(".password-toggle").forEach(function(button) {
		button.addEventListener("click", function() {
			const target = document.getElementById(button.dataset.target);
			const icon = button.querySelector("i");
			const isHidden = target.type === "password";

			target.type = isHidden ? "text" : "password";
			icon.className = isHidden ? "bi bi-eye-slash" : "bi bi-eye";
			button.setAttribute(
				"aria-label",
				isHidden ? "パスワードを隠す" : "パスワードを表示"
			);
		});
	});

	if (!loginForm) {
		return;
	}
	const resendEmailInput = document.getElementById("resendEmail");
	const resendVerificationBtn = document.getElementById("resendVerificationBtn");
	const resendMessage = document.getElementById("resendMessage");
	const contextPath = document.body.dataset.contextPath || "";

	if (resendVerificationBtn) {
		resendVerificationBtn.addEventListener("click", async function() {
			const email = resendEmailInput.value.trim();
			const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

			if (!emailPattern.test(email)) {
				resendMessage.textContent =
					"正しいメールアドレスを入力してください。";
				resendMessage.className = "resend-message error";
				resendEmailInput.focus();
				return;
			}

			resendVerificationBtn.disabled = true;
			resendMessage.textContent = "認証メールを送信しています。";
			resendMessage.className = "resend-message";

			try {
				const response = await fetch(
					contextPath + "/api/email-verification/send?email="
					+ encodeURIComponent(email),
					{
						method: "POST",
						headers: {
							"Content-Type": "application/json"
						},
						body: JSON.stringify({
							email: email
						})
					}
				);

				const result = await response.json();

				if (!response.ok || !result.success) {
					throw new Error(
						result.message || "認証メールの送信に失敗しました。"
					);
				}

				resendMessage.textContent =
					"認証メールを再送信しました。受信トレイをご確認ください。";
				resendMessage.className = "resend-message success";
			} catch (error) {
				resendMessage.textContent =
					error.message || "認証メールの再送信に失敗しました。";
				resendMessage.className = "resend-message error";
			} finally {
				resendVerificationBtn.disabled = false;
			}
		});
	}

	loginForm.addEventListener("submit", function(event) {
		if (userIdInput.value.trim() === "") {
			event.preventDefault();
			alert("IDまたはメールアドレスを入力してください。");
			userIdInput.focus();
			return;
		}

		if (passwordInput.value.trim() === "") {
			event.preventDefault();
			alert("パスワードを入力してください。");
			passwordInput.focus();
		}
	});
});