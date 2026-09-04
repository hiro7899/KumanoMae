<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${board.title}- KUMANO_MAE</title>

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

<!-- 커스텀 CSS 파일들 -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/main.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/index.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/community/community.css">
</head>
<body>
	<!-- 공통 헤더 INCLUDE -->
	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<main class="container community-detail-container">
		<nav class="community-breadcrumb" aria-label="breadcrumb">
			<a href="${pageContext.request.contextPath}/community/list">コミュニティ</a>
			<i class="bi bi-chevron-right" aria-hidden="true"></i>
			<span>投稿詳細</span>
		</nav>

		<div class="community-detail-card">
			<!-- 게시물 헤더 -->
			<header class="community-detail-header">
				<div class="mb-2">
					<c:choose>
						<c:when test="${board.category eq 'FREE'}">
							<span class="badge badge-cat-board">自由掲示板</span>
						</c:when>
						<c:when test="${board.category eq 'GEAR'}">
							<span class="badge badge-cat-gear fs-6">ギア</span>
						</c:when>
						<c:when test="${board.category eq 'REVIEW'}">
							<span class="badge badge-cat-review fs-6">レビュー</span>
						</c:when>
						<c:otherwise>
							<span class="badge badge-cat-board fs-6">${board.category}</span>
						</c:otherwise>
					</c:choose>
				</div>

				<h1 class="community-detail-title">${board.title}</h1>

				<div class="community-detail-meta">
					<div class="community-author-meta">
						<span><i class="bi bi-person-circle"></i>
							${board.memberId}</span> <span><i class="bi bi-clock"></i> <fmt:formatDate
								value="${board.regDate}" pattern="yyyy.MM.dd HH:mm" /></span>
					</div>
					<div class="community-count-meta">
						<span><i class="bi bi-eye"></i>
							${board.viewCnt}</span> <span><i class="bi bi-heart"></i>
							${board.likeCnt}</span>
					</div>
				</div>
			</header>

			<!-- 추천 장비 표시 영역 (GEAR 카테고리) -->
			<c:if test="${not empty board.gearName}">
				<div class="community-gear-box">
					<i class="bi bi-bag-check-fill"></i>
					<div>
						<strong>おすすめギア:</strong> ${board.gearName}
					</div>
				</div>
			</c:if>

			<!-- 게시물 본문 -->
			<div class="community-detail-content">${board.content}</div>

			<!-- 첨부파일 목록 -->
			<c:if test="${not empty fileList}">
				<div class="community-attachment-box">
					<div class="community-attachment-title">
						<i class="bi bi-paperclip"></i> 添付ファイル
					</div>
					<ul class="community-attachment-list">
						<c:forEach var="file" items="${fileList}">
							<li><a
								href="${file.filePath}/${file.saveName}"
								download="${file.originName}"><i class="bi bi-file-earmark-arrow-down"></i> ${file.originName} </a></li>
						</c:forEach>
					</ul>
				</div>
			</c:if>

			<!-- 버튼 영역 -->
			<div class="community-detail-actions">
				<a href="${pageContext.request.contextPath}/community/list" class="btn btn-jp-outline"> <i
					class="bi bi-arrow-left"></i> 一覧へ戻る
				</a>

				<div class="community-action-group">
					<!-- 좋아요 버튼 -->
					<a href="${pageContext.request.contextPath}/community/like?cBoardId=${board.cBoardId}"
						class="community-like-btn">
						<i class="bi bi-heart-fill"></i> いいね (${board.likeCnt})
					</a>

					<!-- 작성자 본인 제어 버튼 -->
					<c:if test="${sessionScope.loginMemberId eq board.memberId}">
						<a href="${pageContext.request.contextPath}/community/edit?cBoardId=${board.cBoardId}"
							class="btn btn-jp-mustard">編集</a>
						<a href="${pageContext.request.contextPath}/community/delete?cBoardId=${board.cBoardId}"
							class="btn btn-danger" onclick="return confirm('本当に削除しますか？');">削除</a>
					</c:if>
				</div>
			</div>

			<!-- 댓글 영역 -->
			<div class="comment-section">
				<h2 class="comment-section-title">
					<i class="bi bi-chat-dots"></i> コメント
				</h5>

				<!-- 댓글 작성 폼 -->
				<form action="${pageContext.request.contextPath}/community/comment/write" method="post" class="community-comment-form">
					<input type="hidden" name="cBoardId" value="${board.cBoardId}">
					<div class="community-comment-input">
						<textarea name="content" class="form-control" rows="2"
							placeholder="コメントを入力してください..." required></textarea>
						<button type="submit" class="btn btn-jp-mustard fw-bold px-4">登録</button>
					</div>
				</form>

				<!-- 댓글 목록 -->
				<div class="comment-list">
					<c:forEach var="comment" items="${commentList}">
						<div class="comment-item">
							<div class="d-flex justify-content-between align-items-start">
								<div class="comment-body">
									<div class="comment-author-line"><i class="bi bi-person-circle"></i>
									<strong>${comment.memberId}</strong>
									<span class="text-muted small"><fmt:formatDate
											value="${comment.regDate}" pattern="yyyy.MM.dd HH:mm" /></span></div>
									<p class="comment-content">${comment.content}</p>
								</div>
								<c:if test="${sessionScope.loginMemberId eq comment.memberId}">
									<a
										href="${pageContext.request.contextPath}/community/comment/delete?cCommentId=${comment.cCommentId}&cBoardId=${board.cBoardId}"
										class="btn btn-sm btn-link text-danger text-decoration-none p-0 ms-2"
										onclick="return confirm('コメントを削除しますか？');">削除</a>
								</c:if>
							</div>
						</div>
					</c:forEach>

					<c:if test="${empty commentList}">
						<div class="comment-empty"><i class="bi bi-chat-square"></i> コメントはまだありません。</div>
					</c:if>
				</div>
			</div>
		</div>

	</main>

	<!-- 공통 푸터 INCLUDE -->
	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>

	<!-- Bootstrap 5 JS -->
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
