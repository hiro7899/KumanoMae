/* =====================================================
   index.js
   - index.jsp 화면 동작만 담당 (DB/API/실제 검색·제보 기능 없음)
   - 지금은 UI 동작(버튼 클릭 반응, 배너 닫기 등)만 구현하고,
     나중에 로그인/게시판/지도API가 붙으면 이 자리에 실제 로직을 채운다.
   ===================================================== */

document.addEventListener("DOMContentLoaded", function () {

    /* -----------------------------------------------
       1. 상단 경보 배너 닫기 (X 클릭 시 배너 숨김)
       ----------------------------------------------- */
    const alertBanner = document.querySelector(".top-alert");
    const alertClose = document.getElementById("alertClose");

    if (alertClose) {
        alertClose.addEventListener("click", function () {
            alertBanner.style.display = "none";
        });
    }

    /* -----------------------------------------------
       2. 地域検索 버튼 (지금은 실제 검색 없음, UI 동작만)
       ----------------------------------------------- */
    const areaSearchBtn = document.getElementById("areaSearchBtn");
    const areaSearchInput = document.getElementById("areaSearchInput");

    if (areaSearchBtn) {
        areaSearchBtn.addEventListener("click", function () {
            const keyword = areaSearchInput.value.trim();
            if (keyword === "") {
                alert("検索する地域を入力してください。");
                return;
            }
            alert(keyword + " の検索結果を表示します。（今後実装予定）");
        });
    }

    /* -----------------------------------------------
       3. 危険度 체크박스 : 지금은 화면 표시용 상태만 확인
          (실제 지도 마커/데이터 연동은 出没マップ 기능 구현 시 추가)
       ----------------------------------------------- */
    const riskCheckboxes = document.querySelectorAll(
        "#riskDanger, #riskWarning, #riskCaution"
    );

    riskCheckboxes.forEach(function (checkbox) {
        checkbox.addEventListener("change", function () {
            console.log(checkbox.id + " : " + checkbox.checked);
            // TODO: 出没マップ 기능이 연결되면 여기서 마커를 필터링한다.
        });
    });

    /* -----------------------------------------------
       4. 目撃情報を報告する / クマ出没を報告する 버튼
          (지금은 로그인·게시판 기능이 없으므로 안내만 표시)
       ----------------------------------------------- */
    const reportButtons = document.querySelectorAll(".report-float-btn, .btn-jp-outline");

    reportButtons.forEach(function (btn) {
        // "詳細を見る" 버튼과는 별개로, 텍스트가 제보 관련 버튼일 때만 동작
        if (btn.textContent.includes("報告する")) {
            btn.addEventListener("click", function () {
                alert("目撃情報の報告機能は、ログイン・掲示板の実装後に利用できます。");
            });
        }
    });

});