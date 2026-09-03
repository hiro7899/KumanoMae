/* =====================================================
   map.js
   - map.jsp 화면 동작 담당 (DB/API 연동 없음, 가상 데이터만 사용)
   - 구조 : 가상 데이터(bearData) → 마커 생성 함수 → 지도 화면
   - 나중에 실제 API가 연결되면 bearData 를 채우는 부분만
     fetch/AJAX 결과로 교체하면 되고, 아래 렌더링 함수들은
     그대로 재사용할 수 있도록 데이터와 화면 로직을 분리했다.
   ===================================================== */

/* -----------------------------------------------------
   1. 가상 데이터 (추후 API 응답 JSON으로 교체될 부분)
   ----------------------------------------------------- */
const bearData = [
    { id: 1, region: "秋田県 秋田市", latitude: 39.720, longitude: 140.102, danger: "DANGER",  date: "2026.08.31 14:32", content: "成獣1頭を目撃" },
    { id: 2, region: "岩手県 盛岡市", latitude: 39.703, longitude: 141.153, danger: "WARNING", date: "2026.08.31 13:15", content: "クマ2頭を目撃" },
    { id: 3, region: "山形県 山形市", latitude: 38.240, longitude: 140.363, danger: "CAUTION", date: "2026.08.31 11:42", content: "山林付近で痕跡を確認" },
    { id: 4, region: "北海道 札幌市", latitude: 43.062, longitude: 141.354, danger: "DANGER",  date: "2026.08.30 19:05", content: "登山道でクマを目撃" },
    { id: 5, region: "青森県 青森市", latitude: 40.822, longitude: 140.740, danger: "WARNING", date: "2026.08.30 08:20", content: "農地付近で足跡を発見" },
    { id: 6, region: "長野県 松本市", latitude: 36.238, longitude: 137.972, danger: "CAUTION", date: "2026.08.29 16:50", content: "住宅街近くで鳴き声を確認" }
];

/* 危険度 문자열 → CSS 클래스명 매핑 (DANGER → danger 등) */
const RISK_CLASS_MAP = {
    DANGER:  "danger",
    WARNING: "warning",
    CAUTION: "caution"
};

/* 지도(SVG)가 표현하는 대략적인 위도/경도 범위
   (실제 정밀 지도가 아니라 デモ용 근사치이며,
    나중에 실제 지도 API로 교체되면 이 변환 로직은 필요 없어진다) */
const MAP_BOUNDS = {
    minLat: 30, maxLat: 46,
    minLng: 129, maxLng: 146
};

/* -----------------------------------------------------
   화면 요소 참조
   ----------------------------------------------------- */
const markerLayer   = document.getElementById("markerLayer");
const infoWindow     = document.getElementById("infoWindow");
const infoWindowBody = document.getElementById("infoWindowBody");
const infoWindowClose = document.getElementById("infoWindowClose");
const recentList     = document.getElementById("recentList");
const mapArea        = document.getElementById("mapArea");

/* -----------------------------------------------------
   2. 위도/경도를 지도 영역(%) 좌표로 변환하는 함수
   - 나중에 실제 지도 API로 바뀌면 이 함수는 더 이상 필요 없다.
   ----------------------------------------------------- */
function convertLatLngToPosition(lat, lng) {
    const top  = ((MAP_BOUNDS.maxLat - lat) / (MAP_BOUNDS.maxLat - MAP_BOUNDS.minLat)) * 100;
    const left = ((lng - MAP_BOUNDS.minLng) / (MAP_BOUNDS.maxLng - MAP_BOUNDS.minLng)) * 100;
    return { top: top + "%", left: left + "%" };
}

/* -----------------------------------------------------
   3. 마커 생성 함수 : bearData 배열을 받아 지도 위에 마커를 그린다
   ----------------------------------------------------- */
