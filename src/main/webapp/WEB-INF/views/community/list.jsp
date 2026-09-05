<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>コミュニティ - KUMANO_MAE</title>

<!-- Bootstrap 5 CDN & Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- 일본어 폰트 -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">

<!-- 커스텀 CSS 파일들 -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/index.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/community/community.css">
</head>
<body>
	<!-- 공통 헤더 INCLUDE -->
	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<main class="container community-container">
		
		<!-- 페이지 섹션 타이틀 -->
		<div class="community-hero">
			<div class="community-hero-icon" aria-hidden="true">
				<i class="bi bi-people-fill"></i>
			</div>
			<div>
				<span class="community-eyebrow">KUMANO_MAE COMMUNITY</span>
				<h2 class="community-title">コミュニティ</h2>
				<p class="community-lead mb-0">登山装備のおすすめやレビュー、山の情報をみんなで共有しましょう。</p>
			</div>
		</div>

		<!-- カテゴリタブ & 新規投稿ボタン -->
		<div class="community-toolbar">
			<div class="community-tabs" role="group" aria-label="投稿カテゴリ">
				<a href="${pageContext.request.contextPath}/community/list"
					class="community-tab ${empty param.category ? 'active' : ''}">すべて</a>
				<a href="${pageContext.request.contextPath}/community/list?category=FREE"
					class="community-tab ${param.category == 'FREE' ? 'active' : ''}">掲示板</a>
				<a href="${pageContext.request.contextPath}/community/list?category=GEAR"
					class="community-tab ${param.category == 'GEAR' ? 'active' : ''}">ギアおすすめ</a>
				<a href="${pageContext.request.contextPath}/community/list?category=REVIEW"
					class="community-tab ${param.category == 'REVIEW' ? 'active' : ''}">レビュー</a>
			</div>
			
			<a href="${pageContext.request.contextPath}/community/write" class="community-write-btn">
				<i class="bi bi-pencil-fill"></i> 新規投稿
			</a>
		</div>

		<!-- 뉴스형 게시글 목록 영역 -->
		<div class="d-flex flex-column gap-3">
			<c:forEach var="board" items="${communityList}">
				<c:if test="${board.status eq 'Y'}">
					<article class="news-item-card" data-category="${board.category}">
						<div class="row g-3 align-items-center">
							
							<!-- 네모난 썸네일 이미지 (좌측) -->
							<div class="col-12 col-sm-auto text-center">
								<a href="${pageContext.request.contextPath}/community/detail?cBoardId=${board.cBoardId}" class="news-thumb-link">
									<c:choose>
										<c:when test="${not empty board.thumbnailPath}">
											<img src="${board.thumbnailPath}" class="news-thumb-img" alt="thumbnail">
										</c:when>
										<c:otherwise>
											<!-- 이미지가 없을 경우 노출되는 기본 이미지/아이콘 -->
											<div class="news-thumb-img news-thumb-placeholder d-flex align-items-center justify-content-center">
												<i class="bi bi-chat-square-text"></i>
											</div>
										</c:otherwise>
									</c:choose>
								</a>
							</div>

							<!-- 게시글 정보 영역 (우측) -->
							<div class="col">
								<!-- 카테고리 뱃지 & 글번호 -->
								<div class="d-flex align-items-center gap-2 mb-1">
									<c:choose>
										<c:when test="${board.category eq 'FREE'}">
											<span class="badge badge-cat-board">掲示板</span>
										</c:when>
										<c:when test="${board.category eq 'GEAR'}">
											<span class="badge badge-cat-gear">ギア</span>
										</c:when>
										<c:when test="${board.category eq 'REVIEW'}">
											<span class="badge badge-cat-review">レビュー</span>
										</c:when>
										<c:otherwise>
											<span class="badge badge-cat-board">${board.category}</span>
										</c:otherwise>
									</c:choose>
									<span class="text-muted small">No. ${board.cBoardId}</span>
								</div>

								<!-- 제목 -->
								<h5 class="community-post-title">
									<a href="${pageContext.request.contextPath}/community/detail?cBoardId=${board.cBoardId}">
										${board.title}
									</a>
								</h5>

								<!-- 내용 요약 (옵션 - board.content 일부 노출 가능) -->
								<p class="community-post-summary">
									<c:if test="${not empty board.gearName}">
										<strong>[ギア: ${board.gearName}]</strong> 
									</c:if>
									${board.content}
								</p>

								<!-- 작성자, 조회수, 좋아요 -->
								<div class="community-post-meta">
									<span><i class="bi bi-person"></i> ${board.memberId}</span>
									<span><i class="bi bi-eye"></i> ${board.viewCnt}</span>
									<span><i class="bi bi-heart"></i> ${board.likeCnt}</span>
								</div>
							</div>
							<div class="col-auto d-none d-md-block">
								<i class="bi bi-chevron-right community-card-arrow" aria-hidden="true"></i>
							</div>

						</div>
					</article>
				</c:if>
			</c:forEach>

			<!-- 데이터가 없는 경우 -->
			<c:if test="${empty communityList}">
				<div class="news-item-card community-empty text-center">
					<div class="empty-msg-box">
						<i class="bi bi-chat-square-dots"></i>
						<h3>まだ投稿がありません</h3>
						<p>最初の話題を投稿して、コミュニティを始めましょう。</p>
						<a href="${pageContext.request.contextPath}/community/write" class="community-write-btn">新規投稿</a>
					</div>
				</div>
			</c:if>
		</div>

	</main>

	<!-- 공통 푸터 INCLUDE -->
	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>

	<!-- Bootstrap 5 JS -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
