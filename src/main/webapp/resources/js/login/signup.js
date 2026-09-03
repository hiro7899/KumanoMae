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
    const verificationArea = document.getElementById("verificationArea");
    const verificationCodeInput = document.getElementById("verificationCode");
    const verifyEmailBtn = document.getElementById("verifyEmailBtn");
    const emailAuthMessage = document.getElementById("emailAuthMessage");

    const signupBtn = document.getElementById("signupBtn");
    const contextPath = document.body.dataset.contextPath || "";
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    let userIdChecked = false;
    let emailVerified = false;

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
        verificationArea.classList.add("d-none");
        verificationCodeInput.value = "";
        showEmailMessage("", "");
        updateSignupButton();
    }

    userIdInput.addEventListener("input", resetUserIdCheck);
    emailInput.addEventListener("input", resetEmailVerification);

    /* 전화번호: 숫자만 허용 */
    phoneInput.addEventListener("input", function () {
        phoneInput.value = phoneInput.value.replace(/\D/g, "");
    });

    /* ID 중복 확인 */
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
                contextPath + "/api/signup/check-user-id",
                {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ userId: userId })
                }
            );

            const result = await response.json();

            if (!response.ok || !result.available) {
                throw new Error(result.message || "すでに使用されているIDです。");
            }

            userIdChecked = true;
            showUserIdMessage("使用可能なIDです。", "success");
            updateSignupButton();
        } catch (error) {
            userIdChecked = false;
            showUserIdMessage(error.message, "error");
            updateSignupButton();
        } finally {
            checkUserIdBtn.disabled = false;
        }
    });

    /* 이메일 중복 확인 후 인증번호 발송 */
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
                contextPath + "/api/signup/check-email",
                {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ email: email })
                }
            );

            const checkResult = await checkResponse.json();

            if (!checkResponse.ok || !checkResult.available) {
                throw new Error(
                    checkResult.message || "すでに登録されているメールアドレスです。"
                );
            }

            showEmailMessage("認証番号を送信しています。", "");

            const sendResponse = await fetch(
                contextPath + "/api/email-verification/send",
                {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({ email: email })
                }
            );

            const sendResult = await sendResponse.json();

            if (!sendResponse.ok || !sendResult.success) {
                throw new Error(
                    sendResult.message || "認証番号の送信に失敗しました。"
                );
            }

            verificationArea.classList.remove("d-none");
            showEmailMessage("認証番号をメールに送信しました。", "success");
            verificationCodeInput.focus();
        } catch (error) {
            showEmailMessage(error.message, "error");
        } finally {
            sendVerificationBtn.disabled = false;
        }
    });

    /* 이메일 인증번호 확인 */
    verifyEmailBtn.addEventListener("click", async function () {
        const email = emailInput.value.trim();
        const code = verificationCodeInput.value.trim();

        if (!/^\d{6}$/.test(code)) {
            showEmailMessage("6桁の認証番号を入力してください。", "error");
            verificationCodeInput.focus();
            return;
        }

        verifyEmailBtn.disabled = true;

        try {
            const response = await fetch(
                contextPath + "/api/email-verification/verify",
                {
                    method: "POST",
                    headers: { "Content-Type": "application/json" },
                    body: JSON.stringify({
                        email: email,
                        code: code
                    })
                }
            );

            const result = await response.json();

            if (!response.ok || !result.success) {
                throw new Error(result.message || "認証番号が正しくありません。");
            }

            emailVerified = true;
            emailInput.readOnly = true;
            verificationCodeInput.readOnly = true;
            sendVerificationBtn.disabled = true;
            verifyEmailBtn.disabled = true;

            showEmailMessage("メール認証が完了しました。", "success");
            updateSignupButton();
        } catch (error) {
            showEmailMessage(error.message, "error");
        } finally {
            if (!emailVerified) {
                verifyEmailBtn.disabled = false;
            }
        }
    });

    /* 비밀번호 보기 / 숨기기 */
    document.querySelectorAll(".password-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
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
            agreeCheckbox.focus();
        }
    });
});