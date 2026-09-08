<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>投稿詳細管理 - KUMANO_MAE ADMIN</title>

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
					<span class="dash">―</span>投稿詳細管理
				</h2>
				<a href="${pageContext.request.contextPath}/admin/community/list" class="btn btn-outline-secondary btn-sm">
					<i class="bi bi-arrow-left me-1"></i> 一覧へ戻る
				</a>
			</div>

			<!-- 1. 게시글 기본 정보 카드 -->
			<div class="stat-card mb-4">
				<div class="d-flex justify-content-between align-items-start border-bottom pb-3 mb-3">
					<div>
						<span class="badge bg-primary mb-2"><c:out value="${communityBoard.category}"/></span>
						<h3 class="fw-bold m-0"><c:out value="${communityBoard.title}"/></h3>
					</div>
					<div class="text-end">
						<c:choose>
							<c:when test="${communityBoard.status eq 'Y'}">
								<span class="badge bg-success">表示中</span>
							</c:when>
							<c:otherwise>
								<span class="badge bg-secondary">非表示</span>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

				<div class="row text-muted small mb-3">
					<div class="col-md-3"><strong>投稿者:</strong> <c:out value="${not empty communityBoard.writerName ? communityBoard.writerName : communityBoard.memberId}"/></div>
					<div class="col-md-3"><strong>登録日時:</strong> <c:out value="${communityBoard.regDate}"/></div>
					<div class="col-md-3"><strong>照会数:</strong> <c:out value="${communityBoard.viewCnt}"/></div>
					<div class="col-md-3"><strong>おすすめ数:</strong> <c:out value="${communityBoard.likeCnt}"/></div>
				</div>

				<c:if test="${not empty communityBoard.gearName}">
					<div class="alert alert-light border mb-3">
						<strong><i class="bi bi-tag-fill me-1"></i> 対象装備名:</strong> <c:out value="${communityBoard.gearName}"/>
					</div>
				</c:if>

				<!-- 본문 내용 -->
				<div class="bg-light p-3 rounded mb-3" style="min-height: 150px; white-space: pre-wrap;"><c:out value="${communityBoard.content}"/></div>

				<!-- 이미지와 일반 첨부파일을 분리해서 표시 -->
				<c:if test="${not empty fileList}">
					<div class="mb-4">
						<h6 class="fw-bold"><i class="bi bi-images me-1"></i> 添付画像</h6>
						<div class="row g-3">
							<c:forEach var="file" items="${fileList}">
								<c:set var="fileName" value="${fn:toLowerCase(file.originName)}" />
								<c:if test="${fn:endsWith(fileName, '.jpg') or fn:endsWith(fileName, '.jpeg') or fn:endsWith(fileName, '.png') or fn:endsWith(fileName, '.gif') or fn:endsWith(fileName, '.webp')}">
									<c:url var="imageUrl" value="${file.filePath}/${file.saveName}" />
									<div class="col-sm-6 col-lg-4">
										<a href="${imageUrl}" target="_blank" rel="noopener" class="d-block border rounded overflow-hidden bg-light">
											<img src="${imageUrl}" alt="${fn:escapeXml(file.originName)}" class="img-fluid w-100" style="height: 180px; object-fit: cover;">
										</a>
									</div>
								</c:if>
							</c:forEach>
						</div>
					</div>

					<c:set var="hasAttachmentFile" value="false" />
					<c:forEach var="file" items="${fileList}">
						<c:set var="fileName" value="${fn:toLowerCase(file.originName)}" />
						<c:if test="${not (fn:endsWith(fileName, '.jpg') or fn:endsWith(fileName, '.jpeg') or fn:endsWith(fileName, '.png') or fn:endsWith(fileName, '.gif') or fn:endsWith(fileName, '.webp'))}">
							<c:set var="hasAttachmentFile" value="true" />
						</c:if>
					</c:forEach>
					<c:if test="${hasAttachmentFile}">
						<div class="mb-2">
							<h6 class="fw-bold"><i class="bi bi-paperclip me-1"></i> 添付ファイル</h6>
							<ul class="list-group list-group-flush border-top border-bottom">
								<c:forEach var="file" items="${fileList}">
									<c:set var="fileName" value="${fn:toLowerCase(file.originName)}" />
									<c:if test="${not (fn:endsWith(fileName, '.jpg') or fn:endsWith(fileName, '.jpeg') or fn:endsWith(fileName, '.png') or fn:endsWith(fileName, '.gif') or fn:endsWith(fileName, '.webp'))}">
										<c:url var="downloadUrl" value="${file.filePath}/${file.saveName}" />
										<li class="list-group-item d-flex justify-content-between align-items-center px-0">
											<div><i class="bi bi-file-earmark-text me-2"></i><c:out value="${file.originName}" /></div>
											<a href="${downloadUrl}" download="${fn:escapeXml(file.originName)}" class="btn btn-sm btn-outline-primary"><i class="bi bi-download"></i> ダウンロード</a>
										</li>
									</c:if>
								</c:forEach>
							</ul>
						</div>
					</c:if>
				</c:if>

				<!-- 게시글 상단 관리 버튼 -->
				<div class="d-flex justify-content-end gap-2 mt-4 pt-3 border-top">
					<c:choose>
						<c:when test="${communityBoard.status eq 'Y'}">
							<form action="${pageContext.request.contextPath}/admin/community/hide" method="post"
								onsubmit="return confirm('この投稿を非表示にしますか？');">
								<input type="hidden" name="cBoardId" value="${communityBoard.CBoardId}">
								<button type="submit" class="btn btn-outline-danger btn-sm fw-bold">非表示に設定</button>
							</form>
						</c:when>
						<c:otherwise>
							<form action="${pageContext.request.contextPath}/admin/community/show" method="post"
								onsubmit="return confirm('この投稿を再表示しますか？');">
								<input type="hidden" name="cBoardId" value="${communityBoard.CBoardId}">
								<button type="submit" class="btn btn-outline-success btn-sm fw-bold">再表示に設定</button>
							</form>
						</c:otherwise>
					</c:choose>
					<form action="${pageContext.request.contextPath}/admin/community/delete" method="post"
						onsubmit="return confirm('この投稿を削除しますか？');">
						<input type="hidden" name="cBoardId" value="${communityBoard.CBoardId}">
						<button type="submit" class="btn btn-danger btn-sm fw-bold">投稿削除</button>
					</form>
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
											<td class="text-center"><c:out value="${comment.CCommentId}"/></td>
											<td class="text-center"><c:out value="${comment.memberId}"/></td>
											<td><c:out value="${comment.content}" /></td>
											<td class="text-center"><c:out value="${comment.regDate}"/></td>
											<td class="text-center">
												<form action="${pageContext.request.contextPath}/admin/community/comment/delete" method="post"
													onsubmit="return confirm('このコメントを削除しますか？');">
													<input type="hidden" name="cCommentId" value="${comment.CCommentId}">
													<input type="hidden" name="cBoardId" value="${communityBoard.CBoardId}">
													<button type="submit" class="btn btn-outline-danger btn-sm">削除</button>
												</form>
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

		</main>
	</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
