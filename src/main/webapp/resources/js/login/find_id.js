document.addEventListener("DOMContentLoaded", function () {
    const findIdForm = document.getElementById("findIdForm");
    const emailInput = document.getElementById("email");
    const message = document.getElementById("findIdClientMessage");
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!findIdForm || !emailInput || !message) {
        return;
    }

    function showMessage(text, type) {
        message.textContent = text;
        message.className = "find-input-message " + type;
    }

    emailInput.addEventListener("input", function () {
        showMessage("", "");
    });

    findIdForm.addEventListener("submit", function (event) {
        const email = emailInput.value.trim();

        if (email === "") {
            event.preventDefault();
            showMessage("メールアドレスを入力してください。", "error");
            emailInput.focus();
            return;
        }

        if (!emailPattern.test(email)) {
            event.preventDefault();
            showMessage(
                "正しいメールアドレスを入力してください。",
                "error"
            );
            emailInput.focus();
        }
    });
});