document.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("resetPasswordForm");
    const newPw = document.getElementById("newPw");
    const newPwConfirm = document.getElementById("newPwConfirm");
    const newPwMessage = document.getElementById("newPwMessage");
    const newPwConfirmMessage = document.getElementById("newPwConfirmMessage");

    document.querySelectorAll(".reset-password-toggle").forEach(function (button) {
        button.addEventListener("click", function () {
            const input = document.getElementById(button.dataset.target);
            const icon = button.querySelector("i");

            if (!input) {
                return;
            }

            const isPassword = input.type === "password";
            input.type = isPassword ? "text" : "password";

            icon.className = isPassword ? "bi bi-eye-slash" : "bi bi-eye";
            button.setAttribute(
                "aria-label",
                isPassword ? "パスワードを隠す" : "パスワードを表示"
            );
        });
    });

    if (!form || !newPw || !newPwConfirm) {
        return;
    }

    function showMessage(element, text, type) {
        element.textContent = text;
        element.className = "reset-input-message" + (type ? " " + type : "");
    }

    function validatePassword() {
        if (newPw.value.length === 0) {
            showMessage(newPwMessage, "8文字以上で入力してください。", "");
            return false;
        }

        if (newPw.value.length < 8) {
            showMessage(newPwMessage, "パスワードは8文字以上で入力してください。", "is-error");
            return false;
        }

        showMessage(newPwMessage, "使用可能なパスワードです。", "is-success");
        return true;
    }

    function validateConfirmation() {
        if (newPwConfirm.value.length === 0) {
            showMessage(newPwConfirmMessage, "", "");
            return false;
        }

        if (newPw.value !== newPwConfirm.value) {
            showMessage(newPwConfirmMessage, "パスワードが一致しません。", "is-error");
            return false;
        }

        showMessage(newPwConfirmMessage, "パスワードが一致しています。", "is-success");
        return true;
    }

    newPw.addEventListener("input", function () {
        validatePassword();
        validateConfirmation();
    });

    newPwConfirm.addEventListener("input", validateConfirmation);

    form.addEventListener("submit", function (event) {
        const passwordValid = validatePassword();
        const confirmValid = validateConfirmation();

        if (!passwordValid || !confirmValid) {
            event.preventDefault();

            if (!passwordValid) {
                newPw.focus();
            } else {
                newPwConfirm.focus();
            }
        }
    });
});