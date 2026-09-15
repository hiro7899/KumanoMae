<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>最新ニュース - 熊の前</title>

<!-- Bootstrap 5 CDN & Icons -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- 일본어 폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap"
	rel="stylesheet">

<!-- 전용 CSS -->
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/index.css">

</head>
<body>
	<!-- 공통 헤더 INCLUDE -->
	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<main class="container my-5">

		<!-- 페이지 타이틀 & 설명 -->
		<div class="border-bottom border-2 pb-3 mb-4"
			style="border-color: var(--color-ink) !important;">
			<h2 class="section-title-jp mb-1">
				<span class="dash">―</span>クマ関連ニュース・自治体発表
			</h2>
			<p class="text-muted small mb-0">
				全国の自治体・警察発表・環境省などの公式オープンデータに基づく出没情報および安全ガイドをご案内します。</p>
		</div>

		<!-- 뉴스 카테고리 필터 탭 -->
		<!-- 필터 버튼에 data-filter 속성 및 onclick 추가 -->
		<div class="d-flex gap-2 mb-4 flex-wrap">
			<button type="button"
				class="btn btn-jp-mustard btn-sm px-3 filter-btn active"
				onclick="filterNews('all', this)">すべて</button>
			<button type="button"
				class="btn btn-jp-outline btn-sm px-3 filter-btn"
				onclick="filterNews('SIGHTING', this)">出没情報</button>
			<button type="button"
				class="btn btn-jp-outline btn-sm px-3 filter-btn"
				onclick="filterNews('SAFETY', this)">安全対策</button>
			<button type="button"
				class="btn btn-jp-outline btn-sm px-3 filter-btn"
				onclick="filterNews('OFFICIAL', this)">自治体のお知らせ</button>
		</div>

		<c:choose>
			<c:when test="${not empty newsList}">
				<c:set var="headline" value="${newsList[0]}" />

				<!-- 메인 헤드라인 뉴스 -->
				<div class="card card-jp mb-5 news-main-card" data-category="${headline.sourceType}">
					<div class="row g-0 align-items-center">
						<div class="col-lg-7">
							<div class="position-relative">
								<img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=900"
									class="img-fluid rounded-start w-100"
									style="height: 340px; object-fit: cover;" alt="クマ関連ニュース">
								<span class="badge badge-danger-custom position-absolute top-0 start-0 m-3 fs-6">
									<i class="bi bi-newspaper"></i> 最新ニュース
								</span>
							</div>
						</div>
						<div class="col-lg-5">
							<div class="card-body p-4">
								<div class="d-flex align-items-center gap-2 mb-2 text-muted small">
									<span class="badge bg-secondary"><c:out value="${headline.sourceName}" /></span>
									<span><i class="bi bi-clock-fill"></i> <c:out value="${headline.publishedDate}" /></span>
								</div>
								<h4 class="card-title fw-bold mb-3" style="line-height: 1.4;"><c:out value="${headline.title}" /></h4>
								<p class="card-text text-muted small mb-4" style="line-height: 1.7;"><c:out value="${headline.summary}" /></p>
								<a href="${headline.sourceUrl}" target="_blank" rel="noopener noreferrer"
									class="btn btn-jp-mustard btn-sm">記事全文を読む <i class="bi bi-box-arrow-up-right"></i></a>
							</div>
						</div>
					</div>
				</div>

				<h5 class="fw-bold mb-3"><i class="bi bi-newspaper"></i> 最新の報道・アナウンス一覧</h5>
				<div class="row g-4" id="newsCardGrid" data-pagination data-page-size="6">
					<c:forEach var="news" items="${newsList}" begin="1">
						<div class="col-md-6 col-lg-4 news-card-column" data-category="${news.sourceType}" data-page-item>
							<article class="card h-100 report-card clickable-card" data-card-href="${news.sourceUrl}">
								<img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600"
									class="card-img-top" alt="クマ関連ニュース">
								<div class="card-body d-flex flex-column">
									<div class="d-flex justify-content-between align-items-center gap-2 mb-2">
										<c:choose>
											<c:when test="${news.sourceType eq 'SIGHTING'}"><span class="badge badge-danger-custom">出没情報</span></c:when>
											<c:when test="${news.sourceType eq 'SAFETY'}"><span class="badge badge-warning-custom">安全対策</span></c:when>
											<c:otherwise><span class="badge badge-caution-custom">自治体のお知らせ</span></c:otherwise>
										</c:choose>
										<small class="text-muted"><i class="bi bi-building"></i> <c:out value="${news.sourceName}" /></small>
									</div>
									<h5 class="card-title fw-bold"><c:out value="${news.title}" /></h5>
									<p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> <c:out value="${news.publishedDate}" /></p>
									<p class="small text-muted flex-grow-1"><c:out value="${news.summary}" /></p>
								</div>
							</article>
						</div>
					</c:forEach>
				</div>
				<div class="client-pagination" data-pagination-controls="newsCardGrid" aria-label="ページ移動"></div>
			</c:when>
			<c:otherwise>
				<%-- 임시 프론트 뉴스 데이터: 백엔드 newsList가 준비되면 기존 데이터가 우선 표시됩니다. --%>
				<div class="card card-jp mb-5 news-main-card" data-category="SAFETY">
					<div class="row g-0 align-items-center">
						<div class="col-lg-7"><div class="position-relative"><img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=900" class="img-fluid rounded-start w-100" style="height: 340px; object-fit: cover;" alt="クマ関連ニュース"><span class="badge badge-danger-custom position-absolute top-0 start-0 m-3 fs-6"><i class="bi bi-newspaper"></i> 最新ニュース</span></div></div>
						<div class="col-lg-5"><div class="card-body p-4"><div class="d-flex align-items-center gap-2 mb-2 text-muted small"><span class="badge bg-secondary">福島県</span><span><i class="bi bi-clock-fill"></i> 2026-09-01</span></div><h4 class="card-title fw-bold mb-3" style="line-height: 1.4;">福島県、県内全域に秋期のツキノワグマ出没注意報</h4><p class="card-text text-muted small mb-4" style="line-height: 1.7;">9月1日から11月30日まで、山に入る際の事前確認や複数人での行動を呼びかけています。</p><a href="https://pref.fukushima.lg.jp/sec/16035b/kumatokubetuhaturei.html" target="_blank" rel="noopener noreferrer" class="btn btn-jp-mustard btn-sm">記事全文を読む <i class="bi bi-box-arrow-up-right"></i></a></div></div>
					</div>
				</div>

				<h5 class="fw-bold mb-3"><i class="bi bi-newspaper"></i> 最新の報道・アナウンス一覧</h5>
				<div class="row g-4" id="newsCardGrid" data-pagination data-page-size="6">
					<div class="col-md-6 col-lg-4 news-card-column" data-category="SIGHTING" data-page-item><article class="card h-100 report-card clickable-card" data-card-href="https://newsdig.tbs.co.jp/articles/hbc/2934118"><img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600" class="card-img-top" alt="クマ関連ニュース"><div class="card-body d-flex flex-column"><div class="d-flex justify-content-between align-items-center gap-2 mb-2"><span class="badge badge-danger-custom">出没情報</span><small class="text-muted"><i class="bi bi-building"></i> HBC北海道放送</small></div><h5 class="card-title fw-bold">北海道標茶町で道路上を走るクマ、ドライバーが目撃</h5><p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> 2026-09-10</p><p class="small text-muted flex-grow-1">国道272号で体長約1メートルのクマが道路中央を走り、道路脇の森へ移動しました。</p></div></article></div>
					<div class="col-md-6 col-lg-4 news-card-column" data-category="SIGHTING" data-page-item><article class="card h-100 report-card clickable-card" data-card-href="https://www.city.sapporo.jp/kurashi/animal/choju/kuma/syutsubotsu/?gid=43.06395_141.11040_2026-08-07_48"><img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600" class="card-img-top" alt="クマ関連ニュース"><div class="card-body d-flex flex-column"><div class="d-flex justify-content-between align-items-center gap-2 mb-2"><span class="badge badge-danger-custom">出没情報</span><small class="text-muted"><i class="bi bi-building"></i> 札幌市</small></div><h5 class="card-title fw-bold">札幌市定山渓でヒグマを目撃</h5><p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> 2026-09-09</p><p class="small text-muted flex-grow-1">定山渓周辺でヒグマの目撃情報があり、市が市民に注意を呼びかけています。</p></div></article></div>
					<div class="col-md-6 col-lg-4 news-card-column" data-category="SIGHTING" data-page-item><article class="card h-100 report-card clickable-card" data-card-href="https://www.city.sapporo.jp/kurashi/animal/choju/kuma/syutsubotsu/?gid=43.06395_141.11040_2026-08-07_48"><img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600" class="card-img-top" alt="クマ関連ニュース"><div class="card-body d-flex flex-column"><div class="d-flex justify-content-between align-items-center gap-2 mb-2"><span class="badge badge-danger-custom">出没情報</span><small class="text-muted"><i class="bi bi-building"></i> 札幌市</small></div><h5 class="card-title fw-bold">札幌市西区でヒグマらしき物音を確認</h5><p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> 2026-09-08</p><p class="small text-muted flex-grow-1">西区福井9丁目付近でヒグマらしき動物による物音が確認されました。</p></div></article></div>
					<div class="col-md-6 col-lg-4 news-card-column" data-category="SIGHTING" data-page-item><article class="card h-100 report-card clickable-card" data-card-href="https://www.city.sapporo.jp/kurashi/animal/choju/kuma/syutsubotsu/?gid=43.06395_141.11040_2026-08-07_48"><img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600" class="card-img-top" alt="クマ関連ニュース"><div class="card-body d-flex flex-column"><div class="d-flex justify-content-between align-items-center gap-2 mb-2"><span class="badge badge-danger-custom">出没情報</span><small class="text-muted"><i class="bi bi-building"></i> 札幌市</small></div><h5 class="card-title fw-bold">札幌市南区定山渓でヒグマを目撃</h5><p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> 2026-09-03</p><p class="small text-muted flex-grow-1">国道230号線付近の道路上でヒグマが目撃されました。</p></div></article></div>
					<div class="col-md-6 col-lg-4 news-card-column" data-category="SIGHTING" data-page-item><article class="card h-100 report-card clickable-card" data-card-href="https://newsdig.tbs.co.jp/articles/-/2920255?display=1"><img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600" class="card-img-top" alt="クマ関連ニュース"><div class="card-body d-flex flex-column"><div class="d-flex justify-content-between align-items-center gap-2 mb-2"><span class="badge badge-danger-custom">出没情報</span><small class="text-muted"><i class="bi bi-building"></i> MBSニュース</small></div><h5 class="card-title fw-bold">京都府舞鶴市で子グマ1頭を目撃</h5><p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> 2026-09-04</p><p class="small text-muted flex-grow-1">親子グマが確認された地域で、子グマ1頭の目撃情報があり住民に警戒が呼びかけられました。</p></div></article></div>
					<div class="col-md-6 col-lg-4 news-card-column" data-category="SIGHTING" data-page-item><article class="card h-100 report-card clickable-card" data-card-href="https://www.nbs-tv.co.jp/news/articles/?cid=29856"><img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600" class="card-img-top" alt="クマ関連ニュース"><div class="card-body d-flex flex-column"><div class="d-flex justify-content-between align-items-center gap-2 mb-2"><span class="badge badge-danger-custom">出没情報</span><small class="text-muted"><i class="bi bi-building"></i> 長野放送</small></div><h5 class="card-title fw-bold">長野県でキノコ採り中の男性がクマに襲われ負傷</h5><p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> 2026-09-06</p><p class="small text-muted flex-grow-1">伊那市と軽井沢町でクマによる人身被害が発生し、遭遇を避ける対策が呼びかけられています。</p></div></article></div>
					<div class="col-md-6 col-lg-4 news-card-column" data-category="SIGHTING" data-page-item><article class="card h-100 report-card clickable-card" data-card-href="https://www.youtube.com/watch?v=Fy1rHiqRH9Q"><img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600" class="card-img-top" alt="クマ関連ニュース"><div class="card-body d-flex flex-column"><div class="d-flex justify-content-between align-items-center gap-2 mb-2"><span class="badge badge-danger-custom">出没情報</span><small class="text-muted"><i class="bi bi-building"></i> FNNプライムオンライン</small></div><h5 class="card-title fw-bold">山形県天童市の住宅街でクマ、周辺の学校も警戒</h5><p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> 2026-09-07</p><p class="small text-muted flex-grow-1">住宅街にクマが現れ、付近の小学校が臨時休校となり箱わなが設置されました。</p></div></article></div>
					<div class="col-md-6 col-lg-4 news-card-column" data-category="OFFICIAL" data-page-item><article class="card h-100 report-card clickable-card" data-card-href="https://www.pref.akita.lg.jp/pages/archive/23295"><img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600" class="card-img-top" alt="クマ関連ニュース"><div class="card-body d-flex flex-column"><div class="d-flex justify-content-between align-items-center gap-2 mb-2"><span class="badge badge-caution-custom">自治体のお知らせ</span><small class="text-muted"><i class="bi bi-building"></i> 秋田県</small></div><h5 class="card-title fw-bold">秋田県、秋のクマ事故防止強化期間を開始</h5><p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> 2026-09-15</p><p class="small text-muted flex-grow-1">山地や生活圏での遭遇リスクに備え、10月31日まで事故防止の強化を呼びかけています。</p></div></article></div>
					<div class="col-md-6 col-lg-4 news-card-column" data-category="SAFETY" data-page-item><article class="card h-100 report-card clickable-card" data-card-href="https://www.pref.fukushima.lg.jp/sec/01210a/kuma.html"><img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600" class="card-img-top" alt="クマ関連ニュース"><div class="card-body d-flex flex-column"><div class="d-flex justify-content-between align-items-center gap-2 mb-2"><span class="badge badge-warning-custom">安全対策</span><small class="text-muted"><i class="bi bi-building"></i> 福島県</small></div><h5 class="card-title fw-bold">福島県県北地方、ツキノワグマ出没注意報を発令中</h5><p class="mb-2 text-muted small"><i class="bi bi-clock-fill"></i> 2026-09-02</p><p class="small text-muted flex-grow-1">秋の入山シーズンを前に、目撃情報の確認と地域での情報共有を呼びかけています。</p></div></article></div>
				</div>
				<div class="client-pagination" data-pagination-controls="newsCardGrid" aria-label="ページ移動"></div>
			</c:otherwise>
		</c:choose>
	</main>

	<!-- 공통 푸터 INCLUDE -->
	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>

	<!-- Bootstrap JS -->
	<script>
	// 스크립트에 필터링 함수 추가
	function filterNews(category, btn) {
	    // 1. 버튼 스타일 전환 (선택된 버튼을 머스타드색으로)
	    document.querySelectorAll('.filter-btn').forEach(b => {
	        b.classList.remove('btn-jp-mustard', 'active');
	        b.classList.add('btn-jp-outline');
	    });
	    btn.classList.remove('btn-jp-outline');
	    btn.classList.add('btn-jp-mustard', 'active');

	    // 2. 백엔드에서 전달된 sourceType을 기준으로 카드 필터링
	    const cards = document.querySelectorAll('.news-card-column');
	    cards.forEach(card => {
	        card.style.display = category === 'all' || card.dataset.category === category
	            ? 'block'
	            : 'none';
	    });
	    if (window.refreshNewsPagination) window.refreshNewsPagination();
	}
	</script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
		document.addEventListener("DOMContentLoaded", function () {
			const grid = document.getElementById('newsCardGrid'), controls = document.querySelector('[data-pagination-controls="newsCardGrid"]'), items = Array.from(grid.querySelectorAll('[data-page-item]'));
			function render(page) { const visible = items.filter(i => i.style.display !== 'none'); const total = Math.max(1, Math.ceil(visible.length / 6)); page = Math.min(Math.max(page || 1, 1), total); items.forEach(i => i.classList.add('pagination-hidden')); visible.slice((page - 1) * 6, page * 6).forEach(i => i.classList.remove('pagination-hidden')); controls.innerHTML = ''; for (let i = 1; i <= total; i++) { const b = document.createElement('button'); b.type = 'button'; b.className = 'client-page-button' + (i === page ? ' active' : ''); b.textContent = i; b.onclick = () => render(i); controls.appendChild(b); } }
			window.refreshNewsPagination = () => render(1);
			render(1);
			document.querySelectorAll('.clickable-card[data-card-href]').forEach(card => { card.setAttribute('tabindex', '0'); card.onclick = () => window.location.href = card.dataset.cardHref; card.onkeydown = e => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); window.location.href = card.dataset.cardHref; } }; });
		});
	</script>
</body>
</html>
