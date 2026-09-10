document.addEventListener("DOMContentLoaded", function () {
    const findPwForm = document.getElementById("findPwForm");
    const userIdInput = document.getElementById("userId");
    const emailInput = document.getElementById("email");
    const userIdMessage = document.getElementById("findPwUserIdMessage");
    const emailMessage = document.getElementById("findPwEmailMessage");

    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!findPwForm || !userIdInput || !emailInput) {
        return;
    }

    function showUserIdMessage(text, type) {
        userIdMessage.textContent = text;
        userIdMessage.className = "findpw-input-message " + type;
    }

    function showEmailMessage(text, type) {
        emailMessage.textContent = text;
        emailMessage.className = "findpw-input-message " + type;
    }

    userIdInput.addEventListener("input", function () {
        showUserIdMessage("", "");
    });

    emailInput.addEventListener("input", function () {
        showEmailMessage("", "");
    });

    findPwForm.addEventListener("submit", function (event) {
        const userId = userIdInput.value.trim();
        const email = emailInput.value.trim();

        if (userId === "") {
            event.preventDefault();
            showUserIdMessage("IDを入力してください。", "error");
            userIdInput.focus();
            return;
        }

        if (email === "") {
            event.preventDefault();
            showEmailMessage("メールアドレスを入力してください。", "error");
            emailInput.focus();
            return;
        }

        if (!emailPattern.test(email)) {
            event.preventDefault();
            showEmailMessage(
                "正しいメールアドレスを入力してください。",
                "error"
            );
            emailInput.focus();
        }
    });
});