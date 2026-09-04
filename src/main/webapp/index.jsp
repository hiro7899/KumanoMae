<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
	href="${pageContext.request.contextPath}/resources/css/index.css">

</head>

<%-- body 태그에 세션 로그인 여부(true/false)와 ContextPath를 속성값으로 심어둠 --%>
<c:set var="isLogin" value="false" />
<c:if test="${not empty sessionScope.loginUser or not empty sessionScope.user or not empty sessionScope.loginMember or not empty sessionScope.member}">
	<c:set var="isLogin" value="true" />
</c:if>

<body data-is-login="${isLogin}" data-context-path="${pageContext.request.contextPath}">

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
							<p class="mb-1 fw-bold">
								<span class="legend-dot danger"></span>危険（DANGER）
							</p>
							<small class="text-muted d-block ps-3">姿を目撃・撮影</small>
						</div>

						<div class="mb-3">
							<p class="mb-1 fw-bold">
								<span class="legend-dot warning"></span>警戒（WARNING）
							</p>
							<small class="text-muted d-block ps-3">足跡・痕跡を発見</small>
						</div>

						<div>
							<p class="mb-1 fw-bold">
								<span class="legend-dot caution"></span>注意（CAUTION）
							</p>
							<small class="text-muted d-block ps-3">鳴き声・気配を感知</small>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="filter-box mt-4">
			<div class="row g-3 align-items-end">
				<div class="col-md-4">
					<label class="form-label fw-bold d-block">危険度</label>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="checkbox" id="riskDanger"
							checked> <label class="form-check-label" for="riskDanger">危険</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="checkbox" id="riskWarning"
							checked> <label class="form-check-label"
							for="riskWarning">警戒</label>
					</div>
					<div class="form-check form-check-inline">
						<input class="form-check-input" type="checkbox" id="riskCaution"
							checked> <label class="form-check-label"
							for="riskCaution">注意</label>
					</div>
				</div>
				<div class="col-md-3">
					<label for="periodSelect" class="form-label fw-bold">期間</label> <select
						class="form-select" id="periodSelect">
						<option selected>全期間</option>
						<option>1週間</option>
						<option>1ヶ月</option>
						<option>3ヶ月</option>
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

	<%-- ===================== 最近の目撃情報 ===================== --%>
	<section class="container my-5">
		<h3 class="section-title-jp">
			<span class="dash">―</span>最近の目撃情報
		</h3>
		<div class="row g-4">

			<div class="col-md-4 col-sm-6">
				<div class="card h-100 report-card">
					<img
						src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600"
						class="card-img-top" alt="クマ出没イメージ">
					<div class="card-body d-flex flex-column">
						<span class="badge badge-danger-custom mb-2 align-self-start">危険</span>
						<h5 class="card-title">札幌近郊の登山道でクマを発見</h5>
						<p class="mb-1 text-muted small">
							<i class="bi bi-geo-alt-fill"></i> 北海道札幌市
						</p>
						<p class="mb-2 text-muted small">
							<i class="bi bi-clock-fill"></i> 2026-08-20 07:30
						</p>
						<p class="small flex-grow-1">登山道入口付近で成獣のクマ1頭を発見、登山客は避難済みです。</p>
						<a href="${pageContext.request.contextPath}/board/detail"
							class="btn btn-jp-outline btn-sm mt-2">詳細を見る</a>
					</div>
				</div>
			</div>

			<div class="col-md-4 col-sm-6">
				<div class="card h-100 report-card">
					<img
						src="https://images.unsplash.com/photo-1465311440653-ba9b1d9b5f04?w=600"
						class="card-img-top" alt="クマ出没イメージ">
					<div class="card-body d-flex flex-column">
						<span class="badge badge-warning-custom mb-2 align-self-start">警戒</span>
						<h5 class="card-title">農地周辺でクマの足跡を発見</h5>
						<p class="mb-1 text-muted small">
							<i class="bi bi-geo-alt-fill"></i> 青森県
						</p>
						<p class="mb-2 text-muted small">
							<i class="bi bi-clock-fill"></i> 2026-08-19 18:10
						</p>
						<p class="small flex-grow-1">農地付近でクマの足跡と糞の痕跡を発見しました。</p>
						<a href="${pageContext.request.contextPath}/board/detail"
							class="btn btn-jp-outline btn-sm mt-2">詳細を見る</a>
					</div>
				</div>
			</div>

			<div class="col-md-4 col-sm-6">
				<div class="card h-100 report-card">
					<img
						src="https://images.unsplash.com/photo-1500534623283-312aade485b2?w=600"
						class="card-img-top" alt="クマ出没イメージ">
					<div class="card-body d-flex flex-column">
						<span class="badge badge-caution-custom mb-2 align-self-start">注意</span>
						<h5 class="card-title">登山道でクマの鳴き声を確認</h5>
						<p class="mb-1 text-muted small">
							<i class="bi bi-geo-alt-fill"></i> 岩手県
						</p>
						<p class="mb-2 text-muted small">
							<i class="bi bi-clock-fill"></i> 2026-08-18 06:45
						</p>
						<p class="small flex-grow-1">登山者がクマと思われる鳴き声を聞いたと報告しています。</p>
						<a href="${pageContext.request.contextPath}/board/detail"
							class="btn btn-jp-outline btn-sm mt-2">詳細を見る</a>
					</div>
				</div>
			</div>

		</div>
		<div class="text-center mt-4">
			<a href="${pageContext.request.contextPath}/board/news"
				class="btn btn-jp-mustard">目撃情報掲示板をすべて見る</a>
		</div>
	</section>

	<%-- ===================== 安全に関するご案内 ===================== --%>
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
	</section>

	<%-- ===================== 제보하기 플로팅 버튼 ===================== --%>
	<button type="button" class="btn btn-jp-mustard report-float-btn"
		onclick="checkLoginAndReport()">
		<i class="bi bi-exclamation-triangle-fill"></i> クマ出没を報告する
	</button>

	<%-- ===================== Footer ===================== --%>
	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>

	<!-- Bootstrap 5 JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/index.js"></script>

	<!-- Google Map 및 관련 로직 -->
	<script>
		let map;
		let geocoder;

		// 1. Google Map 초기화 함수 (콜백 함수)
		function initMap() {
			// 기본 위치: 홋카이도/일본 중심부 부근
			const defaultCenter = { lat: 43.0621, lng: 141.3544 };

			map = new google.maps.Map(document.getElementById("mapContainer"), {
				zoom: 7,
				center: defaultCenter,
			});

			geocoder = new google.maps.Geocoder();
		}

		// 2. 지역 검색 버튼 기능 (Geocoding)
		function searchArea() {
			const address = document.getElementById("areaSearchInput").value;
			if (!address) {
				alert("検索する地域を入力してください。");
				return;
			}

			geocoder.geocode({ address: address }, function (results, status) {
				if (status === "OK") {
					map.setCenter(results[0].geometry.location);
					map.setZoom(11);
				} else {
					alert("該当する地域が見つかりませんでした。");
				}
			});
		}

		// 엔터키 입력 시 지역 검색 실행
		document.getElementById("areaSearchInput").addEventListener("keypress", function(e) {
			if (e.key === 'Enter') {
				searchArea();
			}
		});

		// 3. 로그인 판별 후 제보 페이지 이동
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
