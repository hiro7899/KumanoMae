/* =====================================================
   login.js
   - login.jsp 화면 동작만 담당 (실제 로그인 처리/DB 연동 없음)
   - 지금은 입력값 유효성 검사(빈 값 체크)만 화면에서 확인하고,
     나중에 백엔드가 연결되면 fetch/폼 전송으로 교체한다.
   ===================================================== */

document.addEventListener("DOMContentLoaded", function () {

    const emailInput = document.getElementById("email");
    const passwordInput = document.getElementById("password");
    const loginBtn = document.getElementById("loginBtn");

    if (!loginBtn) return;

    loginBtn.addEventListener("click", function () {

        const email = emailInput.value.trim();
        const password = passwordInput.value.trim();

        // 1. 빈 값 체크
        if (email === "") {
            alert("メールアドレスを入力してください。");
            emailInput.focus();
            return;
        }

        if (password === "") {
            alert("パスワードを入力してください。");
            passwordInput.focus();
            return;
        }

        // 2. 이메일 형식 간단 체크
        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailPattern.test(email)) {
            alert("メールアドレスの形式が正しくありません。");
            emailInput.focus();
            return;
        }

        // 3. 지금은 백엔드가 없으므로 화면 동작만 안내
        //    TODO: 백엔드 연동 후 이 부분을 실제 로그인 요청(fetch 등)으로 교체
        alert("ログイン機能はバックエンド連携後に有効になります。");
    });

    // Enter 키로도 로그인 버튼이 눌리도록 처리
    [emailInput, passwordInput].forEach(function (input) {
        if (!input) return;
        input.addEventListener("keydown", function (e) {
            if (e.key === "Enter") {
                loginBtn.click();
            }
        });
    });

});