<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
    =========================================================
    index.jsp
    - 사이트 메인(인덱스) 화면
    - 디자인 컨셉 : 크림 베이지 배경 + 레드/머스타드 포인트,
      두꺼운 블랙 테두리와 각진 카드/버튼 (일본 포스터/방재 사이트 톤)
    - 이 단계는 화면 구현만 담당. DB/Servlet/실제 지도 API 연동 없음
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

    <!-- 이 화면 전용 CSS (다음 단계에서 작성 예정) -->
    <link rel="stylesheet" href="/resources/css/index.css">
</head>
<body>

    <%-- ===================== 상단 경보 배너 ===================== --%>
    <div class="top-alert">
        <span>🍂</span>
        <span>秋の入山特別警戒期間（10月〜11月）— 冬眠前のクマの活動が活発化しています</span>
        <span class="close-x" id="alertClose">&times;</span>
    </div>

    <%-- ===================== Navbar ===================== --%>
    <nav class="navbar navbar-expand-lg navbar-jp">
        <div class="container d-flex align-items-center justify-content-between">
            <a href="/" class="d-flex align-items-center text-decoration-none">
                <div class="logo-badge me-2">熊</div>
                <div class="brand-jp">
                    <div class="jp-title">クマ出没マップ</div>
                    <div class="jp-sub">KUMA SHUTSUBOTSU MAP</div>
                </div>
            </a>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNavbar" aria-controls="mainNavbar" aria-expanded="false" aria-label="メニューを開く">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse flex-grow-0" id="mainNavbar">
                <ul class="navbar-nav mx-lg-4 mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link" href="#mapSection">出没マップ</a></li>
                    <li class="nav-item"><a class="nav-link" href="boardList.jsp">目撃情報掲示板</a></li>
                    <li class="nav-item"><a class="nav-link" href="/login">ログイン</a></li>
                    <li class="nav-item"><a class="nav-link" href="/signup">会員登録</a></li>
                </ul>
            </div>

            <a href="#mapSection" class="btn btn-jp-mustard d-none d-lg-inline-block">地図を見る</a>
        </div>
    </nav>

    <%-- ===================== Hero ===================== --%>
    <section class="hero-jp">
        <div class="container">
            <div class="row align-items-center">

                <!-- 세로 사이드바 텍스트 -->
                <div class="col-auto d-none d-md-block">
                    <div class="hero-sidebar">
                        山からの警告
                        <span class="en">WARNING FROM THE MOUNTAIN</span>
                    </div>
                </div>

                <!-- 본문 -->
                <div class="col-md-6">
                    <p class="hero-eyebrow"><span class="dash">―</span>全国クマ目撃情報プラットフォーム</p>
                    <h1>クマ出没マップで、<span class="accent-red">いち早く知</span>る。</h1>
                    <p class="lead-jp">
                        里山に近づく足音を見逃さない。全国の目撃情報と自治体データをリアルタイムに集約し、危険エリアをひと目で確認できる地図サービスです。
                    </p>
                    <div class="d-flex gap-2 flex-wrap">
                        <a href="#mapSection" class="btn btn-jp-mustard btn-lg">地図を見る →</a>
                        <a href="#" class="btn btn-jp-outline btn-lg">目撃情報を報告する</a>
                    </div>
                    <p class="hero-credit">
                        提供元：自治体オープンデータ・警察発表・住民報告を統合<br>
                        ※本サイトはポートフォリオ制作用のデモです
                    </p>
                </div>

                <!-- 경고 다이아몬드 사인 -->
                <div class="col-md-5 mt-5 mt-md-0">
                    <div class="warning-sign-wrap">
                        <div class="warning-sign">
                            <div class="warning-sign-inner">
                                <div class="bear-face">熊</div>
                                <div class="sign-text">熊出没<br>注意</div>
                            </div>
                        </div>
                        <div class="warning-sign-post"></div>
                    </div>
                </div>

            </div>
        </div>
    </section>

    <%-- ===================== 出没マップ セクション（플레이스홀더） ===================== --%>
    <section id="mapSection" class="container my-5">
        <h3 class="section-title-jp"><span class="dash">―</span>出没マップ</h3>
        <div class="row g-4">
            <div class="col-lg-9">
                <div class="card card-jp"><div class="card-body">
                    <div id="mapContainer">地図表示エリア（今後実装予定）</div>
                </div></div>
            </div>
            <div class="col-lg-3">
                <div class="card card-jp h-100"><div class="card-body map-legend">
                    <h6 class="fw-bold mb-3">危険度の凡例</h6>
                    <p class="mb-2"><span class="legend-dot danger"></span>危険（DANGER）</p>
                    <p class="mb-2"><span class="legend-dot warning"></span>警戒（WARNING）</p>
                    <p class="mb-0"><span class="legend-dot caution"></span>注意（CAUTION）</p>
                </div></div>
            </div>
        </div>

        <div class="filter-box mt-4">
            <div class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label fw-bold d-block">危険度</label>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" id="riskDanger" checked>
                        <label class="form-check-label" for="riskDanger">危険</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" id="riskWarning" checked>
                        <label class="form-check-label" for="riskWarning">警戒</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="checkbox" id="riskCaution" checked>
                        <label class="form-check-label" for="riskCaution">注意</label>
                    </div>
                </div>
                <div class="col-md-3">
                    <label for="periodSelect" class="form-label fw-bold">期間</label>
                    <select class="form-select" id="periodSelect">
                        <option selected>全期間</option>
                        <option>1週間</option>
                        <option>1ヶ月</option>
                        <option>3ヶ月</option>
                    </select>
                </div>
                <div class="col-md-5">
                    <label for="areaSearchInput" class="form-label fw-bold">地域検索</label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="areaSearchInput" placeholder="例：札幌市、富山県">
                        <button class="btn btn-jp-mustard" type="button" id="areaSearchBtn">
                            <i class="bi bi-search"></i> 検索
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <%-- ===================== 最近の目撃情報 ===================== --%>
    <section class="container my-5">
        <h3 class="section-title-jp"><span class="dash">―</span>最近の目撃情報</h3>
        <div class="row g-4">

            <div class="col-md-4 col-sm-6"><div class="card h-100 report-card">
                <img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600" class="card-img-top" alt="クマ出没イメージ">
                <div class="card-body d-flex flex-column">
                    <span class="badge badge-danger-custom mb-2 align-self-start">危険</span>
                    <h5 class="card-title">札幌近郊の登山道でクマを発見</h5>
                    <p class="mb-1 text-muted small"><i class="bi bi-geo-alt-fill"></i> 北海道札幌市</p>
                    <p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> 2026-08-20 07:30</p>
                    <p class="small flex-grow-1">登山道入口付近で成獣のクマ1頭を発見、登山客は避難済みです。</p>
                    <a href="#" class="btn btn-jp-outline btn-sm mt-2">詳細を見る</a>
                </div></div>
            </div>

            <div class="col-md-4 col-sm-6"><div class="card h-100 report-card">
                <img src="https://images.unsplash.com/photo-1465311440653-ba9b1d9b5f04?w=600" class="card-img-top" alt="クマ出没イメージ">
                <div class="card-body d-flex flex-column">
                    <span class="badge badge-warning-custom mb-2 align-self-start">警戒</span>
                    <h5 class="card-title">農地周辺でクマの足跡を発見</h5>
                    <p class="mb-1 text-muted small"><i class="bi bi-geo-alt-fill"></i> 青森県</p>
                    <p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> 2026-08-19 18:10</p>
                    <p class="small flex-grow-1">農地付近でクマの足跡と糞の痕跡を発見しました。</p>
                    <a href="#" class="btn btn-jp-outline btn-sm mt-2">詳細を見る</a>
                </div></div>
            </div>

            <div class="col-md-4 col-sm-6"><div class="card h-100 report-card">
                <img src="https://images.unsplash.com/photo-1500534623283-312aade485b2?w=600" class="card-img-top" alt="クマ出没イメージ">
                <div class="card-body d-flex flex-column">
                    <span class="badge badge-caution-custom mb-2 align-self-start">注意</span>
                    <h5 class="card-title">登山道でクマの鳴き声を確認</h5>
                    <p class="mb-1 text-muted small"><i class="bi bi-geo-alt-fill"></i> 岩手県</p>
                    <p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> 2026-08-18 06:45</p>
                    <p class="small flex-grow-1">登山者がクマと思われる鳴き声を聞いたと報告しています。</p>
                    <a href="#" class="btn btn-jp-outline btn-sm mt-2">詳細を見る</a>
                </div></div>
            </div>

        </div>
        <div class="text-center mt-4"><a href="boardList.jsp" class="btn btn-jp-mustard">目撃情報掲示板をすべて見る</a></div>
    </section>

    <%-- ===================== 安全に関するご案内 ===================== --%>
    <section class="container my-5">
        <h3 class="section-title-jp"><span class="dash">―</span>安全に関するご案内</h3>
        <div class="row g-4">
            <div class="col-md-4"><div class="card info-card"><div class="card-body">
                <h5 class="card-title"><i class="bi bi-geo-fill icon-red"></i> 最近の警戒エリア</h5>
                <p class="text-muted">北海道、青森県、秋田県で最近クマの目撃情報が増加しています。</p>
            </div></div></div>
            <div class="col-md-4"><div class="card info-card"><div class="card-body">
                <h5 class="card-title"><i class="bi bi-signpost-split-fill icon-mustard"></i> 登山前にご確認ください</h5>
                <p class="text-muted">登山前には必ず出没マップを確認し、鈴やラジオなど音の出る道具をご準備ください。</p>
            </div></div></div>
            <div class="col-md-4"><div class="card info-card"><div class="card-body">
                <h5 class="card-title"><i class="bi bi-shield-fill-exclamation"></i> クマに遭遇した時の対処法</h5>
                <p class="text-muted">背を向けず、ゆっくり後退して距離をとり、大声を出さないでください。</p>
            </div></div></div>
        </div>
    </section>

    <%-- ===================== 제보하기 플로팅 버튼 ===================== --%>
    <button type="button" class="btn btn-jp-mustard report-float-btn">
        <i class="bi bi-exclamation-triangle-fill"></i> クマ出没を報告する
    </button>

    <%-- ===================== Footer ===================== --%>
    <footer class="footer-jp pt-5 pb-3">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="d-flex align-items-center mb-3">
                        <div class="logo-badge me-2">熊</div>
                        <div class="brand-jp"><div class="jp-title">クマ出没マップ</div></div>
                    </div>
                    <p class="small footer-muted">里山に近づく足音を見逃さない。<br>全国のクマ目撃情報をリアルタイムに共有するサービスです。</p>
                </div>
                <div class="col-md-4 mb-4">
                    <h6 class="fw-bold mb-3 footer-heading">会社情報</h6>
                    <ul class="list-unstyled small footer-muted">
                        <li class="mb-2">株式会社ベアセーフ（BearSafe Inc.）</li>
                        <li class="mb-2"><i class="bi bi-telephone-fill me-2"></i>03-1234-5678</li>
                        <li class="mb-2"><i class="bi bi-geo-alt-fill me-2"></i>日本 北海道 札幌市 中央区 1-1-1</li>
                    </ul>
                </div>
                <div class="col-md-4 mb-4">
                    <h6 class="fw-bold mb-3 footer-heading">サイトマップ</h6>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><a href="#mapSection">出没マップ</a></li>
                        <li class="mb-2"><a href="#">目撃情報掲示板</a></li>
                        <li class="mb-2"><a href="/login">ログイン</a></li>
                        <li class="mb-2"><a href="/signup">会員登録</a></li>
                    </ul>
                </div>
            </div>
            <hr class="footer-divider">
            <div class="text-center small footer-copyright">&copy; 2026 BearSafe Inc. All Rights Reserved.</div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- 이 화면 전용 JS (필요 시 다음 단계에서 작성) -->
    <script src="/resources/js/index.js"></script>

</body>
</html>