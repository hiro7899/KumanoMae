<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>クマ出没マップ</title>

<!-- Bootstrap 5 CDN & Icons -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<!-- 일본어 폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap"
	rel="stylesheet">

<!-- 이 화면 전용 CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/index.css?v=home-sections-2">

</head>

<%-- body 태그에 세션 로그인 여부(true/false)와 ContextPath를 속성값으로 심어둠 --%>
<c:set var="isLogin" value="false" />
<c:if
	test="${not empty sessionScope.loginUser or not empty sessionScope.user or not empty sessionScope.loginMember or not empty sessionScope.member}">
	<c:set var="isLogin" value="true" />
</c:if>

<body data-is-login="${isLogin}"
	data-context-path="${pageContext.request.contextPath}">

	<%-- ===================== 시작 화면 이미지 ===================== --%>
	<div id="splashScreen" class="splash-screen" aria-label="Kumano Mae 시작 화면">
		<img src="${pageContext.request.contextPath}/resources/img/brand/kumano-mae-splash.png"
			alt="Kumano Mae" class="splash-screen-image">
	</div>

	<%-- ===================== 상단 경보 배너 ===================== --%>
	<div class="top-alert">
		<span>🍂</span> <span>秋の入山特別警戒期間（09月〜11月）— 冬眠前のクマの活動が活発化しています</span> <span
			class="close-x" id="alertClose">&times;</span>
	</div>

	<!-- 공통 헤더 INCLUDE -->
	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<%-- ===================== Hero ===================== --%>
	<section class="hero-jp">
		<div class="container">
			<div class="row align-items-center">

				<!-- 세로 사이드바 텍스트 -->
				<div class="col-auto d-none d-md-block">
					<div class="hero-sidebar">
						山からの警告 <span class="en">WARNING FROM THE MOUNTAIN</span>
					</div>
				</div>

				<!-- 본문 -->
				<div class="col-md-6">
					<p class="hero-eyebrow">
						<span class="dash">―</span>全国クマ目撃情報プラットフォーム
					</p>
					<h1>
						クマ出没マップで、<span class="accent-red">いち早く知</span>る。
					</h1>
					<p class="lead-jp">
						里山に近づく足音を見逃さない。全国の目撃情報と自治体データをリアルタイムに集約し、危険エリアをひと目で確認できる地図サービスです。
					</p>
					<div class="d-flex gap-2 flex-wrap">
						<a href="${pageContext.request.contextPath}/map"
							class="btn btn-jp-mustard btn-lg">地図を見る →</a>
						<button type="button" class="btn btn-jp-outline btn-lg"
							onclick="checkLoginAndReport()">目撃情報を報告する</button>
					</div>
					<p class="hero-credit">
						提供元：自治体オープンデータ・警察発表・住民報告を統合<br> ※本サイトはポートフォリオ制作用のデモです
					</p>
				</div>

				<!-- 경고 다이아몬드 사인 -->
				<div class="col-md-5 mt-5 mt-md-0">
					<div class="warning-sign-wrap">
						<svg class="hero-bear-silhouette" viewBox="0 0 248.662 248.662" aria-hidden="true">
							<path d="M248.343 175.365c-1.779-5.671-9.99-13.958-8.992-25.03.998-11.068 9.798-36.354 7.514-47.147s-13.737-42.525-43.349-47.324c-29.599-4.797-50.858 3.166-62.211 2.655-11.345-.513-13.409-9.091-25.95-8.98-16.188.15-18.975 6.869-30.42 10.473-8.392 2.645-34.676 2.613-34.676 2.613s-7.52-9.812-9.812-6.217c-2.292 3.597-5.236 12.757-5.236 12.757s-14.068 4.905-15.371 7.528c-1.304 2.623-3.094 6.876-3.094 6.876S1.847 87.486.213 91.083c-1.633 3.595 6.546 12.096 9.161 15.048 2.615 2.951 33.035 3.597 37.856 7.149 4.819 3.557 18.315 6.226 25.852 7.52 14.145 2.435 20.362 30.533 23.957 61.61-4.254 3.603-11.776 6.793-12.183 16.715h46.114s.613-6.624 1.395-14.827c.77-8.203 14.719-39.253 14.719-39.253s10.135 7.851 17.008 8.188c-.646 6.211 2.252 12.819 2.252 12.819s5.936 7.129 11.706 12.771c-10.563 4.356-10.255 12.039-10.255 12.039l39.145.304s3.923-8.171 3.923-14.719c5.246 7.53 15.381 10.472 15.381 10.472l-6.304 12.206h23.92c-.085 0 6.163-18.086 4.383-23.752zM28.482 85.278a3.107 3.107 0 1 1 0-6.216 3.107 3.107 0 0 1 0 6.216z"/>
						</svg>
						<div class="warning-sign">
							<div class="warning-sign-inner">
								<div class="bear-face">熊</div>
								<div class="sign-text">
									熊出没<br>注意
								</div>
							</div>
						</div>
						<div class="warning-sign-post"></div>
					</div>
				</div>

			</div>
		</div>

	</section>

	<%-- ===================== 出没マップ セクション ===================== --%>
	<section id="mapSection" class="container my-5">
		<h3 class="section-title-jp">
			<span class="dash">―</span>出没マップ
		</h3>
		<div class="row g-4">
			<div class="col-lg-9">
				<div class="card card-jp">
					<div class="card-body p-0">
						<!-- 구글 맵이 출력될 영역 -->
						<div id="mapContainer" style="height: 480px; width: 100%;"></div>
					</div>
				</div>
			</div>
			<div class="col-lg-3">
				<div class="card card-jp h-100">
					<div class="card-body map-legend">
						<h6 class="fw-bold mb-3">危険度の凡例</h6>

						<div class="mb-3">
							<p class="mb-1 fw-bold map-legend-title">
								<span><span class="legend-dot danger"></span>危険（DANGER）</span>
								<span id="dangerCount" class="map-risk-count danger">0件</span>
							</p>
							<small class="text-muted d-block ps-3">姿を目撃・撮影</small>
						</div>

						<div class="mb-3">
							<p class="mb-1 fw-bold map-legend-title">
								<span><span class="legend-dot warning"></span>警戒（WARNING）</span>
								<span id="warningCount" class="map-risk-count warning">0件</span>
							</p>
							<small class="text-muted d-block ps-3">足跡・痕跡を発見</small>
						</div>

						<div>
							<p class="mb-1 fw-bold map-legend-title">
								<span><span class="legend-dot caution"></span>注意（CAUTION）</span>
								<span id="cautionCount" class="map-risk-count caution">0件</span>
							</p>
							<small class="text-muted d-block ps-3">鳴き声・気配を感知</small>
						</div>

						<div>
							<p class="mb-1 fw-bold map-legend-title">
								<span><span class="legend-dot clear"></span>解除（CLEAR）</span>
								<span id="clearCount" class="map-risk-count clear">0件</span>
							</p>
							<small class="text-muted d-block ps-3">危険解除済み</small>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="filter-box mt-4">
			<div class="row g-3 align-items-end">
				<div class="col-md-4">
					<label class="form-label fw-bold d-block">危険度</label>
					<div class="form-check form-check-inline risk-filter danger">
						<input class="form-check-input" type="checkbox" id="riskDanger"
							checked> <label class="form-check-label" for="riskDanger">危険</label>
					</div>
					<div class="form-check form-check-inline risk-filter warning">
						<input class="form-check-input" type="checkbox" id="riskWarning"
							checked> <label class="form-check-label"
							for="riskWarning">警戒</label>
					</div>
					<div class="form-check form-check-inline risk-filter caution">
						<input class="form-check-input" type="checkbox" id="riskCaution"
							checked> <label class="form-check-label"
							for="riskCaution">注意</label>
					</div>
					<div class="form-check form-check-inline risk-filter clear">
						<input class="form-check-input" type="checkbox" id="riskClear" checked>
						<label class="form-check-label" for="riskClear">解除</label>
					</div>
				</div>
				<div class="col-md-3">
					<label for="periodSelect" class="form-label fw-bold">期間</label> <select
						class="form-select" id="periodSelect">
						<option value="all" selected>全期間</option>
						<option value="7">1週間</option>
						<option value="30">1ヶ月</option>
						<option value="90">3ヶ月</option>
					</select>
				</div>
				<div class="col-md-5">
					<label for="areaSearchInput" class="form-label fw-bold">地域検索</label>
					<div class="input-group">
						<input type="text" class="form-control" id="areaSearchInput"
							placeholder="例：札幌市、富山県">
						<button class="btn btn-jp-mustard" type="button"
							id="areaSearchBtn" onclick="searchArea()">
							<i class="bi bi-search"></i> 検索
						</button>
					</div>
				</div>
			</div>
		</div>
	</section>

	<%-- ===================== 뉴스·공지 섹션 ===================== --%>
	<section class="container my-5 home-news-section">
		<h3 class="section-title-jp">
			<span class="dash">―</span>最新ニュース
		</h3>
		<c:choose>
			<c:when test="${not empty newsList}">
				<div class="row g-4">
					<c:forEach var="news" items="${newsList}" end="2">
						<div class="col-md-4 col-sm-6">
							<article class="card h-100 report-card">
								<img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600"
									class="card-img-top" alt="クマ関連ニュース">
								<div class="card-body d-flex flex-column">
									<c:choose>
										<c:when test="${news.sourceType eq 'SIGHTING'}"><span class="badge badge-danger-custom mb-2 align-self-start">出没情報</span></c:when>
										<c:when test="${news.sourceType eq 'SAFETY'}"><span class="badge badge-warning-custom mb-2 align-self-start">安全対策</span></c:when>
										<c:otherwise><span class="badge badge-caution-custom mb-2 align-self-start">自治体のお知らせ</span></c:otherwise>
									</c:choose>
									<h5 class="card-title"><c:out value="${news.title}" /></h5>
									<p class="mb-2 text-muted small">
										<i class="bi bi-building"></i> <c:out value="${news.sourceName}" />
										<span class="ms-2"><i class="bi bi-clock-fill"></i> <c:out value="${news.publishedDate}" /></span>
									</p>
									<p class="small flex-grow-1"><c:out value="${news.summary}" /></p>
									<a href="${news.sourceUrl}" target="_blank" rel="noopener noreferrer"
										class="btn btn-jp-outline btn-sm mt-2">原文を見る <i class="bi bi-box-arrow-up-right"></i></a>
								</div>
							</article>
						</div>
					</c:forEach>
				</div>
			</c:when>
			<c:otherwise>
				<div class="card card-jp border-0 py-4 text-center">
					<div class="card-body text-muted">
						<i class="bi bi-newspaper fs-1 d-block mb-2"></i>
						<p class="fw-bold mb-0">現在表示できるニュースはありません。</p>
					</div>
				</div>
			</c:otherwise>
		</c:choose>
		<div class="text-center mt-4">
			<a href="${pageContext.request.contextPath}/board/news"
				class="btn btn-jp-mustard">ニュースをすべて見る</a>
		</div>
	</section>

	<%-- ===================== 목격 제보 섹션 ===================== --%>
	<section class="container my-5 home-preview-section home-report-section">
		<div class="section-heading-row">
			<h3 class="section-title-jp mb-0"><span class="dash">―</span>最新の目撃情報</h3>
		</div>
		<div class="row g-4">
			<c:forEach var="board" items="${boardList}" end="2">
				<c:if test="${board.clearYn ne 'Y'}">
				<div class="col-md-4 col-sm-6">
					<article class="card h-100 report-card preview-card clickable-card" data-card-href="${pageContext.request.contextPath}/board/detail?boardId=${board.boardId}">
						<c:choose>
							<c:when test="${not empty board.thumbnailUrl}">
								<c:url var="boardThumbnailUrl" value="${board.thumbnailUrl}"/>
								<div class="preview-card-image">
									<img src="${boardThumbnailUrl}" class="preview-card-thumb" alt="目撃情報画像">
								</div>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${board.riskLevel eq 'DANGER'}"><div class="preview-card-image preview-card-image-danger"><i class="bi bi-exclamation-triangle-fill"></i></div></c:when>
									<c:when test="${board.riskLevel eq 'WARNING'}"><div class="preview-card-image preview-card-image-caution"><i class="bi bi-signpost-split-fill"></i></div></c:when>
									<c:otherwise><div class="preview-card-image preview-card-image-safe"><i class="bi bi-shield-check"></i></div></c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
						<div class="card-body d-flex flex-column">
							<c:choose>
								<c:when test="${board.riskLevel eq 'DANGER'}"><span class="badge badge-danger-custom mb-2 align-self-start">危険</span></c:when>
								<c:when test="${board.riskLevel eq 'WARNING'}"><span class="badge badge-warning-custom mb-2 align-self-start">警戒</span></c:when>
								<c:otherwise><span class="badge badge-caution-custom mb-2 align-self-start">注意</span></c:otherwise>
							</c:choose>
							<h5 class="card-title"><c:out value="${board.title}" /></h5>
							<p class="mb-2 text-muted small"><i class="bi bi-geo-alt"></i> <c:out value="${board.address}" /> <span class="ms-2"><i class="bi bi-clock"></i> ${fn:substring(fn:replace(board.sightingDate, 'T', ' '), 0, 16)}</span></p>
							<p class="small flex-grow-1"><c:out value="${board.content}" /></p>
						</div>
					</article>
				</div>
				</c:if>
			</c:forEach>
			<c:if test="${empty boardList}"><div class="col-12"><div class="card card-jp border-0 py-4 text-center"><div class="card-body text-muted"><i class="bi bi-geo-alt fs-1 d-block mb-2"></i><p class="fw-bold mb-0">現在表示できる目撃情報はありません。</p></div></div></div></c:if>
		</div>
		<div class="text-center mt-4"><a href="${pageContext.request.contextPath}/board/list" class="btn btn-jp-mustard">目撃情報をすべて見る</a></div>
	</section>

	<%-- ===================== 커뮤니티 섹션 ===================== --%>
	<section class="container my-5 home-preview-section home-community-section">
		<div class="section-heading-row">
			<h3 class="section-title-jp mb-0"><span class="dash">―</span>コミュニティの最新投稿</h3>
		</div>
		<div class="row g-4">
			<c:forEach var="community" items="${communityList}" end="2">
				<div class="col-md-4 col-sm-6">
					<article class="card h-100 report-card preview-card clickable-card" data-card-href="${pageContext.request.contextPath}/community/detail?cBoardId=${community.cBoardId}">
						<c:choose>
							<c:when test="${not empty community.thumbnailUrl}">
								<c:url var="communityThumbnailUrl" value="${community.thumbnailUrl}"/>
								<div class="preview-card-image">
									<img src="${communityThumbnailUrl}" class="preview-card-thumb" alt="コミュニティ投稿画像">
								</div>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${community.category eq 'GEAR'}"><div class="preview-card-image preview-card-image-gear"><i class="bi bi-backpack-fill"></i></div></c:when>
									<c:when test="${community.category eq 'REVIEW'}"><div class="preview-card-image preview-card-image-trail"><i class="bi bi-map-fill"></i></div></c:when>
									<c:otherwise><div class="preview-card-image preview-card-image-talk"><i class="bi bi-people-fill"></i></div></c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
						<div class="card-body d-flex flex-column">
							<c:choose>
								<c:when test="${community.category eq 'GEAR'}"><span class="badge badge-caution-custom mb-2 align-self-start">ギア</span></c:when>
								<c:when test="${community.category eq 'REVIEW'}"><span class="badge badge-warning-custom mb-2 align-self-start">レビュー</span></c:when>
								<c:otherwise><span class="badge badge-danger-custom mb-2 align-self-start">自由掲示板</span></c:otherwise>
							</c:choose>
							<h5 class="card-title"><c:out value="${community.title}" /></h5>
							<p class="mb-2 text-muted small"><i class="bi bi-person-circle"></i> <c:out value="${community.writerName}" /> <span class="ms-2"><i class="bi bi-clock"></i> ${fn:substring(fn:replace(community.regDate, 'T', ' '), 0, 16)}</span></p>
							<p class="small flex-grow-1"><i class="bi bi-heart"></i> ${community.likeCnt} <span class="ms-2"><i class="bi bi-chat-square-text"></i> ${community.commentCnt}</span></p>
						</div>
					</article>
				</div>
			</c:forEach>
			<c:if test="${empty communityList}"><div class="col-12"><div class="card card-jp border-0 py-4 text-center"><div class="card-body text-muted"><i class="bi bi-chat-square-dots fs-1 d-block mb-2"></i><p class="fw-bold mb-0">まだコミュニティ投稿がありません。</p></div></div></div></c:if>
		</div>
		<div class="text-center mt-4"><a href="${pageContext.request.contextPath}/community/list" class="btn btn-jp-mustard">コミュニティをすべて見る</a></div>
	</section>

	<%-- ===================== 안전에 관한 안내 ===================== --%>
	<section class="container my-5">
		<h3 class="section-title-jp">
			<span class="dash">―</span>安全に関するご案内
		</h3>
		<div class="row g-4">
			<div class="col-md-4">
				<div class="card info-card">
					<div class="card-body">
						<h5 class="card-title">
							<i class="bi bi-geo-fill icon-red"></i> 最近の警戒エリア
						</h5>
						<p class="text-muted">北海道、青森県、秋田県で最近クマの目撃情報が増加しています。</p>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="card info-card">
					<div class="card-body">
						<h5 class="card-title">
							<i class="bi bi-signpost-split-fill icon-mustard"></i>
							登山前にご確認ください
						</h5>
						<p class="text-muted">登山前には必ず出没マップを確認し、鈴やラジオなど音の出る道具をご準備ください。</p>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="card info-card">
					<div class="card-body">
						<h5 class="card-title">
							<i class="bi bi-shield-fill-exclamation"></i> クマに遭遇した時の対処法
						</h5>
						<p class="text-muted">背を向けず、ゆっくり後退して距離をとり、大声を出さないでください。</p>
					</div>
				</div>
			</div>
		</div>

		<div class="card card-jp border-danger mt-4">
			<div class="card-body p-4">
				<div class="row align-items-center g-4">
					<div class="col-lg-8">
						<h4 class="fw-bold text-danger mb-3">
							<i class="bi bi-exclamation-octagon-fill me-2"></i>緊急時の対応
						</h4>
						<p class="mb-2">クマに遭遇した場合は、走ったり背中を見せたりせず、落ち着いてゆっくり後退してください。</p>
						<p class="mb-0 text-muted small">
							子グマには近づかないでください。近くに母グマがいる可能性があります。安全を確保した後、目撃場所を警察または自治体へ連絡してください。
						</p>
					</div>
					<div class="col-lg-4">
						<div class="d-grid gap-2">
							<a href="tel:110" class="btn btn-danger fw-bold">
								<i class="bi bi-telephone-fill me-2"></i>緊急の危険：警察 110
							</a>
							<a href="tel:119" class="btn btn-jp-outline fw-bold">
								<i class="bi bi-heart-pulse-fill me-2"></i>けが人：消防・救急 119
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

	<%-- ===================== Footer ===================== --%>
	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
	<script>
		document.addEventListener("DOMContentLoaded", function () {
			document.querySelectorAll(".clickable-card[data-card-href]").forEach(function (card) {
				card.setAttribute("tabindex", "0");
				card.setAttribute("role", "link");
				card.addEventListener("click", function () {
					window.location.href = card.dataset.cardHref;
				});
				card.addEventListener("keydown", function (event) {
					if (event.key === "Enter" || event.key === " ") {
						event.preventDefault();
						window.location.href = card.dataset.cardHref;
					}
				});
			});
		});
	</script>

	<!-- Bootstrap 5 JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/index.js"></script>

	<!-- Google Map 및 관련 로직 -->
	<script>
		let map;
		let geocoder;
		let markerInfoWindow;
		let allSightings = [];
		let sightingMarkers = [];
		const defaultMapCenter = { lat: 36.2, lng: 138.25 };
		const defaultMapZoom = 5.5;

		// 1. Google Map 초기화 함수 (콜백 함수)
		function initMap() {
			// 기본 위치: 홋카이도/일본 중심부 부근
			map = new google.maps.Map(document.getElementById("mapContainer"),
					{
						zoom : defaultMapZoom,
						center : defaultMapCenter,
					});

			geocoder = new google.maps.Geocoder();
			markerInfoWindow = new google.maps.InfoWindow();
			loadSightingMarkers();
		}

		// 2. 등록된 목격 정보 조회
		async function loadSightingMarkers() {
			const contextPath = document.body.dataset.contextPath || "";

			try {
				const response = await fetch(contextPath + "/map/markers", {
					headers: { "Accept": "application/json" }
				});

				if (!response.ok) {
					throw new Error("マーカー情報の取得に失敗しました。");
				}

				allSightings = await response.json();
				applyMapFilters();
			} catch (error) {
				console.error(error);
			}
		}

		// 3. 선택한 위험도·기간 조건으로 지도 마커를 다시 표시
		function applyMapFilters() {
			if (!map) return;

			const checkedRisks = [
				document.getElementById("riskDanger").checked ? "DANGER" : null,
				document.getElementById("riskWarning").checked ? "WARNING" : null,
				document.getElementById("riskCaution").checked ? "CAUTION" : null,
				document.getElementById("riskClear").checked ? "CLEAR" : null
			].filter(Boolean);
			const periodDays = Number(document.getElementById("periodSelect").value);
			const cutoff = Number.isFinite(periodDays) && periodDays > 0
				? new Date(Date.now() - periodDays * 24 * 60 * 60 * 1000)
				: null;

			const filteredSightings = allSightings.filter(function(sighting) {
				if (checkedRisks.indexOf(normalizeRisk(sighting.displayRisk, sighting.clearYn)) === -1) {
					return false;
				}

				if (!cutoff) return true;
				const eventDate = new Date(sighting.eventDate || sighting.regDate);
				return Number.isNaN(eventDate.getTime()) || eventDate >= cutoff;
			});

			renderSightingMarkers(filteredSightings);
		}

		function renderSightingMarkers(sightings) {
			sightingMarkers.forEach(function(marker) {
				marker.setMap(null);
			});
			sightingMarkers = [];

				const bounds = new google.maps.LatLngBounds();
				const riskCounts = { DANGER: 0, WARNING: 0, CAUTION: 0, CLEAR: 0 };
				let markerCount = 0;

			sightings.forEach(function(sighting) {
					const latitude = Number(sighting.latitude);
					const longitude = Number(sighting.longitude);

					if (!Number.isFinite(latitude) || !Number.isFinite(longitude)) {
						return;
					}

					const risk = normalizeRisk(sighting.displayRisk, sighting.clearYn);
					riskCounts[risk]++;

					const position = { lat: latitude, lng: longitude };
					const marker = new google.maps.Marker({
						map: map,
						position: position,
						title: sighting.title || "クマ目撃情報",
						icon: createRiskMarkerIcon(risk)
					});

					marker.addListener("click", function() {
						markerInfoWindow.setContent(createMarkerInfoContent(sighting));
						markerInfoWindow.open({ map: map, anchor: marker });
					});

					bounds.extend(position);
					sightingMarkers.push(marker);
					markerCount++;
				});

			// 마커 위치에 따라 지도를 자동 이동하지 않고 일본 전국 중심을 유지합니다.
			// 지역 검색을 실행한 경우에는 검색 결과 위치로 이동합니다.
			if (markerCount === 0) {
				map.setCenter(defaultMapCenter);
				map.setZoom(defaultMapZoom);
			}

			updateRiskCounts(riskCounts);
		}

		function createRiskMarkerIcon(displayRisk) {
			const riskColors = {
				DANGER: "#b23a2e",
				WARNING: "#e3ac1f",
				CAUTION: "#f5e39a",
				CLEAR: "#9aa0a6"
			};
			const normalizedRisk = String(displayRisk || "").toUpperCase();
			const fillColor = riskColors[normalizedRisk] || "#b23a2e";
			const bearMarkerImages = {
				DANGER: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIIAAABaCAYAAAB0bo6/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAP3SURBVHhe7dZbkuMqEEXRGtEdQA/7TrA6TFsE3gfxFkgmT8T6SUFWgvmon9/f3x9jpGD2JAWzJymYPUnB7EkKZk9SMHuSgtmTFMyepGD2JAWzJymYPUnB7EkKxmkN+zyGFDZUlf///OdU7OffuyUpbCCZ44ceAeEctyKFmypNyZ4f/mBXi8zD8y0nhRtijlrs2xG3lz/IaifheZeQws34y+KlPlkkPPd0UrgRF17iN0F4/qmkcBMuvLhvEwnvYRop3IALL+2bIbyPKaRwAy68rG+H8E4uJ4UbkEvahT2ET3JBO1n1GKSwmFzMjhDe0SWksJA7NC9lV1s/BF7G7mY+BiksIpdg/pn1GKSwgAsvwPyzw0PwB+ThzadvfAiMPYICx11dSQoX8uFBTVoQ3ukwUriIPYAOX/UQeDhT5xseghzK1LOHYJwgvN8hpHABOZRpc+VjkMJgLjyQafPoh8DDmD5PfAhuYB7E9AnC++4ihUFceAjT73EPgQcwYzzpIcjwZpynPAQXDm/GecxD4OBmLIT330wKHdxgHNyMhfA3aCaFDjK0Ge+KR/AihQ4ytBnv9g+BA5tr2EMwzu0fwmsyDm3Gs4dgHHsIxrGHYJwnPAT7h3GCRzyE13Qc3IxlD8F4VzwGKXSSoc14CH+DJlLoJEM/3XGuMFyzAsLfoZoUOsnAM4UXw28tUuHaFRD+FlWk0EmGnSkMv9UKwjO6c474GyNk5iwmhR4ccrYw/FYriJzzzYd7ZwrC+apIoYMMOVsYfqsRhGckH/aYqXDWJCl0kAFnC9I1D/qUcGGfWSpnjZJCBxkwJxeuz3mneR70CXuVcGGvGRpmFVLoIAOmROL7HOGelCBN82R6lXJhv6s1zvpBCp1kSEK43/d5hXtTYj25plSsVwUX9rxSx6yeFDr5cNhg4CPc+9GHe3PYk99LFc6X4sK+pVr2d87rSGGQXLhe9vGwKUF8L64pFeuVcRr2LhGk+AzH+h5SGCgWriG3hgfNOevPdSXOep3wYZ8Wrf3e4WxVpLCQOwwPmRPkoxfXlTrpF+PC/T3C8FvKO5yvihQWqT58cAG8hKZemZ4xXX+HwvBbShDOV0UKi1RdANLUIybSM0X2twrDbzlBOF8VKSxSfAmI3891LSJ9U2R/C4bfU4JwtmpSWMSHhz05+Ct+L9e1iPTNcWGfGmfhupggnKuJFBYqDfdU/4NJJ71L+LBnSiQ15w/DeZpJ4QZSkbW85FqZ/iV609KLM3STwsPID1vq2H/B5ZaEe5aTwsO48EfOQdhzS1J4IBf+2DEI+2xNCg9VE+41X/QQDrlwvXmTgtmTFMyepGD2JAWzJymYPUnB7EkKZk9/AYTSSlYgomLuAAAAAElFTkSuQmCC",
				WARNING: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIIAAABaCAYAAAB0bo6/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAP3SURBVHhe7dZbjuQqEEXRmsmdv9SzugOpVtJpRO6DeRvsJI60fsIQFZB81M/v7++PMVIwe5KC2ZMUzJ6kYPYkBbMnKZg9ScHsSQpmT1Iwe5KC2ZMUzJ6kYPYkBeO0hn0eQwobqsr/f/5zKvbz792SFDaQzPFDj4BwjluRwk2VpmTPD3+wq0Xm4fmWk8INMUct9u2I28sfZLWT8LxLSOFm/GXxUp8sEp57OinciAsv8ZsgPP9UUrgJF17ct4mE9zCNFG7AhZf2zRDexxRSuAEXXta3Q3gnl5PCDcgl7cIewie5oJ2segxSWEwuZkcI7+gSUljIHZqXsqutHwIvY3czH4MUFpFLMP/MegxSWMCFF2D+2eEh+APy8ObTNz4Exh5BgeOuriSFC/nwoCYtCO90GClcxB5Ah696CDycqfMND0EOZerZQzBOEN7vEFK4gBzKtLnyMUhhMBceyLR59EPgYUyfJz4ENzAPYvoE4X13kcIgLjyE6fe4h8ADmDGe9BBkeDPOUx6CC4c34zzmIXBwMxbC+28mhQ5uMA5uxkL4GzSTQgcZ2ox3xSN4kUIHGdqMd/uHwIHNNewhGOf2D+E1GYc249lDMI49BOPYQzDOEx6C/cM4wSMewms6Dm7GsodgvCsegxQ6ydBmPIS/QRMpdJKhn+44VxiuWQHh71BNCp1k4JnCi+G3Fqlw7QoIf4sqUugkw84Uht9qBeEZ3TlH/I0RMnMWk0IPDjlbGH6rFUTO+ebDvTMF4XxVpNBBhpwtDL/VCMIzkg97zFQ4a5IUOsiAswXpmgd9SriwzyyVs0ZJoYMMmJML1+e80zwP+oS9Sriw1wwNswopdJABUyLxfY5wT0qQpnkyvUq5sN/VGmf9IIVOMiQh3O/7vMK9KbGeXFMq1quCC3teqWNWTwqdfDhsMPAR7v3ow7057MnvpQrnS3Fh31It+zvndaQwSC5cL/t42JQgvhfXlIr1yjgNe5cIUnyGY30PKQwUC9eQW8OD5pz157oSZ71O+LBPi9Z+73C2KlJYyB2Gh8wJ8tGL60qd9Itx4f4eYfgt5R3OV0UKi1QfPrgAXkJTr0zPmK6/Q2H4LSUI56sihUWqLgBp6hET6Zki+1uF4becIJyvihQWKb4ExO/nuhaRvimyvwXD7ylBOFs1KSziw8OeHPwVv5frWkT65riwT42zcF1MEM7VRAoLlYZ7qv/BpJPeJXzYMyWSmvOH4TzNpHADqchaXnKtTP8SvWnpxRm6SeFh5Ictdey/4HJLwj3LSeFhXPgj5yDsuSUpPJALf+wYhH22JoWHqgn3mi96CIdcuN68ScHsSQpmT1Iwe5KC2ZMUzJ6kYPYkBbOnv6McYNQLMsIBAAAAAElFTkSuQmCC",
				CAUTION: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIIAAABaCAYAAAB0bo6/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAP3SURBVHhe7dZNkuMqEIXR2v8S3vZ6DW9cHaYtAn8X8S+QTN6IM0lBVoIZ1M/v7++PMVIwe5KC2ZMUzJ6kYPYkBbMnKZg9ScHsSQpmT1Iwe5KC2ZMUzJ6kYPYkBeO0hn0eQwobqsr/f/5zKvbz792SFDaQzPFDj4BwjluRwk2VpmTPD3+wq0Xm4fmWk8INMUct9u2I28sfZLWT8LxLSOFm/GXxUp8sEp57OinciAsv8ZsgPP9UUrgJF17ct4mE9zCNFG7AhZf2zRDexxRSuAEXXta3Q3gnl5PCDcgl7cIewie5oJ2segxSWEwuZkcI7+gSUljIHZqXsqutHwIvY3czH4MUFpFLMP/MegxSWMCFF2D+2eEh+APy8ObTNz4Exh5BgeOuriSFC/nwoCYtCO90GClcxB5Ah696CDycqfMND0EOZerZQzBOEN7vEFK4gBzKtLnyMUhhMBceyLR59EPgYUyfJz4ENzAPYvoE4X13kcIgLjyE6fe4h8ADmDGe9BBkeDPOUx6CC4c34zzmIXBwMxbC+28mhQ5uMA5uxkL4GzSTQgcZ2ox3xSN4kUIHGdqMd/uHwIHNNewhGOf2D+E1GYc249lDMI49BOPYQzDOEx6C/cM4wSMewms6Dm7GsodgvCsegxQ6ydBmPIS/QRMpdJKhn+44VxiuWQHh71BNCp1k4JnCi+G3Fqlw7QoIf4sqUugkw84Uht9qBeEZ3TlH/I0RMnMWk0IPDjlbGH6rFUTO+ebDvTMF4XxVpNBBhpwtDL/VCMIzkg97zFQ4a5IUOsiAswXpmgd9SriwzyyVs0ZJoYMMmJML1+e80zwP+oS9Sriw1wwNswopdJABUyLxfY5wT0qQpnkyvUq5sN/VGmf9IIVOMiQh3O/7vMK9KbGeXFMq1quCC3teqWNWTwqdfDhsMPAR7v3ow7057MnvpQrnS3Fh31It+zvndaQwSC5cL/t42JQgvhfXlIr1yjgNe5cIUnyGY30PKQwUC9eQW8OD5pz157oSZ71O+LBPi9Z+73C2KlJYyB2Gh8wJ8tGL60qd9Itx4f4eYfgt5R3OV0UKi1QfPrgAXkJTr0zPmK6/Q2H4LSUI56sihUWqLgBp6hET6Zki+1uF4becIJyvihQWKb4ExO/nuhaRvimyvwXD7ylBOFs1KSziw8OeHPwVv5frWkT65riwT42zcF1MEM7VRAoLlYZ7qv/BpJPeJXzYMyWSmvOH4TzNpHADqchaXnKtTP8SvWnpxRm6SeFh5Ictdey/4HJLwj3LSeFhXPgj5yDsuSUpPJALf+wYhH22JoWHqgn3mi96CIdcuN68ScHsSQpmT1Iwe5KC2ZMUzJ6kYPYkBbOnvwyTvN/Xsk40AAAAAElFTkSuQmCC",
				CLEAR: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAIIAAABaCAYAAAB0bo6/AAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAP3SURBVHhe7dZNkuMqEIXR2v8S3qhHb5vVYdoi8HcR/wLJ5I04kxRkJZhB/fz+/v4YIwWzJymYPUnB7EkKZk9SMHuSgtmTFMyepGD2JAWzJymYPUnB7EkKZk9SME5r2OcxpLChqvz353+nYj//3i1JYQPJHD/0CAjnuBUp3FRpSvb88Ae7WmQenm85KdwQc9Ri3464vfxBVjsJz7uEFG7GXxYv9cki4bmnk8KNuPASvwnC808lhZtw4cV9m0h4D9NI4QZceGnfDOF9TCGFG3DhZX07hHdyOSncgFzSLuwhfJIL2smqxyCFxeRidoTwji4hhYXcoXkpu9r6IfAydjfzMUhhEbkE88+sxyCFBVx4AeafHR6CPyAPbz5940Ng7BEUOO7qSlK4kA8PatKC8E6HkcJF7AF0+KqHwMOZOt/wEORQpp49BOME4f0OIYULyKFMmysfgxQGc+GBTJtHPwQexvR54kNwA/Mgpk8Q3ncXKQziwkOYfo97CDyAGeNJD0GGN+M85SG4cHgzzmMeAgc3YyG8/2ZS6OAG4+BmLIS/QTMpdJChzXhXPIIXKXSQoc14t38IHNhcwx6CcW7/EF6TcWgznj0E49hDMI49BOM84SHYP4wTPOIhvKbj4GYsewjGu+IxSKGTDG3GQ/gbNJFCJxn66Y5zheGaFRD+DtWk0EkGnim8GH5rkQrXroDwt6gihU4y7Exh+K1WEJ7RnXPE3xghM2cxKfTgkLOF4bdaQeScbz7cO1MQzldFCh1kyNnC8FuNIDwj+bDHTIWzJkmhgww4W5CuedCnhAv7zFI5a5QUOsiAOblwfc47zfOgT9irhAt7zdAwq5BCBxkwJRLf5wj3pARpmifTq5QL+12tcdYPUugkQxLC/b7PK9ybEuvJNaVivSq4sOeVOmb1pNDJh8MGAx/h3o8+3JvDnvxeqnC+FBf2LdWyv3NeRwqD5ML1so+HTQnie3FNqVivjNOwd4kgxWc41veQwkCxcA25NTxozll/ritx1uuED/u0aO33DmerIoWF3GF4yJwgH724rtRJvxgX7u8Rht9S3uF8VaSwSPXhgwvgJTT1yvSM6fo7FIbfUoJwvipSWKTqApCmHjGRnimyv1UYfssJwvmqSGGR4ktA/H6uaxHpmyL7WzD8nhKEs1WTwiI+POzJwV/xe7muRaRvjgv71DgL18UE4VxNpLBQabin+h9MOuldwoc9UyKpOX8YztNMCjeQiqzlJdfK9C/Rm5ZenKGbFB5GfthSx/4LLrck3LOcFB7GhT9yDsKeW5LCA7nwx45B2GdrUniomnCv+aKHcMiF682bFMyepGD2JAWzJymYPUnB7EkKZk9SMHv6C25nyUVj7iuQAAAAAElFTkSuQmCC"
			};

			return {
				url: bearMarkerImages[normalizedRisk] || bearMarkerImages.DANGER,
				scaledSize: new google.maps.Size(42, 35),
				anchor: new google.maps.Point(21, 29)
			};
		}

		function createMarkerInfoContent(sighting) {
			const contextPath = document.body.dataset.contextPath || "";
			const targetId = Number(sighting.targetId);
			const riskLabel = normalizeRisk(sighting.displayRisk, sighting.clearYn);
			const detailLink = Number.isInteger(targetId)
				? '<a href="' + contextPath + '/board/detail?boardId=' + encodeURIComponent(targetId) + '" ' +
					'style="display:inline-block; margin-top:9px; color:#1f1f1f; font-size:12px; font-weight:700;">' +
					'詳細を見る <i class="bi bi-arrow-right"></i></a>'
				: '';

			return '<div style="max-width:240px; padding:4px;">' +
				'<strong style="display:block; margin-bottom:6px;">' + escapeHtml(sighting.title || "クマ目撃情報") + '</strong>' +
				'<div style="font-size:12px; color:#6b6355;">危険度: ' + escapeHtml(riskLabel) + '</div>' +
				'<div style="font-size:12px; color:#6b6355; margin-top:3px;">' + escapeHtml(sighting.address || "住所情報なし") + '</div>' +
				detailLink +
				'</div>';
		}

		function normalizeRisk(displayRisk, clearYn) {
			if (String(clearYn || "").toUpperCase() === "Y") return "CLEAR";
			const risk = String(displayRisk || "").toUpperCase();
			if (risk === "DANGER") return "DANGER";
			if (risk === "WARNING") return "WARNING";
			if (risk === "CLEAR") return "CLEAR";
			return "CAUTION";
		}

		function updateRiskCounts(riskCounts) {
			document.getElementById("dangerCount").textContent = riskCounts.DANGER + "件";
			document.getElementById("warningCount").textContent = riskCounts.WARNING + "件";
			document.getElementById("cautionCount").textContent = riskCounts.CAUTION + "件";
			document.getElementById("clearCount").textContent = riskCounts.CLEAR + "件";
		}

		function escapeHtml(value) {
			const element = document.createElement("div");
			element.textContent = String(value);
			return element.innerHTML;
		}

		// 3. 지역 검색 버튼 기능 (Geocoding)
		function searchArea() {
			const address = document.getElementById("areaSearchInput").value.trim();
			applyMapFilters();
			if (!address) {
				return;
			}

			geocoder.geocode({
				address : address
			}, function(results, status) {
				if (status === "OK") {
					map.setCenter(results[0].geometry.location);
					map.setZoom(11);
				} else {
					alert("該当する地域が見つかりませんでした。");
				}
			});
		}

		// 엔터키 입력 시 지역 검색 실행
		document.getElementById("areaSearchInput").addEventListener("keypress",
				function(e) {
					if (e.key === 'Enter') {
						searchArea();
					}
				});

		document.querySelectorAll("#riskDanger, #riskWarning, #riskCaution, #riskClear, #periodSelect")
			.forEach(function(filterInput) {
				filterInput.addEventListener("change", applyMapFilters);
			});

		// 4. 로그인 판별 후 제보 페이지 이동
		function checkLoginAndReport() {
			const isLogin = document.body.dataset.isLogin === "true";
			const contextPath = document.body.dataset.contextPath;

			if (!isLogin) {
				alert("目撃情報の報告機能は、ログイン後に利用できます。");
				location.href = contextPath + "/login";
			} else {
				location.href = contextPath + "/board/report";
			}
		}
	</script>
	<script async
        src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}&loading=async&callback=initMap&libraries=places"></script>
</body>
</html>
