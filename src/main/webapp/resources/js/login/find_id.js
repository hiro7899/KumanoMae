/* =====================================================

   find.js

   - findId.jsp / findPw.jsp 화면 동작 담당
   - 현재는 입력값 유효성 검사만 담당
   - 실제 DB 조회 및 인증은 백엔드 연결 후 처리

   ===================================================== */


document.addEventListener("DOMContentLoaded", function () {


    /* =====================================================
       
       아이디 찾기
       
       findId.jsp
       
       - 이메일 : 필수
       - 전화번호 : 선택
       
       ===================================================== */

    const findIdForm = document.getElementById("findIdForm");

    const emailInput = document.getElementById("email");

    const phoneInput = document.getElementById("phone");

    const findIdBtn = document.getElementById("findIdBtn");


    // findId.jsp가 아니면 실행하지 않음

    if (!findIdForm) {
        return;
    }


    /* =====================================================
       
       Form Submit
       
       ===================================================== */

    findIdForm.addEventListener("submit", function (e) {

        const email = emailInput.value.trim();

        const phone = phoneInput.value.trim();


        /* =================================================
           
           1. 이메일 빈 값 체크
           
           ================================================= */

        if (email === "") {

            e.preventDefault();

            alert("メールアドレスを入力してください。");

            emailInput.focus();

            return;
        }


        /* =================================================
           
           2. 이메일 형식 체크
           
           ================================================= */

        const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (!emailPattern.test(email)) {

            e.preventDefault();

            alert("メールアドレスの形式が正しくありません。");

            emailInput.focus();

            return;
        }


        /* =================================================
           
           3. 전화번호 형식 체크
           
           - 전화번호는 선택 입력
           - 아무것도 입력하지 않았으면 검사하지 않음
           
           ================================================= */

        if (phone !== "") {

            const phonePattern = /^0\d{1,3}-?\d{3,4}-?\d{4}$/;

            if (!phonePattern.test(phone)) {

                e.preventDefault();

                alert("電話番号の形式が正しくありません。");

                phoneInput.focus();

                return;
            }

        }


        /* =================================================
           
           모든 유효성 검사 통과
           
           - e.preventDefault()가 실행되지 않음
           - form이 /find-id로 정상적으로 POST 전송됨
           
           ================================================= */

    });


    /* =====================================================
       
       Enter 키 처리
       
       - 이메일 또는 전화번호 입력 중 Enter
       - IDを確認する 버튼 실행
       
       ===================================================== */

    [emailInput, phoneInput].forEach(function (input) {

        if (!input) {
            return;
        }


        input.addEventListener("keydown", function (e) {

            if (e.key === "Enter") {

                e.preventDefault();

                findIdBtn.click();

            }

        });

    });


});
