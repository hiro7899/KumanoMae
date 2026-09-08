<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ユーザー管理 - KUMANO_MAE ADMIN</title>

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
	href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
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
				<a href="/admin/main" class="admin-nav-link">
					<i class="bi bi-speedometer2 me-2"></i>ダッシュボード
				</a>
				<a href="/admin/board/list" class="admin-nav-link">
					<i class="bi bi-exclamation-triangle-fill me-2"></i>目撃通報管理
				</a>
				<a href="/admin/community/list" class="admin-nav-link">
					<i class="bi bi-chat-left-dots-fill me-2"></i>掲示板管理
				</a>
				<a href="/admin/member/list" class="admin-nav-link active">
					<i class="bi bi-people-fill me-2"></i>ユーザー管理
				</a>
				<a href="/" class="admin-nav-link text-warning mt-4">
					<i class="bi bi-box-arrow-left me-2"></i>メインページへ
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
					<span class="dash">―</span>ユーザー管理
				</h2>
				<span class="badge bg-dark px-3 py-2">全 ${not empty memberList ? memberList.size() : 0} 名</span>
			</div>

			<!-- 1. 검색 및 필터 영역 -->
			<div class="stat-card mb-4">
				<form action="/admin/member/list" method="get" class="row g-3 align-items-center">
					<div class="col-md-3">
						<label class="form-label small fw-bold mb-1">権限</label>
						<select name="userGrade" class="form-select form-select-sm">
							<option value="">すべて</option>
							<option value="M" ${param.userGrade eq 'M' ? 'selected' : ''}>一般ユーザー</option>
							<option value="A" ${param.userGrade eq 'A' ? 'selected' : ''}>管理者</option>
						</select>
					</div>
					<div class="col-md-3">
						<label class="form-label small fw-bold mb-1">アカウント状態</label>
						<select name="status" class="form-select form-select-sm">
							<option value="">すべて</option>
							<option value="Y" ${param.status eq 'Y' ? 'selected' : ''}>正常</option>
							<option value="N" ${param.status eq 'N' ? 'selected' : ''}>利用停止</option>
						</select>
					</div>
					<div class="col-md-4">
						<label class="form-label small fw-bold mb-1">検索</label>
						<input type="text" name="keyword" value="${param.keyword}"
							class="form-control form-control-sm"
							placeholder="ID、お名前、またはメールアドレス">
					</div>
					<div class="col-md-2 d-flex align-items-end">
						<button type="submit" class="btn btn-jp-mustard btn-sm w-100 fw-bold">
							<i class="bi bi-search me-1"></i> 検索
						</button>
					</div>
				</form>
			</div>

			<!-- 2. 회원 목록 테이블 -->
			<div class="admin-table-card member-table-card">
				<div class="table-responsive">
					<table class="table table-hover align-middle text-center mb-0 admin-table member-management-table">
						<thead>
							<tr>
								<th>No</th>
								<th>ユーザーID</th>
								<th>お名前</th>
								<th>メールアドレス</th>
								<th>電話番号</th>
								<th>権限</th>
								<th>登録日時</th>
								<th>状態</th>
								<th>管理</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<c:when test="${not empty memberList}">
									<c:forEach var="member" items="${memberList}">
										<tr class="${member.status eq 'N' ? 'member-row-inactive' : ''}">
											<td>${member.memberId}</td>
											<td class="fw-bold">${member.userId}</td>
											<td><c:out value="${member.userName}" /></td>
											<td><c:out value="${member.email}" /></td>
											<td><c:out value="${not empty member.phone ? member.phone : '-'}" /></td>
											<td>
												<c:choose>
											<c:when test="${member.userGrade eq 'A'}">
														<span class="member-role-badge member-role-admin">管理者</span>
													</c:when>
													<c:otherwise>
														<span class="member-role-badge member-role-member">一般ユーザー</span>
													</c:otherwise>
												</c:choose>
											</td>
											<td>${member.joinDate}</td>
											<td>
												<c:choose>
											<c:when test="${member.status eq 'N'}">
														<span class="member-status-badge member-status-stopped">停止中</span>
													</c:when>
													<c:otherwise>
														<span class="member-status-badge member-status-active">利用中</span>
													</c:otherwise>
												</c:choose>
											</td>
											<td>
												<div class="member-actions">
													<c:choose>
														<c:when test="${member.status eq 'N'}">
															<span class="member-actions-muted"><i class="bi bi-slash-circle" aria-hidden="true"></i> 停止中</span>
														</c:when>
														<c:otherwise>
															<button type="button" class="member-action-button member-grade-button"
																data-member-id="${member.memberId}" data-current-grade="${member.userGrade}">
																<i class="bi bi-person-gear" aria-hidden="true"></i> 権限変更
															</button>
															<form action="${pageContext.request.contextPath}/admin/member/delete" method="post" class="member-stop-form"
																onsubmit="return confirm('このユーザーを利用停止にしますか？');">
																<input type="hidden" name="memberId" value="${member.memberId}">
																<button type="submit" class="member-action-button member-stop-button"><i class="bi bi-person-x" aria-hidden="true"></i> 停止</button>
															</form>
														</c:otherwise>
													</c:choose>
												</div>
											</td>
										</tr>
									</c:forEach>
							</c:when>
							<c:otherwise>
								<tr>
									<td colspan="9" class="text-center text-muted py-5">
										<i class="bi bi-inbox fs-3 d-block mb-2" aria-hidden="true"></i>
										該当するユーザーはいません。
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

	<div class="modal fade" id="gradeModal" tabindex="-1" aria-labelledby="gradeModalTitle" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content member-grade-modal">
				<form action="${pageContext.request.contextPath}/admin/member/updateGrade" method="post">
					<div class="modal-header">
						<h5 class="modal-title" id="gradeModalTitle"><i class="bi bi-person-gear" aria-hidden="true"></i> 権限変更</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="閉じる"></button>
					</div>
					<div class="modal-body">
						<input type="hidden" name="memberId" id="gradeMemberId">
						<p class="member-grade-target">対象ユーザー: <strong id="gradeMemberLabel"></strong></p>
						<label for="gradeSelect" class="form-label fw-bold">変更する権限</label>
						<select name="grade" id="gradeSelect" class="form-select">
							<option value="M">一般ユーザー</option>
							<option value="A">管理者</option>
						</select>
						<p class="form-text mb-0">管理者はすべての管理機能にアクセスできます。</p>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-outline-dark btn-sm" data-bs-dismiss="modal">キャンセル</button>
						<button type="submit" class="btn btn-jp-mustard btn-sm fw-bold">変更を保存</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
	(function() {
		var modalElement = document.getElementById('gradeModal');
		var gradeModal = new bootstrap.Modal(modalElement);
		var memberIdInput = document.getElementById('gradeMemberId');
		var memberLabel = document.getElementById('gradeMemberLabel');
		var gradeSelect = document.getElementById('gradeSelect');

		document.querySelectorAll('.member-grade-button').forEach(function(button) {
			button.addEventListener('click', function() {
				memberIdInput.value = button.dataset.memberId;
				memberLabel.textContent = '#' + button.dataset.memberId;
				gradeSelect.value = button.dataset.currentGrade;
				gradeModal.show();
			});
		});
	}());
	</script>
</body>
</html>
