document.addEventListener("DOMContentLoaded", function () {
    const loginForm = document.querySelector("form[action='/login']");
    const userIdInput = document.getElementById("userId");
    const passwordInput = document.getElementById("userPw");

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

    if (!loginForm) {
        return;
    }

    loginForm.addEventListener("submit", function (event) {
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