function renderMarkers(dataList) {
    markerLayer.innerHTML = ""; // 기존 마커 초기화 후 다시 그림

    dataList.forEach(function (item) {
        const pos = convertLatLngToPosition(item.latitude, item.longitude);
        const riskClass = RISK_CLASS_MAP[item.danger] || "caution";

        const marker = document.createElement("div");
        marker.className = "bear-marker " + riskClass;
        marker.style.top = pos.top;
        marker.style.left = pos.left;
        marker.dataset.id = item.id;

        // 마커 클릭 시 인포윈도우 표시
        marker.addEventListener("click", function (e) {
            e.stopPropagation();
            showInfoWindow(item, pos);
        });

        markerLayer.appendChild(marker);
    });
}

/* -----------------------------------------------------
   4. 인포윈도우 표시 / 닫기
   ----------------------------------------------------- */
function showInfoWindow(item, pos) {
    const riskClass = RISK_CLASS_MAP[item.danger] || "caution";

    infoWindowBody.innerHTML =
        '<span class="info-badge ' + riskClass + '">' + item.danger + '</span>' +
        '<p class="info-region">' + item.region + '</p>' +
        '<p class="info-date">' + item.date + '</p>' +
        '<p class="info-content">' + item.content + '</p>' +
        '<button type="button" class="info-detail-btn">詳細を見る</button>';

    // 마커 바로 위에 인포윈도우를 띄운다 (지도 영역 기준 % 좌표 재사용)
    infoWindow.style.top = pos.top;
    infoWindow.style.left = pos.left;
    infoWindow.classList.remove("d-none");
}

function closeInfoWindow() {
    infoWindow.classList.add("d-none");
}

infoWindowClose.addEventListener("click", closeInfoWindow);

// 지도의 빈 공간을 클릭하면 인포윈도우 닫기
mapArea.addEventListener("click", closeInfoWindow);
// 인포윈도우 자체를 클릭했을 때는 지도 클릭으로 전파되어 닫히지 않도록 처리
infoWindow.addEventListener("click", function (e) {
    e.stopPropagation();
});

/* -----------------------------------------------------
   5. 지도 아래 「最新の出没情報」목록 생성 함수
   ----------------------------------------------------- */
function renderRecentList(dataList) {
    recentList.innerHTML = "";

    dataList.forEach(function (item) {
        const riskClass = RISK_CLASS_MAP[item.danger] || "caution";

        const li = document.createElement("li");
        li.className = "bear-item";
        li.innerHTML =
            '<span class="bear-item-badge ' + riskClass + '">' + item.danger + '</span>' +
            '<div class="bear-item-body">' +
                '<p class="bear-item-region">' + item.region + '</p>' +
                '<p class="bear-item-meta">' + item.date + '</p>' +
                '<p class="bear-item-content">' + item.content + '</p>' +
            '</div>' +
            '<button type="button" class="bear-item-btn">詳細を見る</button>';

        recentList.appendChild(li);
    });
}

/* -----------------------------------------------------
   6. 危険度 필터 체크박스 : 체크 해제된 위험도는 지도/목록에서 숨김
      (실제 검색 API 호출이 아니라, 이미 있는 bearData를 화면에서만
       걸러서 다시 그리는 화면 동작이다)
   ----------------------------------------------------- */
const riskCheckboxes = {
    DANGER:  document.getElementById("riskDanger"),
    WARNING: document.getElementById("riskWarning"),
    CAUTION: document.getElementById("riskCaution")
};

function applyRiskFilter() {
    const filtered = bearData.filter(function (item) {
        const checkbox = riskCheckboxes[item.danger];
        return checkbox ? checkbox.checked : true;
    });

    renderMarkers(filtered);
    renderRecentList(filtered);
    closeInfoWindow();
}

Object.values(riskCheckboxes).forEach(function (checkbox) {
    if (checkbox) {
        checkbox.addEventListener("change", applyRiskFilter);
    }
});

/* -----------------------------------------------------
   7. 초기 화면 렌더링
   ----------------------------------------------------- */
document.addEventListener("DOMContentLoaded", function () {
    renderMarkers(bearData);
    renderRecentList(bearData);
});