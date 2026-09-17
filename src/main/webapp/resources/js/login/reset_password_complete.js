document.addEventListener("DOMContentLoaded", function () {
    const loginButton = document.getElementById("completeLoginButton");

    if (!loginButton) {
        return;
    }

    loginButton.addEventListener("click", function () {
        loginButton.classList.add("is-clicked");
    });
});