<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>掲示板管理 - KUMANO_MAE ADMIN</title>

<!-- Bootstrap 5 CDN & Fonts & Bootstrap Icons -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap"
	rel="stylesheet">

<!-- 프로젝트 공통 CSS & 어드민 CSS -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/admin/list.css">
</head>
<body>

	<div class="admin-wrapper">
		<!-- ===================== 관리자 사이드바 ===================== -->
		<aside class="admin-sidebar">
			<div class="admin-brand d-flex align-items-center">
				<div class="logo-badge me-2">熊</div>
				<div class="brand-jp">
					<div class="jp-title text-white">管理システム</div>
					<div class="jp-sub text-warning" style="font-size: 0.7rem;">KUMANO_MAE
						ADMIN</div>
				</div>
			</div>
			<nav class="mt-2">
				<a href="${pageContext.request.contextPath}/admin/main"
					class="admin-nav-link"> <i class="bi bi-speedometer2 me-2"></i>ダッシュボード
				</a> <a href="${pageContext.request.contextPath}/admin/board/list"
					class="admin-nav-link"> <i
					class="bi bi-exclamation-triangle-fill me-2"></i>目撃通報管理
				</a> <a href="${pageContext.request.contextPath}/admin/community/list"
					class="admin-nav-link active"> <i
					class="bi bi-chat-left-dots-fill me-2"></i>掲示板管理
				</a> <a href="${pageContext.request.contextPath}/admin/member/list"
					class="admin-nav-link"> <i class="bi bi-people-fill me-2"></i>ユーザー管理
				</a> <a href="${pageContext.request.contextPath}/"
					class="admin-nav-link text-warning mt-4"> <i
					class="bi bi-box-arrow-left me-2"></i>メインページへ
				</a>
			</nav>
		</aside>

		<!-- ===================== 메인 콘텐츠 영역 ===================== -->
		<main class="admin-content">
			<c:if test="${not empty errorMsg}">
				<div class="alert alert-danger d-flex align-items-center gap-2" role="alert">
					<i class="bi bi-exclamation-triangle-fill" aria-hidden="true"></i>
					<span><c:out value="${errorMsg}" /></span>
				</div>
			</c:if>

			<!-- 상단 타이틀 -->
			<div class="d-flex justify-content-between align-items-center mb-4">
				<h2 class="fw-bold m-0">
					<span class="dash">―</span>掲示板管理
				</h2>
				<span class="badge bg-dark px-3 py-2">全 ${not empty communityList ? communityList.size() : 0}
					件</span>
			</div>

			<!-- 1. 검색 및 필터 영역 -->
			<div class="stat-card mb-4">
				<form
					action="${pageContext.request.contextPath}/admin/community/list"
					method="get" class="row g-3 align-items-center">
					<div class="col-md-3">
						<label class="form-label small fw-bold mb-1">表示状態</label> <select
							name="status" class="form-select form-select-sm">
							<option value="">すべて</option>
							<option value="Y" ${param.status eq 'Y' ? 'selected' : ''}>表示中</option>
							<option value="N" ${param.status eq 'N' ? 'selected' : ''}>非表示</option>
						</select>
					</div>
					<div class="col-md-3">
						<label class="form-label small fw-bold mb-1">カテゴリ</label> <select
							name="category" class="form-select form-select-sm">
							<option value="">すべて</option>
							<option value="REVIEW"
								${param.category eq 'REVIEW' ? 'selected' : ''}>探訪レビュー</option>
							<option value="GEAR"
								${param.category eq 'GEAR' ? 'selected' : ''}>装備おすすめ</option>
							<option value="FREE"
								${param.category eq 'FREE' ? 'selected' : ''}>自由掲示板</option>
						</select>
					</div>
					<div class="col-md-4">
						<label class="form-label small fw-bold mb-1">検索</label> <input
							type="text" name="keyword" value="${param.keyword}"
							class="form-control form-control-sm" placeholder="タイトルまたは投稿者">
					</div>
					<div class="col-md-2 d-flex align-items-end">
						<button type="submit"
							class="btn btn-jp-mustard btn-sm w-100 fw-bold">
							<i class="bi bi-search me-1"></i> 検索
						</button>
					</div>
				</form>
			</div>

			<!-- 2. 커뮤니티 게시글 목록 테이블 -->
			<div class="admin-table-card">
				<div class="table-responsive">
					<table
						class="table table-hover align-middle text-center mb-0 admin-table">
						<thead>
							<tr>
								<th>No</th>
								<th>カテゴリ</th>
								<th>タイトル</th>
								<th>投稿者ID</th>
								<th>作成日時</th>
								<th>状態</th>
								<th>管理</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${not empty communityList}">
									<c:forEach var="item" items="${communityList}">
										<tr>
											<td>${item.CBoardId}</td>
											<td><c:choose>
													<c:when test="${item.category eq 'REVIEW'}">
														<span class="badge bg-info text-dark">レビュー</span>
													</c:when>
													<c:when test="${item.category eq 'GEAR'}">
														<span class="badge bg-warning text-dark">装備</span>
													</c:when>
													<c:otherwise>
														<span class="badge bg-secondary">自由</span>
													</c:otherwise>
												</c:choose></td>
											<td class="text-start fw-bold"><a
												href="${pageContext.request.contextPath}/admin/community/detail?cBoardId=${item.CBoardId}"
												class="text-decoration-none text-dark">
													<c:out value="${item.title}" />
											</a></td>
											<td>${item.memberId}</td>
											<td>${item.regDate}</td>
											<td><c:choose>
													<c:when test="${item.status eq 'Y'}">
														<span class="badge bg-success">表示中</span>
													</c:when>
													<c:otherwise>
														<span class="badge bg-secondary">非表示</span>
													</c:otherwise>
												</c:choose></td>
											<td>
												<div class="d-flex justify-content-center gap-1">
													<c:choose>
														<c:when test="${item.status eq 'Y'}">
															<form action="${pageContext.request.contextPath}/admin/community/hide" method="post" class="d-inline"
																onsubmit="return confirm('この投稿を非表示にしますか？');">
																<input type="hidden" name="cBoardId" value="${item.CBoardId}">
																<button type="submit" class="btn btn-outline-danger btn-sm fw-bold">非表示</button>
															</form>
														</c:when>
														<c:otherwise>
															<form action="${pageContext.request.contextPath}/admin/community/show" method="post" class="d-inline"
																onsubmit="return confirm('この投稿を再表示しますか？');">
																<input type="hidden" name="cBoardId" value="${item.CBoardId}">
																<button type="submit" class="btn btn-outline-success btn-sm fw-bold">再表示</button>
															</form>
														</c:otherwise>
													</c:choose>
													<form action="${pageContext.request.contextPath}/admin/community/delete" method="post" class="d-inline"
														onsubmit="return confirm('この投稿を削除しますか？');">
														<input type="hidden" name="cBoardId" value="${item.CBoardId}">
														<button type="submit" class="btn btn-danger btn-sm fw-bold">削除</button>
													</form>
												</div>
											</td>
										</tr>
									</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="7" class="text-center text-muted py-5">
										<i class="bi bi-inbox fs-3 d-block mb-2" aria-hidden="true"></i>
										該当する投稿はありません。
									</td>
								</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
			</div>
		</main>
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
