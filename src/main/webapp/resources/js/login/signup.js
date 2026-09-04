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

    const sendVerificationBtn = document.getElementById("sendVerificationBtn");
    const emailAuthMessage = document.getElementById("emailAuthMessage");

    const signupBtn = document.getElementById("signupBtn");

    const contextPath = document.body.dataset.contextPath || "";
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    let userIdChecked = false;
    let emailVerified = false;
    let verificationRequested = false;

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
        signupBtn.disabled = !(userIdChecked && emailVerified);
    }

    function resetUserIdCheck() {
        userIdChecked = false;
        showUserIdMessage("", "");
        updateSignupButton();
    }

    function resetEmailVerification() {
        emailVerified = false;
        verificationRequested = false;
        showEmailMessage("", "");
        updateSignupButton();
    }

    userIdInput.addEventListener("input", resetUserIdCheck);
    emailInput.addEventListener("input", resetEmailVerification);

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

    sendVerificationBtn.addEventListener("click", async function () {
        const email = emailInput.value.trim();

        if (!emailPattern.test(email)) {
            showEmailMessage("正しいメールアドレスを入力してください。", "error");
            emailInput.focus();
            return;
        }

        sendVerificationBtn.disabled = true;
        showEmailMessage("メールアドレスを確認しています。", "");

        try {
            const checkResponse = await fetch(
                contextPath + "/api/signup/check-email?email="
                + encodeURIComponent(email),
                { method: "GET" }
            );

            const checkResult = await checkResponse.json();

            if (!checkResponse.ok || !checkResult.success || !checkResult.available) {
                throw new Error(
                    checkResult.message || "すでに登録されているメールアドレスです。"
                );
            }

            showEmailMessage("認証メールを送信しています。", "");

            const sendResponse = await fetch(
                contextPath + "/api/email-verification/send",
                {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                    },
                    body: new URLSearchParams({ email: email })
                }
            );

            const sendResult = await sendResponse.json();

            if (!sendResponse.ok || !sendResult.success) {
                throw new Error(
                    sendResult.message || "認証メールの送信に失敗しました。"
                );
            }

            verificationRequested = true;

            showEmailMessage(
                "認証メールを送信しました。メール本文のリンクをクリックして認証を完了してください。",
                "success"
            );
        } catch (error) {
            showEmailMessage(error.message, "error");
        } finally {
            sendVerificationBtn.disabled = false;
        }
    });

    async function refreshEmailVerificationStatus() {
        const email = emailInput.value.trim();

        if (!verificationRequested || !emailPattern.test(email)) {
            return;
        }

        try {
            const response = await fetch(
                contextPath + "/api/email-verification/status?email="
                + encodeURIComponent(email),
                { method: "GET" }
            );

            const result = await response.json();

            if (response.ok && result.success && result.verified) {
                emailVerified = true;
                emailInput.readOnly = true;
                sendVerificationBtn.disabled = true;

                showEmailMessage("メール認証が完了しました。", "success");
                updateSignupButton();
            }
        } catch (error) {
            // 인증 메일을 클릭하기 전에는 별도 오류를 표시하지 않음
        }
    }

    window.addEventListener("focus", refreshEmailVerificationStatus);

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

        if (!emailVerified) {
            event.preventDefault();
            alert("メール認証を完了してください。");
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