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
<body>
	<%@ include file="/WEB-INF/views/includes/header.jsp" %>
	<section class="container my-5">
		<h2>ユーザーコミュニティ</h2>

<!-- 필터 + 글쓰기 버튼을 한 줄로 양끝 정렬 -->
<div class="d-flex justify-content-between align-items-center mb-4">
    <!-- 왼쪽: 카테고리 필터 -->
    <div class="d-flex gap-2">
        <button class="btn btn-jp-mustard btn-sm">すべて</button>
        <button class="btn btn-jp-outline btn-sm">登山道情報</button>
        <button class="btn btn-jp-outline btn-sm">クマ目撃討論</button>
    </div>

    <!-- 오른쪽: 글쓰기 버튼 -->
    <a href="${pageContext.request.contextPath}/board/Write" class="btn btn-jp-mustard btn-sm fw-bold">
        <i class="bi bi-pencil-fill me-1"></i>新規投稿
    </a>
</div>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>