/* =====================================================
   index.js
   - index.jsp 화면 동작만 담당 (DB/API/실제 검색 기능 없음)
   - 뉴스 데이터는 resources/js/board/news-data.js에서 관리한다.
   - "報告する" 버튼 클릭 시 로그인 여부 확인 로직은
     index.jsp의 checkLoginAndReport() 함수(인라인 스크립트)가 담당한다.
   ===================================================== */

document.addEventListener("DOMContentLoaded", function () {
    const splashScreen = document.getElementById("splashScreen");
    const splashStorageKey = "kumanoMaeSplashShownAt";
    const splashInterval = 10 * 60 * 1000;

    if (splashScreen) {
        let shouldShowSplash = true;

        try {
            const lastShownAt = Number(localStorage.getItem(splashStorageKey) || 0);
            shouldShowSplash = !lastShownAt || Date.now() - lastShownAt >= splashInterval;

            if (shouldShowSplash) {
                localStorage.setItem(splashStorageKey, String(Date.now()));
                splashScreen.classList.add("is-visible");
            }
        } catch (error) {
            console.warn("시작 화면 표시 시간 저장에 실패했습니다.", error);
        }

        if (!shouldShowSplash) {
            splashScreen.remove();
        } else {
            window.setTimeout(function () {
                splashScreen.classList.add("is-hiding");
            }, 3000);

            splashScreen.addEventListener("transitionend", function (event) {
                if (event.propertyName === "opacity") {
                    splashScreen.remove();
                }
            });
        }
    }

    const alertBanner = document.querySelector(".top-alert");
    const alertClose = document.getElementById("alertClose");

    if (alertClose) {
        alertClose.addEventListener("click", function () {
            if (alertBanner) {
                alertBanner.style.display = "none";
            }
        });
    }
});
