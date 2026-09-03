<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ユーザーコミュニティ - KUMANO_MAE</title>

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
	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<section class="container my-5">
		<!-- 페이지 제목 & 타이틀 -->
		<div class="mb-4">
			<h2 class="fw-bold">ユーザーコミュニティ</h2>
			<p class="text-muted mb-0">目撃情報や登山道情報をユーザー同士で共有する掲示板です。</p>
		</div>

		<!-- 옵션 영역: 필터 + 검색창 + 글쓰기 버튼 -->
		<div class="card p-3 mb-4 bg-light border-0">
			<div class="row g-3 align-items-center">
				<!-- 카테고리 필터 -->
				<div class="col-lg-5 col-md-6">
					<div class="d-flex gap-2 flex-wrap">
						<button class="btn btn-jp-mustard btn-sm">すべて</button>
						<button class="btn btn-jp-outline btn-sm">目撃情報</button>
						<button class="btn btn-jp-outline btn-sm">登山道情報</button>
						<button class="btn btn-jp-outline btn-sm">雑談・質問</button>
					</div>
				</div>

				<!-- 키워드 검색 -->
				<div class="col-lg-5 col-md-6">
					<form action="${pageContext.request.contextPath}/board/list"
						method="get" class="d-flex gap-2">
						<input type="text" name="keyword"
							class="form-control form-control-sm" placeholder="タイトルや地域で検索...">
						<button type="submit"
							class="btn btn-jp-mustard btn-sm text-nowrap">
							<i class="bi bi-search"></i> 検索
						</button>
					</form>
				</div>

				<!-- 글쓰기 버튼 -->
				<div class="col-lg-2 col-md-12 text-lg-end">
					<a href="${pageContext.request.contextPath}/board/write"
						class="btn btn-jp-mustard btn-sm fw-bold w-100 w-lg-auto"> <i
						class="bi bi-pencil-fill me-1"></i>新規投稿
					</a>
				</div>
			</div>
		</div>

		<!-- 게시글 카드 목록 -->
		<div class="row g-4">

			<!-- Card Item 1 -->
			<div class="col-md-6 col-lg-4">
				<div class="card h-100 report-card shadow-sm">
					<img
						src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600"
						class="card-img-top" alt="クマ出没イメージ"
						style="height: 180px; object-fit: cover;">
					<div class="card-body d-flex flex-column">
						<div
							class="d-flex justify-content-between align-items-center mb-2">
							<span class="badge badge-danger-custom">危険</span> <small
								class="text-muted"><i class="bi bi-clock"></i>
								2026-08-20</small>
						</div>
						<h5 class="card-title text-truncate fw-bold">札幌近郊の登山道でクマを発見</h5>
						<p class="mb-2 text-muted small">
							<i class="bi bi-geo-alt-fill text-danger"></i> 北海道札幌市
						</p>
						<p class="small text-secondary flex-grow-1">登山道入口付近で成獣のクマ1頭を発見、登山客は避難済みです。</p>

						<hr class="my-2">

						<!-- 작성자 정보 & 조회수/댓글수 -->
						<div
							class="d-flex justify-content-between align-items-center text-muted small mt-auto">
							<span><i class="bi bi-person-circle me-1"></i> ヤマスキ</span>
							<div>
								<span class="me-2"><i class="bi bi-eye"></i> 124</span> <span><i
									class="bi bi-chat-dots"></i> 3</span>
							</div>
						</div>

						<a href="${pageContext.request.contextPath}/board/view"
							class="btn btn-jp-outline btn-sm mt-3 fw-bold">詳細を見る</a>
					</div>
				</div>
			</div>

			<!-- Card Item 2 -->
			<div class="col-md-6 col-lg-4">
				<div class="card h-100 report-card shadow-sm">
					<img
						src="https://images.unsplash.com/photo-1465311440653-ba9b1d9b5f04?w=600"
						class="card-img-top" alt="クマ出没イメージ"
						style="height: 180px; object-fit: cover;">
					<div class="card-body d-flex flex-column">
						<div
							class="d-flex justify-content-between align-items-center mb-2">
							<span class="badge badge-warning-custom">警戒</span> <small
								class="text-muted"><i class="bi bi-clock"></i>
								2026-08-19</small>
						</div>
						<h5 class="card-title text-truncate fw-bold">農地周辺でクマの足跡を発見</h5>
						<p class="mb-2 text-muted small">
							<i class="bi bi-geo-alt-fill text-danger"></i> 青森県
						</p>
						<p class="small text-secondary flex-grow-1">農地付近でクマの足跡と糞の痕跡を発見しました。ご注意ください。</p>

						<hr class="my-2">

						<div
							class="d-flex justify-content-between align-items-center text-muted small mt-auto">
							<span><i class="bi bi-person-circle me-1"></i> 田中太郎</span>
							<div>
								<span class="me-2"><i class="bi bi-eye"></i> 89</span> <span><i
									class="bi bi-chat-dots"></i> 1</span>
							</div>
						</div>

						<a href="${pageContext.request.contextPath}/board/view"
							class="btn btn-jp-outline btn-sm mt-3 fw-bold">詳細を見る</a>
					</div>
				</div>
			</div>

		</div>

		<!-- 하단 페이지네이션 -->
		<nav class="mt-5">
			<ul class="pagination justify-content-center">
				<li class="page-item disabled"><a class="page-link" href="#"
					tabindex="-1">前へ</a></li>
				<li class="page-item active"><a class="page-link" href="#">1</a></li>
				<li class="page-item"><a class="page-link" href="#">2</a></li>
				<li class="page-item"><a class="page-link" href="#">3</a></li>
				<li class="page-item"><a class="page-link" href="#">次へ</a></li>
			</ul>
		</nav>
	</section>

	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>