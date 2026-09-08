/* =====================================================
   map.js
   - map.jsp 화면 동작 담당
   - Google Maps JavaScript API 연동 (DB/Servlet 연동 없음, 테스트 데이터만 사용)
   - 구조 : 테스트 데이터(bearSightings) → 마커 생성 함수 → 지도 화면
   - 나중에 실제 API가 연결되면 bearSightings 를 채우는 부분만
     서버 응답(JSON)으로 교체하면 되고, 마커/인포윈도우/필터 로직은
     그대로 재사용할 수 있도록 데이터와 화면 로직을 분리했다.
   =====================================================
   ※ initMap()은 Google Maps 스크립트의 callback=initMap 으로
     호출되는 전역 함수이므로, DOMContentLoaded로 감싸지 않는다.
   ===================================================== */

/* -----------------------------------------------------
   1. 테스트용 곰 출몰 데이터 (추후 API 응답 JSON으로 교체될 부분)
   - risk : "高" / "中" / "低"
   - region : 필터의 지역 select 옵션과 매칭되는 대분류
   ----------------------------------------------------- */
const bearSightings = [
    { id: 1, lat: 43.062,  lng: 141.354, area: "北海道",   region: "北海道",   date: "2026-08-30", risk: "高", content: "登山道でクマを目撃" },
    { id: 2, lat: 39.703,  lng: 141.153, area: "岩手県",   region: "東北",     date: "2026-08-31", risk: "中", content: "クマ2頭を目撃" },
    { id: 3, lat: 35.6895, lng: 139.6917, area: "東京都",  region: "関東",     date: "2026-08-25", risk: "低", content: "住宅街近くで目撃情報" },
    { id: 4, lat: 35.1815, lng: 136.9066, area: "愛知県",  region: "中部",     date: "2026-08-22", risk: "中", content: "農地付近で足跡を発見" },
    { id: 5, lat: 35.0116, lng: 135.7681, area: "京都府",  region: "近畿",     date: "2026-08-20", risk: "高", content: "成獣1頭を目撃" },
    { id: 6, lat: 34.3853, lng: 132.4553, area: "広島県",  region: "中国",     date: "2026-08-18", risk: "低", content: "山林付近で痕跡を確認" },
    { id: 7, lat: 34.3401, lng: 134.0434, area: "香川県",  region: "四国",     date: "2026-08-15", risk: "中", content: "鳴き声を確認" },
    { id: 8, lat: 33.5904, lng: 130.4017, area: "福岡県",  region: "九州・沖縄", date: "2026-08-10", risk: "低", content: "目撃情報あり" }
];

/* 危険度(高/中/低) → CSS 클래스명 매핑 (기존 danger/warning/caution 스타일 재사용) */
const RISK_CLASS_MAP = {
    "高": "danger",
    "中": "warning",
    "低": "caution"
};

/* 危険度(高/中/低) → 마커 색상 매핑 (CSS 변수와 동일한 색상) */
const RISK_COLOR_MAP = {
    "高": "#d93025",
    "中": "#e8791a",
    "低": "#f2c227"
};

/* 기존 필터 체크박스 id → 危険度(高/中/低) 매핑
   (체크박스 자체의 id/디자인은 그대로 유지) */
const RISK_CHECKBOX_MAP = {
    riskDanger:  "高",
    riskWarning: "中",
    riskCaution: "低"
};

/* -----------------------------------------------------
   전역 상태 : 지도 인스턴스 / 마커 목록 / 인포윈도우
   ----------------------------------------------------- */
let map;
let markers = [];
let infoWindow;

/* -----------------------------------------------------
   2. 지도 초기화 (Google Maps 스크립트의 callback으로 호출됨)
   ----------------------------------------------------- */
function initMap() {
    const googleMapEl = document.getElementById("googleMap");

    // 일본 전체가 보이는 초기 위치/줌 레벨
    map = new google.maps.Map(googleMapEl, {
        center: { lat: 36.2048, lng: 138.2529 },
        zoom: 5,
        mapTypeControl: false,
        streetViewControl: false,
        fullscreenControl: false
    });

    infoWindow = new google.maps.InfoWindow();

    // 지도의 빈 공간을 클릭하면 인포윈도우 닫기
    map.addListener("click", function () {
        infoWindow.close();
    });

    // 초기 화면은 전체 데이터로 마커 표시
    loadMarkers(bearSightings);
}

/* -----------------------------------------------------
   3. 危険度에 따른 마커 아이콘 생성 함수
   - 지금은 단순 원형 아이콘이지만, 나중에 이미지 아이콘으로
     바꾸고 싶을 때 이 함수만 수정하면 된다.
   ----------------------------------------------------- */
function getMarkerIcon(risk) {
    return {
        path: google.maps.SymbolPath.CIRCLE,
        fillColor: RISK_COLOR_MAP[risk] || RISK_COLOR_MAP["低"],
        fillOpacity: 1,
        strokeColor: "#ffffff",
        strokeWeight: 2,
        scale: 9
    };
}

/* -----------------------------------------------------
   4. 마커 1개 생성
   ----------------------------------------------------- */
function createMarker(sighting) {
    const marker = new google.maps.Marker({
        position: { lat: sighting.lat, lng: sighting.lng },
        map: map,
        icon: getMarkerIcon(sighting.risk),
        title: sighting.area
    });

    marker.addListener("click", function () {
        infoWindow.setContent(createInfoWindowContent(sighting));
        infoWindow.open(map, marker);
    });

    markers.push(marker);
    return marker;
}

