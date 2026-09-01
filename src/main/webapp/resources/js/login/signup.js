/* =====================================================
   signup.js
   - signup.jsp 화면 동작만 담당 (실제 회원가입 처리/DB 연동 없음)
   - 지금은 입력값 유효성 검사(빈 값/형식/일치 체크)만 화면에서 확인하고,
     나중에 백엔드가 연결되면 fetch/폼 전송으로 교체한다.
   ===================================================== */

document.addEventListener("DOMContentLoaded", function () {

    const nameInput = document.getElementById("name");
    const emailInput = document.getElementById("email");
    const passwordInput = document.getElementById("password");
    const passwordConfirmInput = document.getElementById("passwordConfirm");
    const agreeCheckbox = document.getElementById("agree");
    const signupBtn = document.getElementById("signupBtn");

    if (!signupBtn) return;

    signupBtn.addEventListener("click", function () {

        const name = nameInput.value.trim();
        const email = emailInput.value.trim();
        const password = passwordInput.value.trim();
        const passwordConfirm = passwordConfirmInput.value.trim();

        // 1. 이름 빈 값 체크
        if (name === "") {
            alert("お名前を入力してください。");
            nameInput.focus();
            return;
        }

        // 2. 이메일 빈 값 + 형식 체크
        if (email === "") {
            alert("メールアドレスを入力してください。");
            emailInput.focus();
            return;
        }

        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailPattern.test(email)) {
            alert("メールアドレスの形式が正しくありません。");
            emailInput.focus();
            return;
        }

        // 3. 비밀번호 빈 값 + 길이 체크 (8자 이상)
        if (password === "") {
            alert("パスワードを入力してください。");
            passwordInput.focus();
            return;
        }

        if (password.length < 8) {
            alert("パスワードは8文字以上で入力してください。");
            passwordInput.focus();
            return;
        }

        // 4. 비밀번호 확인 일치 체크
        if (passwordConfirm === "") {
            alert("パスワード（確認）を入力してください。");
            passwordConfirmInput.focus();
            return;
        }

        if (password !== passwordConfirm) {
            alert("パスワードが一致しません。");
            passwordConfirmInput.focus();
            return;
        }

        // 5. 약관 동의 체크
        if (!agreeCheckbox.checked) {
            alert("利用規約とプライバシーポリシーに同意してください。");
            agreeCheckbox.focus();
            return;
        }

        // 6. 지금은 백엔드가 없으므로 화면 동작만 안내
        //    TODO: 백엔드 연동 후 이 부분을 실제 회원가입 요청(fetch 등)으로 교체
        alert("会員登録機能はバックエンド連携後に有効になります。");
    });

});