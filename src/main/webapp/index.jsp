<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>熊の前 - KUMANO_MAE</title>

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
	href="${pageContext.request.contextPath}/resources/css/index.css?v=home-sections-3">

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
	<div id="splashScreen" class="splash-screen"
		aria-label="Kumano Mae 시작 화면">
		<img
			src="${pageContext.request.contextPath}/resources/img/brand/kumano-mae-splash.png"
			alt="Kumano Mae" class="splash-screen-image">
	</div>

	<%-- ===================== 상단 경보 배너 ===================== --%>
	<div class="top-alert">
		<span id="seasonAlertIcon" aria-hidden="true">🍂</span> <span
			id="seasonAlertText">秋の入山特別警戒期間（9月〜11月）— 冬眠前のクマの活動が活発化しています。</span> <span
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
						<button type="button" id="reportSightingButton"
							class="btn btn-jp-outline btn-lg">目撃情報を報告する</button>
					</div>
					<p class="hero-credit">
						提供元：自治体オープンデータ・警察発表・住民報告を統合<br> ※本サイトはポートフォリオ制作用のデモです
					</p>
				</div>

				<!-- 경고 다이아몬드 사인 -->
				<div class="col-md-5 mt-5 mt-md-0">
					<div class="warning-sign-wrap">
						<svg class="hero-bear-silhouette" viewBox="0 0 248.662 248.662"
							aria-hidden="true">
							<path
								d="M248.343 175.365c-1.779-5.671-9.99-13.958-8.992-25.03.998-11.068 9.798-36.354 7.514-47.147s-13.737-42.525-43.349-47.324c-29.599-4.797-50.858 3.166-62.211 2.655-11.345-.513-13.409-9.091-25.95-8.98-16.188.15-18.975 6.869-30.42 10.473-8.392 2.645-34.676 2.613-34.676 2.613s-7.52-9.812-9.812-6.217c-2.292 3.597-5.236 12.757-5.236 12.757s-14.068 4.905-15.371 7.528c-1.304 2.623-3.094 6.876-3.094 6.876S1.847 87.486.213 91.083c-1.633 3.595 6.546 12.096 9.161 15.048 2.615 2.951 33.035 3.597 37.856 7.149 4.819 3.557 18.315 6.226 25.852 7.52 14.145 2.435 20.362 30.533 23.957 61.61-4.254 3.603-11.776 6.793-12.183 16.715h46.114s.613-6.624 1.395-14.827c.77-8.203 14.719-39.253 14.719-39.253s10.135 7.851 17.008 8.188c-.646 6.211 2.252 12.819 2.252 12.819s5.936 7.129 11.706 12.771c-10.563 4.356-10.255 12.039-10.255 12.039l39.145.304s3.923-8.171 3.923-14.719c5.246 7.53 15.381 10.472 15.381 10.472l-6.304 12.206h23.92c-.085 0 6.163-18.086 4.383-23.752zM28.482 85.278a3.107 3.107 0 1 1 0-6.216 3.107 3.107 0 0 1 0 6.216z" />
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
						<div class="map-container-wrap">
							<div id="mapContainer" style="height: 480px; width: 100%;"></div>
							<div id="mapStatus" class="map-status" role="status"
								aria-live="polite" hidden></div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-lg-3">
				<div class="card card-jp h-100">
					<div class="card-body map-legend">
						<h6 class="fw-bold mb-3">危険度の凡例</h6>

						<div class="mb-3">
							<p class="mb-1 fw-bold map-legend-title">
								<span><img class="legend-bear" data-risk="DANGER" alt="">危険（DANGER）</span>
								<span id="dangerCount" class="map-risk-count danger">0件</span>
							</p>
							<small class="text-muted d-block map-legend-description">姿を目撃・撮影</small>
						</div>

						<div class="mb-3">
							<p class="mb-1 fw-bold map-legend-title">
								<span><img class="legend-bear" data-risk="WARNING" alt="">警戒（WARNING）</span>
								<span id="warningCount" class="map-risk-count warning">0件</span>
							</p>
							<small class="text-muted d-block map-legend-description">足跡・痕跡を発見</small>
						</div>

						<div>
							<p class="mb-1 fw-bold map-legend-title">
								<span><img class="legend-bear" data-risk="CAUTION" alt="">注意（CAUTION）</span>
								<span id="cautionCount" class="map-risk-count caution">0件</span>
							</p>
							<small class="text-muted d-block map-legend-description">鳴き声・気配を感知</small>
						</div>

						<div>
							<p class="mb-1 fw-bold map-legend-title">
								<span><img class="legend-bear" data-risk="CLEAR" alt="">解除（CLEAR）</span>
								<span id="clearCount" class="map-risk-count clear">0件</span>
							</p>
							<small class="text-muted d-block map-legend-description">危険解除済み</small>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="filter-box mt-4">
			<div class="row g-3 align-items-end">
				<div class="col-md-5">
					<label class="form-label fw-bold d-block">危険度</label>
					<div class="risk-filter-group">
						<div class="form-check form-check-inline risk-filter all">
							<input class="form-check-input" type="radio" name="riskFilter"
								id="riskAll" checked> <label class="form-check-label"
								for="riskAll">すべて</label>
						</div>
						<div class="form-check form-check-inline risk-filter danger">
							<input class="form-check-input" type="radio" name="riskFilter"
								id="riskDanger"> <label class="form-check-label"
								for="riskDanger">危険</label>
						</div>
						<div class="form-check form-check-inline risk-filter warning">
							<input class="form-check-input" type="radio" name="riskFilter"
								id="riskWarning"> <label class="form-check-label"
								for="riskWarning">警戒</label>
						</div>
						<div class="form-check form-check-inline risk-filter caution">
							<input class="form-check-input" type="radio" name="riskFilter"
								id="riskCaution"> <label class="form-check-label"
								for="riskCaution">注意</label>
						</div>
						<div class="form-check form-check-inline risk-filter clear">
							<input class="form-check-input" type="radio" name="riskFilter"
								id="riskClear"> <label class="form-check-label"
								for="riskClear">解除</label>
						</div>
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
				<div class="col-md-4">
					<label for="areaSearchInput" class="form-label fw-bold">地域検索</label>
					<div class="input-group">
						<input type="text" class="form-control" id="areaSearchInput"
							placeholder="例：札幌市、富山県">
						<button class="btn btn-jp-mustard" type="button"
							id="areaSearchBtn">
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
		<div id="homeNewsCardGrid" class="row g-4"></div>
		<div class="text-center mt-4">
			<a href="${pageContext.request.contextPath}/board/news"
				class="btn btn-jp-mustard">ニュースをすべて見る</a>
		</div>
	</section>

	<%-- ===================== 목격 제보 섹션 ===================== --%>
	<section
		class="container my-5 home-preview-section home-report-section">
		<div class="section-heading-row">
			<h3 class="section-title-jp mb-0">
				<span class="dash">―</span>最新の目撃情報
			</h3>
		</div>
		<div class="row g-4">
			<c:forEach var="board" items="${boardList}" end="2">
				<c:if test="${board.clearYn ne 'Y'}">
					<div class="col-md-4 col-sm-6">
						<article
							class="card h-100 report-card preview-card clickable-card"
							data-card-href="${pageContext.request.contextPath}/board/detail?boardId=${board.boardId}">
							<c:set var="boardFallbackClass" value="preview-card-image-safe" />
							<c:if test="${board.riskLevel eq 'DANGER'}"><c:set var="boardFallbackClass" value="preview-card-image-danger" /></c:if>
							<c:if test="${board.riskLevel eq 'WARNING'}"><c:set var="boardFallbackClass" value="preview-card-image-caution" /></c:if>
							<c:choose>
								<c:when test="${not empty board.thumbnailUrl}">
									<c:url var="boardThumbnailUrl"
										value="${fn:replace(board.thumbnailUrl, '/src/main/webapp', '')}" />
								<div class="preview-card-image" data-fallback-class="${boardFallbackClass}">
									<img src="${boardThumbnailUrl}" class="preview-card-thumb"
										alt="目撃情報画像"
										onerror="this.onerror=null;var box=this.closest('.preview-card-image');this.remove();box.classList.add('preview-card-image-fallback', box.dataset.fallbackClass);box.innerHTML='<i class=&quot;bi bi-image-alt&quot;></i>';">
								</div>
								</c:when>
								<c:otherwise>
									<c:choose>
										<c:when test="${board.riskLevel eq 'DANGER'}">
											<div class="preview-card-image preview-card-image-danger">
												<i class="bi bi-exclamation-triangle-fill"></i>
											</div>
										</c:when>
										<c:when test="${board.riskLevel eq 'WARNING'}">
											<div class="preview-card-image preview-card-image-caution">
												<i class="bi bi-signpost-split-fill"></i>
											</div>
										</c:when>
										<c:otherwise>
											<div class="preview-card-image preview-card-image-safe">
												<i class="bi bi-shield-check"></i>
											</div>
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
							<div class="card-body d-flex flex-column">
								<c:choose>
									<c:when test="${board.riskLevel eq 'DANGER'}">
										<span class="badge badge-danger-custom mb-2 align-self-start">危険</span>
									</c:when>
									<c:when test="${board.riskLevel eq 'WARNING'}">
										<span class="badge badge-warning-custom mb-2 align-self-start">警戒</span>
									</c:when>
									<c:otherwise>
										<span class="badge badge-caution-custom mb-2 align-self-start">注意</span>
									</c:otherwise>
								</c:choose>
								<h5 class="card-title">
									<c:out value="${board.title}" />
								</h5>
								<p class="mb-2 text-muted small">
									<i class="bi bi-geo-alt"></i>
									<c:out value="${board.address}" />
									<span class="ms-2"><i class="bi bi-clock"></i>
										${fn:substring(fn:replace(board.sightingDate, 'T', ' '), 0, 16)}</span>
								</p>
								<p class="small flex-grow-1">
									<c:out value="${board.content}" />
								</p>
							</div>
						</article>
					</div>
				</c:if>
			</c:forEach>
			<c:if test="${empty boardList}">
				<div class="col-12">
					<div class="card card-jp border-0 py-4 text-center">
						<div class="card-body text-muted">
							<i class="bi bi-geo-alt fs-1 d-block mb-2"></i>
							<p class="fw-bold mb-0">現在表示できる目撃情報はありません。</p>
						</div>
					</div>
				</div>
			</c:if>
		</div>
		<div class="text-center mt-4">
			<a href="${pageContext.request.contextPath}/board/list"
				class="btn btn-jp-mustard">目撃情報をすべて見る</a>
		</div>
	</section>

	<%-- ===================== 커뮤니티 섹션 ===================== --%>
	<section
		class="container my-5 home-preview-section home-community-section">
		<div class="section-heading-row">
			<h3 class="section-title-jp mb-0">
				<span class="dash">―</span>コミュニティの最新投稿
			</h3>
		</div>
		<div class="row g-4">
			<c:forEach var="community" items="${communityList}" end="2">
				<div class="col-md-4 col-sm-6">
					<article class="card h-100 report-card preview-card clickable-card"
						data-card-href="${pageContext.request.contextPath}/community/detail?cBoardId=${community.cBoardId}">
						<c:set var="communityFallbackClass" value="preview-card-image-talk" />
						<c:if test="${community.category eq 'GEAR'}"><c:set var="communityFallbackClass" value="preview-card-image-gear" /></c:if>
						<c:if test="${community.category eq 'REVIEW'}"><c:set var="communityFallbackClass" value="preview-card-image-trail" /></c:if>
						<c:choose>
							<c:when test="${not empty community.thumbnailUrl}">
								<c:url var="communityThumbnailUrl"
									value="${fn:replace(community.thumbnailUrl, '/src/main/webapp', '')}" />
								<div class="preview-card-image" data-fallback-class="${communityFallbackClass}">
									<img src="${communityThumbnailUrl}" class="preview-card-thumb"
										alt="コミュニティ投稿画像"
										onerror="this.onerror=null;var box=this.closest('.preview-card-image');this.remove();box.classList.add('preview-card-image-fallback', box.dataset.fallbackClass);box.innerHTML='<i class=&quot;bi bi-image-alt&quot;></i>';">
								</div>
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${community.category eq 'GEAR'}">
										<div class="preview-card-image preview-card-image-gear">
											<i class="bi bi-backpack-fill"></i>
										</div>
									</c:when>
									<c:when test="${community.category eq 'REVIEW'}">
										<div class="preview-card-image preview-card-image-trail">
											<i class="bi bi-map-fill"></i>
										</div>
									</c:when>
									<c:otherwise>
										<div class="preview-card-image preview-card-image-talk">
											<i class="bi bi-people-fill"></i>
										</div>
									</c:otherwise>
								</c:choose>
							</c:otherwise>
						</c:choose>
						<div class="card-body d-flex flex-column">
							<c:choose>
								<c:when test="${community.category eq 'GEAR'}">
									<span class="badge badge-caution-custom mb-2 align-self-start">ギア</span>
								</c:when>
								<c:when test="${community.category eq 'REVIEW'}">
									<span class="badge badge-warning-custom mb-2 align-self-start">レビュー</span>
								</c:when>
								<c:otherwise>
									<span class="badge badge-danger-custom mb-2 align-self-start">自由掲示板</span>
								</c:otherwise>
							</c:choose>
							<h5 class="card-title">
								<c:out value="${community.title}" />
							</h5>
							<p class="mb-2 text-muted small">
								<i class="bi bi-person-circle"></i>
								<c:out value="${community.writerName}" />
								<span class="ms-2"><i class="bi bi-clock"></i>
									${fn:substring(fn:replace(community.regDate, 'T', ' '), 0, 16)}</span>
							</p>
							<p class="small flex-grow-1">
								<i class="bi bi-heart"></i> ${community.likeCnt} <span
									class="ms-2"><i class="bi bi-chat-square-text"></i>
									${community.commentCnt}</span>
							</p>
						</div>
					</article>
				</div>
			</c:forEach>
			<c:if test="${empty communityList}">
				<div class="col-12">
					<div class="card card-jp border-0 py-4 text-center">
						<div class="card-body text-muted">
							<i class="bi bi-chat-square-dots fs-1 d-block mb-2"></i>
							<p class="fw-bold mb-0">まだコミュニティ投稿がありません。</p>
						</div>
					</div>
				</div>
			</c:if>
		</div>
		<div class="text-center mt-4">
			<a href="${pageContext.request.contextPath}/community/list"
				class="btn btn-jp-mustard">コミュニティをすべて見る</a>
		</div>
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
							<span id="seasonGuideIcon" class="me-2" aria-hidden="true">🍂</span>
							<span id="seasonGuideTitle">今月の注意ポイント</span>
						</h5>
						<p id="seasonGuideText" class="text-muted">冬眠前のクマは餌を求めて活動範囲を広げます。早朝・夕方の入山は特に注意し、食べ物やゴミを屋外に放置しないでください。</p>
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
							<a href="tel:110" class="btn btn-danger fw-bold"> <i
								class="bi bi-telephone-fill me-2"></i>緊急の危険：警察 110
							</a> <a href="tel:119" class="btn btn-jp-outline fw-bold"> <i
								class="bi bi-heart-pulse-fill me-2"></i>けが人：消防・救急 119
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

	<%-- ===================== Footer ===================== --%>
	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>


	<!-- Bootstrap 5 JS -->
	
	<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script src="/resources/js/board/news-data.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/index.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function () {
	var grid = document.getElementById('homeNewsCardGrid');
	var latestNews = HARD_CODED_NEWS.slice().sort(function (a, b) {
		return new Date(b.date) - new Date(a.date);
	}).slice(0, 3);

	function label(category) {
		return category === 'SAFETY' ? '安全対策' : category === 'OFFICIAL' ? '自治体のお知らせ' : '出没情報';
	}

	function badgeClass(category) {
		return category === 'SAFETY' ? 'badge-warning-custom' : category === 'OFFICIAL' ? 'badge-caution-custom' : 'badge-danger-custom';
	}

	grid.innerHTML = latestNews.map(function (news) {
		return '<div class="col-md-4 col-sm-6"><article class="card h-100 report-card preview-card clickable-card" data-card-href="/board/news/detail?newsId=' + news.id + '" tabindex="0" role="link">'
			+ '<div class="preview-card-image"><img src="' + newsImage(news) + '" class="preview-card-thumb" alt="' + newsEscape(news.title) + '" onerror="this.onerror=null;this.src=\'/resources/img/brand/kumano-mae-splash.png\';"></div>'
			+ '<div class="card-body d-flex flex-column"><span class="badge ' + badgeClass(news.category) + ' mb-2 align-self-start">' + label(news.category) + '</span>'
			+ '<h5 class="card-title">' + newsEscape(news.title) + '</h5>'
			+ '<p class="mb-2 text-muted small"><i class="bi bi-building"></i> ' + newsEscape(news.source) + ' <span class="ms-2"><i class="bi bi-clock-fill"></i> ' + news.date + '</span></p>'
			+ '<p class="small flex-grow-1">' + newsEscape(news.summary) + '</p></div></article></div>';
	}).join('');

	grid.querySelectorAll('.clickable-card').forEach(function (card) {
		card.addEventListener('click', function () { location.href = card.dataset.cardHref; });
		card.addEventListener('keydown', function (event) {
			if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); location.href = card.dataset.cardHref; }
		});
	});
});
</script>

	<!-- Google Map 및 관련 로직 -->
	<script async
		src="https://maps.googleapis.com/maps/api/js?key=${googleMapsApiKey}&loading=async&callback=initMap&libraries=places"></script>
</body>
</html>
