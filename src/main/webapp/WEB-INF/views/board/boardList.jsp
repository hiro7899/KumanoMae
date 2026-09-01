<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Community-KUMANO_MAE</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/main.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/index.css">

</head>
<nav class="navbar navbar-expand-lg navbar-jp">
	<div
		class="container d-flex align-items-center justify-content-between">
		<a href="/" class="d-flex align-items-center text-decoration-none">
			<div class="logo-badge me-2">熊</div>
			<div class="brand-jp">
				<div class="jp-title">クマ出没マップ</div>
				<div class="jp-sub">KUMA SHUTSUBOTSU MAP</div>
			</div>
		</a>

		<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
			data-bs-target="#mainNavbar" aria-controls="mainNavbar"
			aria-expanded="false" aria-label="メニューを開く">
			<span class="navbar-toggler-icon"></span>
		</button>

		<div class="collapse navbar-collapse flex-grow-0" id="mainNavbar">
			<ul class="navbar-nav mx-lg-4 mb-2 mb-lg-0">
				<li class="nav-item"><a class="nav-link" href="#mapSection">出没マップ</a></li>
				<li class="nav-item"><a class="nav-link" href="#">目撃情報掲示板</a></li>
				<li class="nav-item"><a class="nav-link" href="#">ログイン</a></li>
				<li class="nav-item"><a class="nav-link" href="#">会員登録</a></li>
			</ul>
		</div>

	</div>
</nav>
<section class="container my-5">
	<h2>유저 커뮤니티</h2>

	<div class="row g-4">
		<div class="col-md-6 col-lg-4">

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
				</div>
			</div>
		</div>

		<div class="col-md-6 col-lg-4">
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
				</div>
			</div>
		</div>
	</div>
</section>

</body>
</html>