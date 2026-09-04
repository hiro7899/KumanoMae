<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    =========================================================
    map.jsp
    - クマ出没マップ 화면 UI
    - Google Maps JavaScript API 연동 (프론트엔드 단계, DB/Servlet 없음)
    - 기존 디자인/필터 UI는 그대로 유지, 지도 영역만
      SVG 가짜 지도 → 실제 Google Map으로 교체
    - 리소스 경로는 루트("/") 배포 기준 절대경로로 고정
    =========================================================
--%>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>クマ出没マップ</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

    <!-- 일본어 폰트 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">

    <!-- 이 화면 전용 CSS -->
    <link rel="stylesheet" href="/resources/css/map/map.css">
    
    <link rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
      
</head>

<body>

<%@ include file="/WEB-INF/views/includes/header.jsp"%>

    <%-- ===================== 2. 페이지 제목 ===================== --%>
    <section class="page-title-area">
        <div class="container">
            <h1>クマ出没マップ</h1>
            <p class="page-desc">全国のクマ出没情報を地図から確認できます。</p>

            <div class="status-bar">
                <span id="selectedArea"><i class="bi bi-geo-alt-fill"></i> 選択中の地域：全国</span>
                <span id="lastUpdated"><i class="bi bi-clock-history"></i> 最終更新：2026.08.31 14:32</span>
            </div>
        </div>
    </section>

    <%-- ===================== 3. 검색/필터 UI (기존 그대로 유지) ===================== --%>
    <section class="filter-area">
        <div class="container">
            <form class="filter-form" onsubmit="return false;">
                <div class="filter-row">

                    <div class="filter-group">
                        <label for="areaSelect">地域</label>
                        <select id="areaSelect" name="area" class="form-select">
                            <option selected>全国</option>
                            <option>北海道</option>
                            <option>東北</option>
                            <option>関東</option>
                            <option>中部</option>
                            <option>近畿</option>
                            <option>中国</option>
                            <option>四国</option>
                            <option>九州・沖縄</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label>期間</label>
                        <div class="date-range">
                            <input type="date" class="form-control" id="startDate" name="startDate" value="2026-08-01">
                            <span class="date-sep">〜</span>
                            <input type="date" class="form-control" id="endDate" name="endDate" value="2026-08-31">
                        </div>
                    </div>

                    <div class="filter-group">
                        <label>危険度</label>
                        <div class="risk-toggle-group">

                            <input type="checkbox" class="btn-check" id="riskDanger" checked>
                            <label class="btn risk-btn risk-danger" for="riskDanger">DANGER</label>

                            <input type="checkbox" class="btn-check" id="riskWarning" checked>
                            <label class="btn risk-btn risk-warning" for="riskWarning">WARNING</label>

                            <input type="checkbox" class="btn-check" id="riskCaution" checked>
                            <label class="btn risk-btn risk-caution" for="riskCaution">CAUTION</label>

                        </div>
                    </div>

                    <div class="filter-group filter-submit">
                        <button type="button" id="searchBtn" class="btn btn-search">
                            <i class="bi bi-search"></i> 検索
                        </button>
                        <button type="button" id="resetFilterBtn" class="btn btn-reset">
                            <i class="bi bi-arrow-counterclockwise"></i> リセット
                        </button>
                    </div>

                </div>
            </form>
        </div>
    </section>

    <%-- ===================== 4~7. 지도 영역 (Google Maps) + 범례 ===================== --%>
    <section class="map-section">
        <div class="container">
            <div class="map-wrapper">

                <!-- 지도 영역 : 실제 Google Map이 이 안에 렌더링된다 -->
                <div id="mapArea" class="map-area">
                    <div id="googleMap"></div>
                </div>

                <!-- 지도 범례 -->
                <div class="map-legend">
                    <h6>危険度</h6>
                    <p><span class="legend-dot risk-danger-dot"></span> DANGER</p>
                    <p><span class="legend-dot risk-warning-dot"></span> WARNING</p>
                    <p><span class="legend-dot risk-caution-dot"></span> CAUTION</p>
                    
                </div>

            </div>
        </div>
    </section>

    <%-- ===================== 8. 지도 아래 출몰 목록 ===================== --%>
    <section class="list-section">
        <div class="container">
            <h2 class="list-title">最新の出没情報</h2>

            <!-- 목록 항목 : map.js 에서 bearSightings 를 이용해 동적으로 생성 -->
            <ul id="recentList" class="bear-list"></ul>
        </div>
    </section>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- 이 화면 전용 JS (테스트 데이터, 마커 생성, 필터 로직 등) -->
    <script src="/resources/js/map/map.js"></script>

    <%--
        ==========================================================
        Google Maps JavaScript API 로드
        - API Key는 하드코딩하지 않고 ${googleMapsApiKey} EL로 주입한다.
        - map.js가 먼저 로드되어 window.initMap이 이미 정의된 상태이므로,
          이 스크립트가 async/defer로 늦게 로드되어 콜백을 호출해도 문제없다.
        ==========================================================
    --%>
    <script src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}&libraries=places"></script>
    
    <%@ include file="/WEB-INF/views/includes/footer.jsp"%>

</body>
</html>