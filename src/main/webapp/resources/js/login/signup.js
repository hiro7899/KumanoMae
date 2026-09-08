document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("signupForm");

    const userIdInput = document.getElementById("userId");
    const userNameInput = document.getElementById("userName");
    const emailInput = document.getElementById("email");
    const phoneInput = document.getElementById("phone");
    const passwordInput = document.getElementById("userPw");
    const passwordConfirmInput = document.getElementById("passwordConfirm");
    const agreeCheckbox = document.getElementById("agree");

    const checkUserIdBtn = document.getElementById("checkUserIdBtn");
    const userIdCheckMessage = document.getElementById("userIdCheckMessage");

	const checkEmailBtn = document.getElementById("checkEmailBtn");
	const emailAuthMessage = document.getElementById("emailAuthMessage");

    const signupBtn = document.getElementById("signupBtn");

    const contextPath = document.body.dataset.contextPath || "";
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

	let userIdChecked = false;
	let emailChecked = false;

    if (!form) {
        return;
    }

    function showUserIdMessage(message, type) {
        userIdCheckMessage.textContent = message;
        userIdCheckMessage.className = "availability-message " + type;
    }

    function showEmailMessage(message, type) {
        emailAuthMessage.textContent = message;
        emailAuthMessage.className = "email-auth-message " + type;
    }

	function updateSignupButton() {
	    signupBtn.disabled = !(
	        userIdChecked
	        && emailChecked
	        && agreeCheckbox.checked
	    );
	}

	agreeCheckbox.addEventListener("change", updateSignupButton);

    function resetUserIdCheck() {
        userIdChecked = false;
        showUserIdMessage("", "");
        updateSignupButton();
    }

	function resetEmailCheck() {
	    emailChecked = false;
	    showEmailMessage("", "");
	    updateSignupButton();
	}

    userIdInput.addEventListener("input", resetUserIdCheck);
    emailInput.addEventListener("input", resetEmailCheck);

    phoneInput.addEventListener("input", function () {
        phoneInput.value = phoneInput.value.replace(/\D/g, "");
    });

    checkUserIdBtn.addEventListener("click", async function () {
        const userId = userIdInput.value.trim();

        if (userId === "") {
            showUserIdMessage("IDを入力してください。", "error");
            userIdInput.focus();
            return;
        }

        checkUserIdBtn.disabled = true;
        showUserIdMessage("IDを確認しています。", "");

        try {
            const response = await fetch(
                contextPath + "/api/signup/check-user-id?userId="
                + encodeURIComponent(userId),
                { method: "GET" }
            );

            const result = await response.json();

            if (!response.ok || !result.success || !result.available) {
                throw new Error(result.message || "すでに使用されているIDです。");
            }

            userIdChecked = true;
            showUserIdMessage("使用可能なIDです。", "success");
        } catch (error) {
            userIdChecked = false;
            showUserIdMessage(error.message, "error");
        } finally {
            checkUserIdBtn.disabled = false;
            updateSignupButton();
        }
    });


	checkEmailBtn.addEventListener("click", async function () {
	    const email = emailInput.value.trim();

	    if (!emailPattern.test(email)) {
	        showEmailMessage("正しいメールアドレスを入力してください。", "error");
	        emailInput.focus();
	        return;
	    }

	    checkEmailBtn.disabled = true;
	    showEmailMessage("メールアドレスを確認しています。", "");

	    try {
	        const response = await fetch(
	            contextPath + "/api/signup/check-email?email="
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

	        if (!response.ok || !result.success || !result.available) {
	            throw new Error(
	                result.message || "すでに登録されているメールアドレスです。"
	            );
	        }

	        emailChecked = true;

	        showEmailMessage(
	            "使用可能なメールアドレスです。会員登録後に認証メールを送信します。",
	            "success"
	        );
	    } catch (error) {
	        emailChecked = false;

	        showEmailMessage(
	            error.message || "メールアドレスの確認に失敗しました。",
	            "error"
	        );
	    } finally {
	        checkEmailBtn.disabled = false;
	        updateSignupButton();
	    }
	});
    document.querySelectorAll(".password-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
            const target = document.getElementById(button.dataset.target);
            const icon = button.querySelector("i");
            const isHidden = target.type === "password";

            target.type = isHidden ? "text" : "password";
            icon.className = isHidden ? "bi bi-eye-slash" : "bi bi-eye";
        });
    });

    form.addEventListener("submit", function (event) {
        const userId = userIdInput.value.trim();
        const userName = userNameInput.value.trim();
        const email = emailInput.value.trim();
        const password = passwordInput.value.trim();
        const passwordConfirm = passwordConfirmInput.value.trim();

        if (userId === "") {
            event.preventDefault();
            alert("IDを入力してください。");
            userIdInput.focus();
            return;
        }

        if (!userIdChecked) {
            event.preventDefault();
            alert("IDの重複確認を完了してください。");
            return;
        }

        if (userName === "") {
            event.preventDefault();
            alert("お名前を入力してください。");
            userNameInput.focus();
            return;
        }

        if (!emailPattern.test(email)) {
            event.preventDefault();
            alert("正しいメールアドレスを入力してください。");
            emailInput.focus();
            return;
        }

		if (!emailChecked) {
		    event.preventDefault();
		    alert("メールアドレスの重複確認を完了してください。");
		    return;
		}

        if (password.length < 8) {
            event.preventDefault();
            alert("パスワードは8文字以上で入力してください。");
            passwordInput.focus();
            return;
        }

        if (password !== passwordConfirm) {
            event.preventDefault();
            alert("パスワードが一致しません。");
            passwordConfirmInput.focus();
            return;
        }

        if (!agreeCheckbox.checked) {
            event.preventDefault();
            alert("利用規約とプライバシーポリシーに同意してください。");
        }
    });

    updateSignupButton();
});