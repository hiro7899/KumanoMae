<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>最新ニュース - KUMANO_MAE</title>

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
<link rel="stylesheet" href="/resources/css/main.css">
<link rel="stylesheet" href="/resources/css/index.css">

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
				<div class="row g-4" id="newsCardGrid">
					<c:forEach var="news" items="${newsList}" begin="1">
						<div class="col-md-6 col-lg-4 news-card-column" data-category="${news.sourceType}">
							<article class="card h-100 report-card">
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
									<a href="${news.sourceUrl}" target="_blank" rel="noopener noreferrer"
										class="btn btn-jp-outline btn-sm mt-3">原文を見る <i class="bi bi-box-arrow-up-right"></i></a>
								</div>
							</article>
						</div>
					</c:forEach>
				</div>
			</c:when>
			<c:otherwise>
				<div class="card card-jp border-0 py-5 text-center">
					<div class="card-body text-muted">
						<i class="bi bi-newspaper fs-1 d-block mb-3"></i>
						<p class="fw-bold mb-1">現在表示できるニュースはありません。</p>
						<small>新しいニュースが取得されると、こちらに表示されます。</small>
					</div>
				</div>
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
	}
	</script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
