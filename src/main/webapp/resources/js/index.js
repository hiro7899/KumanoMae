/* =====================================================
   index.js
   - index.jsp 화면 동작만 담당 (DB/API/실제 검색 기능 없음)
   - "報告する" 버튼 클릭 시 로그인 여부 확인 로직은
     index.jsp의 checkLoginAndReport() 함수(인라인 스크립트)가
     담당하므로, 여기서는 더 이상 별도 처리하지 않는다.
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
       ※ 4. "目撃情報を報告する" / "クマ出没を報告する" 버튼 처리는
          index.jsp의 checkLoginAndReport() 함수가 onclick으로
          직접 담당하므로 여기서는 제거함 (중복 실행 방지)
       ----------------------------------------------- */

});