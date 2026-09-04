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
				onclick="filterNews('出没情報', this)">出没情報</button>
			<button type="button"
				class="btn btn-jp-outline btn-sm px-3 filter-btn"
				onclick="filterNews('安全対策', this)">安全対策</button>
			<button type="button"
				class="btn btn-jp-outline btn-sm px-3 filter-btn"
				onclick="filterNews('自治体のお知らせ', this)">自治体のお知らせ</button>
		</div>

		<!-- [메인 헤드라인 뉴스] -->
		<div class="card card-jp mb-5 news-main-card">
			<div class="row g-0 align-items-center">
				<div class="col-lg-7">
					<div class="position-relative">
						<img
							src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=900"
							class="img-fluid rounded-start w-100"
							style="height: 340px; object-fit: cover;" alt="緊急ニュース"> <span
							class="badge badge-danger-custom position-absolute top-0 start-0 m-3 fs-6">
							<i class="bi bi-exclamation-triangle-fill"></i> 緊急速報
						</span>
					</div>
				</div>
				<div class="col-lg-5">
					<div class="card-body p-4">
						<div class="d-flex align-items-center gap-2 mb-2 text-muted small">
							<span class="badge bg-secondary">北海道庁 発表</span> <span><i
								class="bi bi-clock-fill"></i> 2026-09-02</span>
						</div>
						<h4 class="card-title fw-bold mb-3" style="line-height: 1.4;">
							秋のヒグマ注意強調期間における入山・登山の警戒推奨について</h4>
						<p class="card-text text-muted small mb-4"
							style="line-height: 1.7;">
							冬眠前のクマの活動が活発化することに伴い、北海道全域で目撃情報が増加しています。登山の際は必ず熊鈴やスプレーを携帯してください。
						</p>
						<a href="/board/detail" class="btn btn-jp-mustard btn-sm">
							記事全文を読む → </a>
					</div>
				</div>
			</div>
		</div>

		<!-- [뉴스 카드 그리드] -->
		<h5 class="fw-bold mb-3">
			<i class="bi bi-newspaper"></i> 最新の報道・アナウンス一覧
		</h5>

		<div class="row g-4">

			<!-- 카드 1 -->
			<div class="col-md-6 col-lg-4">
				<div class="card h-100 report-card">
					<img
						src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600"
						class="card-img-top" alt="クマ出没ニュース">

					<div class="card-body d-flex flex-column">
						<div
							class="d-flex justify-content-between align-items-center mb-2">
							<span class="badge badge-danger-custom">出没情報</span> <small
								class="text-muted"><i class="bi bi-building"></i> 札幌市</small>
						</div>

						<h5 class="card-title fw-bold">北海道でクマの目撃情報が相次ぐ</h5>

						<p class="mb-2 text-muted small">
							<i class="bi bi-clock-fill"></i> 2026-09-01
						</p>

						<p class="small text-muted flex-grow-1">
							札幌市近郊の登山道周辺で成獣のクマが目撃されました。外出の際は十分ご注意ください。</p>

						<a href="/board/detail" class="btn btn-jp-outline btn-sm mt-3">
							詳細を見る </a>
					</div>
				</div>
			</div>

			<!-- 카드 2 -->
			<div class="col-md-6 col-lg-4">
				<div class="card h-100 report-card">
					<img
						src="https://images.unsplash.com/photo-1465311440653-ba9b1d9b5f04?w=600"
						class="card-img-top" alt="安全対策ニュース">

					<div class="card-body d-flex flex-column">
						<div
							class="d-flex justify-content-between align-items-center mb-2">
							<span class="badge badge-warning-custom">安全対策</span> <small
								class="text-muted"><i class="bi bi-shield-check"></i>
								環境省</small>
						</div>

						<h5 class="card-title fw-bold">秋の登山シーズンに向けた安全対策</h5>

						<p class="mb-2 text-muted small">
							<i class="bi bi-clock-fill"></i> 2026-08-30
						</p>

						<p class="small text-muted flex-grow-1">
							入山前に出没マップを確認し、音の出る熊鈴やクマスプレーなどの装備を準備しましょう。</p>

						<a href="/board/detail" class="btn btn-jp-outline btn-sm mt-3">
							詳細を見る </a>
					</div>
				</div>
			</div>

			<!-- 카드 3 -->
			<div class="col-md-6 col-lg-4">
				<div class="card h-100 report-card">
					<img
						src="https://images.unsplash.com/photo-1500534623283-312aade485b2?w=600"
						class="card-img-top" alt="自治体お知らせ">

					<div class="card-body d-flex flex-column">
						<div
							class="d-flex justify-content-between align-items-center mb-2">
							<span class="badge badge-caution-custom">自治体のお知らせ</span> <small
								class="text-muted"><i class="bi bi-building"></i> 青森県</small>
						</div>

						<h5 class="card-title fw-bold">農地周辺でのクマ出没に伴う注意喚起</h5>

						<p class="mb-2 text-muted small">
							<i class="bi bi-clock-fill"></i> 2026-08-28
						</p>

						<p class="small text-muted flex-grow-1">
							農地周辺でクマの足跡および痕跡が発見されました。自治体では電気柵の設置や注意を呼びかけています。</p>

						<a href="/board/detail" class="btn btn-jp-outline btn-sm mt-3">
							詳細を見る </a>
					</div>
				</div>
			</div>

		</div>

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

	    // 2. 카드 필터링 (카드 내 뱃지 텍스트 기준)
	    const cards = document.querySelectorAll('.report-card');
	    cards.forEach(card => {
	        const badgeText = card.querySelector('.badge').innerText.trim();
	        const parentCol = card.closest('.col-md-6'); // 카드를 감싸는 컬럼

	        if (category === 'all' || badgeText === category) {
	            parentCol.style.display = 'block';
	        } else {
	            parentCol.style.display = 'none';
	        }
	    });
	}
	</script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>