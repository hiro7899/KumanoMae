<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    =========================================================
    map.jsp
    - クマ出没マップ 화면 UI (프론트엔드 구조만 담당)
    - DB/Servlet/지도API/로그인 기능 없음 (이번 단계 범위 아님)
    - 위치: WEB-INF/views/map/map.jsp (최종 배치 기준)
      ※ 브라우저 직접 접근 불가 → Controller 단계에서 forward 필요
    - 루트("/") 배포 기준이므로 모든 리소스 경로는 절대경로("/resources/...")로 고정
    - 마커 및 출몰 목록은 map.js에서 가상 데이터(bearData)로
      동적 생성한다. (여기서는 빈 컨테이너만 준비)
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

    <!-- 이 화면 전용 CSS (다음 단계에서 작성 예정) -->
    <link rel="stylesheet" href="/resources/css/map.css">
</head>
<body>

    <%-- ===================== 1. Header ===================== --%>
    <header class="site-header">
        <div class="container d-flex align-items-center justify-content-between">
            <a href="/" class="header-logo text-decoration-none">
                🐻 クマ出没情報
            </a>

            <button class="navbar-toggler d-lg-none" type="button"
                    data-bs-toggle="collapse" data-bs-target="#headerNav">
                <span class="navbar-toggler-icon"></span>
            </button>

            <nav class="collapse navbar-collapse flex-grow-0" id="headerNav">
                <ul class="header-nav">
                    <li><a href="/">ホーム</a></li>
                    <li><a href="#" class="active">出没マップ</a></li>
                    <li><a href="#">最新情報</a></li>
                    <li><a href="#">安全ガイド</a></li>
                    <li><a href="#">掲示板</a></li>
                    <li><a href="#">ログイン</a></li>
                </ul>
            </nav>
        </div>
    </header>

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

    <%-- ===================== 3. 검색/필터 UI (기능 없음, UI만) ===================== --%>
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
                            <input type="date" class="form-control" name="startDate" value="2026-08-01">
                            <span class="date-sep">〜</span>
                            <input type="date" class="form-control" name="endDate" value="2026-08-31">
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
                        <button type="button" class="btn btn-search">
                            <i class="bi bi-search"></i> 検索
                        </button>
                    </div>

                </div>
            </form>
        </div>
    </section>

    <%-- ===================== 4~7. 지도 영역 + 마커 + 인포윈도우 + 범례 ===================== --%>
    <section class="map-section">
        <div class="container">
            <div class="map-wrapper">

                <!-- 지도 배경 (간단한 일본 지도 SVG) -->
                <div id="mapArea" class="map-area">

                    <svg class="japan-svg" viewBox="0 0 300 480" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                        <!-- 北海道 -->
                        <ellipse cx="205" cy="55" rx="45" ry="35" class="island" transform="rotate(-15 205 55)"/>
                        <!-- 本州 -->
                        <path class="island" d="M225,95
                                 C 210,120 200,140 185,160
                                 C 165,190 160,210 140,235
                                 C 115,265 100,280 80,310
                                 C 65,335 55,350 45,375
                                 C 55,365 75,355 95,340
                                 C 120,320 140,300 160,275
                                 C 180,250 195,225 210,195
                                 C 225,165 235,140 240,115
                                 Z"/>
                        <!-- 四国 -->
                        <ellipse cx="95" cy="368" rx="18" ry="10" class="island" transform="rotate(-20 95 368)"/>
                        <!-- 九州 -->
                        <ellipse cx="62" cy="395" rx="24" ry="26" class="island" transform="rotate(10 62 395)"/>
                        <!-- 沖縄 (작은 점들) -->
                        <circle cx="35" cy="450" r="4" class="island"/>
                        <circle cx="28" cy="462" r="3" class="island"/>
                    </svg>

                    <!-- 마커 레이어 : map.js 에서 bearData 를 이용해 마커를 동적으로 생성 -->
                    <div id="markerLayer" class="marker-layer"></div>

                    <!-- 마커 클릭 시 표시할 인포윈도우 (map.js 에서 내용/위치/표시여부 제어) -->
                    <div id="infoWindow" class="info-window d-none">
                        <button type="button" id="infoWindowClose" class="info-window-close">&times;</button>
                        <div id="infoWindowBody"></div>
                    </div>

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

            <!-- 목록 항목 : map.js 에서 bearData 를 이용해 동적으로 생성 -->
            <ul id="recentList" class="bear-list"></ul>
        </div>
    </section>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- 이 화면 전용 JS (다음 단계에서 작성 예정) -->
    <script src="/resources/js/map.js"></script>
    
    

</body>
</html>