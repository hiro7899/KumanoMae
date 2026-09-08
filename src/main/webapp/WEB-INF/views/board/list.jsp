<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>目撃情報一覧 - KUMANO_MAE</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/main.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/index.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
</head>
<body>
	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<section class="container my-5">
		<!-- 페이지 제목 & 설명 -->
		<div class="mb-4">
			<h2 class="fw-bold">クマ目撃・出没情報一覧</h2>
			<p class="text-muted mb-0">全国の自治体データおよび 住民から寄せられたクマの目撃・出没情報です。</p>
		</div>

		<!-- 옵션 영역: 위험도 필터 + 지역 검색창 + 제보하기 버튼 -->
		<div class="card p-3 mb-4 bg-light border-0">
			<div class="row g-3 align-items-center">
				<!-- 위험도별 필터 -->
				<div class="col-lg-5 col-md-6">
					<div class="d-flex gap-2 flex-wrap align-items-center">
						<span class="fw-bold small me-1">危険度:</span>
						<button class="btn btn-jp-mustard btn-sm">すべて</button>
						<button class="btn btn-outline-danger btn-sm fw-bold">危険 (DANGER)</button>
						<button class="btn btn-outline-warning btn-sm text-dark fw-bold">警戒 (WARNING)</button>
						<button class="btn btn-outline-secondary btn-sm fw-bold">注意 (CAUTION)</button>
					</div>
				</div>

				<!-- 지역/제목 키워드 검색 -->
				<div class="col-lg-5 col-md-6">
					<form action="${pageContext.request.contextPath}/board/list" method="get" class="d-flex gap-2">
						<input type="text" name="keyword" class="form-control form-control-sm" placeholder="地域名（例：札幌市、青森県）で検索...">
						<button type="submit" class="btn btn-jp-mustard btn-sm text-nowrap">
							<i class="bi bi-search"></i> 検索
						</button>
					</form>
				</div>

				<!-- 제보 등록 버튼 -->
				<div class="col-lg-2 col-md-12 text-lg-end">
					<a href="${pageContext.request.contextPath}/board/report"
						class="btn btn-jp-mustard btn-sm fw-bold w-100 w-lg-auto"> 
						<i class="bi bi-exclamation-triangle-fill me-1"></i>目撃を報告する
					</a>
				</div>
			</div>
		</div>

		<!-- 제보 카드 목록 -->
		<div class="row g-4">
			<c:forEach var="board" items="${boardList}">
				<div class="col-md-6 col-lg-4">
					<article class="card h-100 report-card shadow-sm">
						<img
							src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600"
							class="card-img-top" alt="クマ出没イメージ"
							style="height: 180px; object-fit: cover;">
						<div class="card-body d-flex flex-column">
							<div class="d-flex justify-content-between align-items-center gap-2 mb-2">
								<c:choose>
									<c:when test="${board.riskLevel eq 'DANGER'}">
										<span class="badge badge-danger-custom">危険</span>
									</c:when>
									<c:when test="${board.riskLevel eq 'WARNING'}">
										<span class="badge badge-warning-custom">警戒</span>
									</c:when>
									<c:otherwise>
										<span class="badge badge-caution-custom">注意</span>
									</c:otherwise>
								</c:choose>
								<small class="text-muted text-end"><i class="bi bi-clock-fill me-1"></i><c:out value="${board.sightingDate}" /></small>
							</div>

							<h5 class="card-title text-truncate fw-bold"><c:out value="${board.title}" /></h5>
							<p class="mb-2 text-danger small fw-bold">
								<i class="bi bi-geo-alt-fill me-1"></i><c:out value="${board.address}" />
							</p>
							<p class="small text-secondary flex-grow-1"><c:out value="${board.content}" /></p>

							<hr class="my-2">

							<div class="d-flex justify-content-between align-items-center text-muted small mt-auto">
								<span><i class="bi bi-shield-check me-1"></i> 住民報告</span>
								<span><i class="bi bi-eye me-1"></i> ${board.viewCnt}</span>
							</div>

							<a href="${pageContext.request.contextPath}/board/detail?boardId=${board.boardId}"
								class="btn btn-jp-outline btn-sm mt-3 fw-bold">詳細を見る</a>
						</div>
					</article>
				</div>
			</c:forEach>

			<c:if test="${empty boardList}">
				<div class="col-12">
					<div class="card border-0 bg-light py-5 text-center">
						<div class="card-body text-muted">
							<i class="bi bi-geo-alt fs-1 d-block mb-3"></i>
							<p class="fw-bold mb-1">現在表示できる目撃情報はありません。</p>
							<small>新しい情報が承認されると、こちらに表示されます。</small>
						</div>
					</div>
				</div>
			</c:if>
		</div>
	</section>

	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
