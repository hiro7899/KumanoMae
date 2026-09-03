<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>掲示物詳細管理 - KUMANO_MAE ADMIN</title>

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
	href="${pageContext.request.contextPath}/resources/css/main.css">
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
					<div class="jp-sub text-warning" style="font-size: 0.7rem;">KUMANO_MAE ADMIN</div>
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
			<!-- 상단 헤더 & 컨트롤 -->
			<div class="d-flex justify-content-between align-items-center mb-4">
				<h2 class="fw-bold m-0">
					<span class="dash">―</span>掲示物詳細管理
				</h2>
				<a href="${pageContext.request.contextPath}/admin/community/list" class="btn btn-outline-secondary btn-sm">
					<i class="bi bi-arrow-left me-1"></i> 一覧へ戻る
				</a>
			</div>

			<!-- 1. 게시글 기본 정보 카드 -->
			<div class="stat-card mb-4">
				<div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3">
					<div>
						<span class="badge bg-primary mb-2">${board.category}</span>
						<h3 class="fw-bold m-0">${board.title}</h3>
					</div>
					<div class="text-end">
						<c:choose>
							<c:when test="${board.status eq 'Y'}">
								<span class="badge bg-success">表示中</span>
							</c:when>
							<c:otherwise>
								<span class="badge bg-secondary">非表示</span>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<div class="row text-muted small mb-3">
					<div class="col-md-3"><strong>投稿者 (Member No):</strong> ${board.memberId}</div>
					<div class="col-md-3"><strong>登録日時:</strong> ${board.regDate}</div>
					<div class="col-md-3"><strong>照会数:</strong> ${board.viewCnt}</div>
					<div class="col-md-3"><strong>おすすめ数:</strong> ${board.likeCnt}</div>
				</div>

				<c:if test="${not empty board.gearName}">
					<div class="alert alert-light border mb-3">
						<strong><i class="bi bi-tag-fill me-1"></i> 対象装備名:</strong> ${board.gearName}
					</div>
				</c:if>

				<!-- 본문 내용 -->
				<div class="bg-light p-3 rounded mb-3" style="min-height: 150px; white-space: pre-wrap;">${board.content}</div>

				<!-- 첨부파일 목록 (CommunityFileDto) -->
				<div class="mb-2">
					<h6 class="fw-bold"><i class="bi bi-paperclip me-1"></i> 添付ファイル (${not empty fileList ? fileList.size() : 0})</h6>
					<c:choose>
						<c:when test="${not empty fileList}">
							<ul class="list-group list-group-flush border-top border-bottom">
								<c:forEach var="file" items="${fileList}">
									<li class="list-group-item d-flex justify-content-between align-items-center px-0">
										<div>
											<i class="bi bi-file-earmark-text me-2"></i>${file.originName}
										</div>
										<a href="${pageContext.request.contextPath}${file.filePath}/${file.saveName}" 
										   download="${file.originName}" class="btn btn-sm btn-outline-primary">
											<i class="bi bi-download"></i> ダウンロード
										</a>
									</li>
								</c:forEach>
							</ul>
						</c:when>
						<c:otherwise>
							<p class="text-muted small m-0">添付ファイルはありません。</p>
						</c:otherwise>
					</c:choose>
				</div>

				<!-- 게시글 상단 관리 버튼 -->
				<div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
					<c:choose>
						<c:when test="${board.status eq 'Y'}">
							<a href="${pageContext.request.contextPath}/admin/community/hide?cBoardId=${board.cBoardId}"
								class="btn btn-outline-danger btn-sm fw-bold">非表示に設定</a>
						</c:when>
						<c:otherwise>
							<a href="${pageContext.request.contextPath}/admin/community/show?cBoardId=${board.cBoardId}"
								class="btn btn-outline-success btn-sm fw-bold">再表示に設定</a>
						</c:otherwise>
					</c:choose>
					<a href="${pageContext.request.contextPath}/admin/community/delete?cBoardId=${board.cBoardId}"
						class="btn btn-danger btn-sm fw-bold"
						onclick="return confirm('投稿を完全削除しますか？');">投稿削除</a>
				</div>
			</div>

			<!-- 2. 댓글 목록 카드 (CommunityCommentDto) -->
			<div class="admin-table-card mb-4">
				<div class="p-3 border-bottom d-flex justify-content-between align-items-center">
					<h5 class="fw-bold m-0"><i class="bi bi-chat-dots me-2"></i>コメント管理</h5>
					<span class="badge bg-secondary">全 ${not empty commentList ? commentList.size() : 0} 件</span>
				</div>
				<div class="table-responsive">
					<table class="table table-hover align-middle mb-0 admin-table">
						<thead>
							<tr class="text-center">
								<th style="width: 10%;">Comment No</th>
								<th style="width: 15%;">投稿者 (Member No)</th>
								<th>コメント内容</th>
								<th style="width: 20%;">登録日時</th>
								<th style="width: 10%;">管理</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${not empty commentList}">
									<c:forEach var="comment" items="${commentList}">
										<tr>
											<td class="text-center">${comment.cCommentId}</td>
											<td class="text-center">${comment.memberId}</td>
											<td><c:out value="${comment.content}" /></td>
											<td class="text-center">${comment.regDate}</td>
											<td class="text-center">
												<a href="${pageContext.request.contextPath}/admin/community/comment/delete?cCommentId=${comment.cCommentId}&cBoardId=${board.cBoardId}"
													class="btn btn-outline-danger btn-sm"
													onclick="return confirm('このコメントを削除しますか？');">削除</a>
											</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
										<td colspan="5" class="text-center text-muted py-4">登録されたコメントはありません。</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
			</div>

			<!-- 3. 추천(좋아요) 이력 카드 (CommunityLikeDto) -->
			<div class="admin-table-card">
				<div class="p-3 border-bottom d-flex justify-content-between align-items-center">
					<h5 class="fw-bold m-0"><i class="bi bi-hand-thumbs-up me-2"></i>おすすめ履歴</h5>
					<span class="badge bg-secondary">全 ${not empty likeList ? likeList.size() : 0} 件</span>
				</div>
				<div class="table-responsive">
					<table class="table table-hover align-middle mb-0 admin-table">
						<thead>
							<tr class="text-center">
								<th style="width: 15%;">Like No</th>
								<th style="width: 35%;">推薦会員 (Member No)</th>
								<th style="width: 50%;">推薦日時</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${not empty likeList}">
									<c:forEach var="like" items="${likeList}">
										<tr class="text-center">
											<td>${like.cLikeId}</td>
											<td>${like.memberId}</td>
											<td>${like.regDate}</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<tr>
										<td colspan="3" class="text-center text-muted py-4">おすすめ履歴はありません。</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
			</div>

		</main>
	</div>
	<%@ include file="/WEB-INF/views/includes/footer.jsp" %>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>