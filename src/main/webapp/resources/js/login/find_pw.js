document.addEventListener("DOMContentLoaded", function () {
    const findPwForm = document.getElementById("findPwForm");
    const userIdInput = document.getElementById("userId");
    const emailInput = document.getElementById("email");

    if (!findPwForm) {
        return;
    }

    findPwForm.addEventListener("submit", function (event) {
        const userId = userIdInput.value.trim();
        const email = emailInput.value.trim();
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (userId === "") {
            event.preventDefault();
            alert("IDを入力してください。");
            userIdInput.focus();
            return;
        }

        if (email === "") {
            event.preventDefault();
            alert("メールアドレスを入力してください。");
            emailInput.focus();
            return;
        }

        if (!emailPattern.test(email)) {
            event.preventDefault();
            alert("メールアドレスの形式が正しくありません。");
            emailInput.focus();
        }
    });
});