/* -----------------------------------------------------
   5. 인포윈도우에 표시할 HTML 콘텐츠 생성
   - 出没地域 / 出没日時 / 危険度 를 표시한다.
   ----------------------------------------------------- */
function createInfoWindowContent(sighting) {
    const riskClass = RISK_CLASS_MAP[sighting.risk] || "caution";

    return (
        '<div class="gmap-infowindow">' +
            '<span class="info-badge ' + riskClass + '">' + sighting.risk + '</span>' +
            '<p class="info-region">出没地域：' + sighting.area + '</p>' +
            '<p class="info-date">出没日時：' + formatDateJP(sighting.date) + '</p>' +
            '<p class="info-content">危険度：' + sighting.risk + '</p>' +
        '</div>'
    );
}

/* "2026-08-20" → "2026年8月20日" 형식으로 변환 */
function formatDateJP(dateStr) {
    const parts = dateStr.split("-");
    const year = parts[0];
    const month = parseInt(parts[1], 10);
    const day = parseInt(parts[2], 10);
    return year + "年" + month + "月" + day + "日";
}

/* -----------------------------------------------------
   6. 마커 로드 / 전체 삭제
   ----------------------------------------------------- */
function loadMarkers(sightingList) {
    clearMarkers();

    sightingList.forEach(function (sighting) {
        createMarker(sighting);
    });

    renderRecentList(sightingList);
}

function clearMarkers() {
    markers.forEach(function (marker) {
        marker.setMap(null);
    });
    markers = [];

    if (infoWindow) {
        infoWindow.close();
    }
}

/* -----------------------------------------------------
   7. 지도 아래 「最新の出没情報」목록 생성
   ----------------------------------------------------- */
function renderRecentList(sightingList) {
    const recentList = document.getElementById("recentList");
    if (!recentList) return;

    recentList.innerHTML = "";

    sightingList.forEach(function (sighting) {
        const riskClass = RISK_CLASS_MAP[sighting.risk] || "caution";

        const li = document.createElement("li");
        li.className = "bear-item";
        li.innerHTML =
            '<span class="bear-item-badge ' + riskClass + '">' + sighting.risk + '</span>' +
            '<div class="bear-item-body">' +
                '<p class="bear-item-region">' + sighting.area + '</p>' +
                '<p class="bear-item-meta">' + formatDateJP(sighting.date) + '</p>' +
                '<p class="bear-item-content">' + sighting.content + '</p>' +
            '</div>' +
            '<button type="button" class="bear-item-btn">詳細を見る</button>';

        recentList.appendChild(li);
    });
}

/* -----------------------------------------------------
   8. 필터링 로직
   - 지역 / 기간 / 危険度 를 기준으로 bearSightings 를 걸러낸다.
   - 실제 검색 API 호출이 아니라, 테스트 데이터를 화면에서만
     걸러서 다시 그리는 화면 동작이다.
   ----------------------------------------------------- */
function filterSightings() {
    const areaSelect = document.getElementById("areaSelect");
    const startDateInput = document.getElementById("startDate");
    const endDateInput = document.getElementById("endDate");

    const selectedArea = areaSelect ? areaSelect.value : "全国";
    const startDate = startDateInput ? startDateInput.value : "";
    const endDate = endDateInput ? endDateInput.value : "";

    // 현재 체크되어 있는 危険度(高/中/低) 목록
    const checkedRisks = Object.keys(RISK_CHECKBOX_MAP)
        .filter(function (checkboxId) {
            const checkbox = document.getElementById(checkboxId);
            return checkbox ? checkbox.checked : false;
        })
        .map(function (checkboxId) {
            return RISK_CHECKBOX_MAP[checkboxId];
        });

    return bearSightings.filter(function (sighting) {
        // 지역 필터
        if (selectedArea !== "全国" && sighting.region !== selectedArea) {
            return false;
        }

        // 기간 필터
        if (startDate && sighting.date < startDate) {
            return false;
        }
        if (endDate && sighting.date > endDate) {
            return false;
        }

        // 危険度 필터
        if (checkedRisks.indexOf(sighting.risk) === -1) {
            return false;
        }

        return true;
    });
}

function applyFilters() {
    const filtered = filterSightings();
    loadMarkers(filtered);
}

/* -----------------------------------------------------
   9. 필터 초기화
   - 지역=全国, 기간=전체 테스트 데이터 범위, 危険度=전부 체크
     상태로 되돌리고 전체 마커를 다시 표시한다.
   ----------------------------------------------------- */
function resetFilters() {
    const areaSelect = document.getElementById("areaSelect");
    const startDateInput = document.getElementById("startDate");
    const endDateInput = document.getElementById("endDate");

    if (areaSelect) areaSelect.value = "全国";
    if (startDateInput) startDateInput.value = "2026-08-01";
    if (endDateInput) endDateInput.value = "2026-08-31";

    Object.keys(RISK_CHECKBOX_MAP).forEach(function (checkboxId) {
        const checkbox = document.getElementById(checkboxId);
        if (checkbox) checkbox.checked = true;
    });

    loadMarkers(bearSightings);
}

/* -----------------------------------------------------
   10. 버튼 이벤트 연결
   - 지도/마커와 무관하게 버튼 자체는 페이지 로드 시 이미 존재하므로
     DOMContentLoaded 시점에 연결해도 안전하다.
   ----------------------------------------------------- */
document.addEventListener("DOMContentLoaded", function () {
    const searchBtn = document.getElementById("searchBtn");
    const resetBtn = document.getElementById("resetFilterBtn");

    if (searchBtn) {
        searchBtn.addEventListener("click", applyFilters);
    }

    if (resetBtn) {
        resetBtn.addEventListener("click", resetFilters);
    }
});