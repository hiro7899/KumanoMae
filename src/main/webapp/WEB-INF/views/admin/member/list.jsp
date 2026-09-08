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
<link rel="stylesheet" href="/resources/css/main.css">
<link rel="stylesheet" href="/resources/css/admin/list.css">
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
							<option value="USER" ${param.userGrade eq 'USER' ? 'selected' : ''}>一般ユーザー</option>
							<option value="ADMIN" ${param.userGrade eq 'ADMIN' ? 'selected' : ''}>管理者</option>
						</select>
					</div>
					<div class="col-md-3">
						<label class="form-label small fw-bold mb-1">アカウント状態</label>
						<select name="status" class="form-select form-select-sm">
							<option value="">すべて</option>
							<option value="ACTIVE" ${param.status eq 'ACTIVE' ? 'selected' : ''}>正常</option>
							<option value="BAN" ${param.status eq 'BAN' ? 'selected' : ''}>利用停止</option>
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
			<div class="admin-table-card">
				<div class="table-responsive">
					<table class="table table-hover align-middle text-center mb-0 admin-table">
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
										<tr>
											<td>${member.memberId}</td>
											<td class="fw-bold">${member.userId}</td>
											<td><c:out value="${member.userName}" /></td>
											<td><c:out value="${member.email}" /></td>
											<td><c:out value="${not empty member.phone ? member.phone : '-'}" /></td>
											<td>
												<c:choose>
													<c:when test="${member.userGrade eq 'ADMIN'}">
														<span class="badge bg-danger">管理者</span>
													</c:when>
													<c:otherwise>
														<span class="badge bg-secondary">一般</span>
													</c:otherwise>
												</c:choose>
											</td>
											<td>${member.joinDate}</td>
											<td>
												<c:choose>
													<c:when test="${member.status eq 'BAN'}">
														<span class="badge bg-dark">停止中</span>
													</c:when>
													<c:otherwise>
														<span class="badge bg-success">正常</span>
													</c:otherwise>
												</c:choose>
											</td>
											<td>
												<div class="d-flex justify-content-center gap-1">
													<c:choose>
														<c:when test="${member.status eq 'BAN'}">
															<a href="/admin/member/unban?userId=${member.userId}"
																class="btn btn-outline-success btn-sm fw-bold">解除</a>
														</c:when>
														<c:otherwise>
															<c:if test="${member.userGrade ne 'ADMIN'}">
																<a href="/admin/member/ban?userId=${member.userId}"
																	class="btn btn-outline-danger btn-sm fw-bold"
																	onclick="return confirm('このユーザーの利用を停止しますか？');">停止</a>
															</c:if>
															<c:if test="${member.userGrade eq 'ADMIN'}">
																<button class="btn btn-secondary btn-sm fw-bold" disabled>--</button>
															</c:if>
														</c:otherwise>
													</c:choose>
												</div>
											</td>
										</tr>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<!-- 데이터가 없을 때의 샘플 데이터 -->
									<tr>
										<td>1</td>
										<td class="fw-bold">admin01</td>
										<td>管理者</td>
										<td>admin@kumanomae.jp</td>
										<td>090-1234-5678</td>
										<td><span class="badge bg-danger">管理者</span></td>
										<td>2026-08-01T10:00</td>
										<td><span class="badge bg-success">正常</span></td>
										<td>
											<button class="btn btn-secondary btn-sm fw-bold" disabled>--</button>
										</td>
									</tr>
									<tr>
										<td>2</td>
										<td class="fw-bold">user01</td>
										<td>山田太郎</td>
										<td>yamada@example.com</td>
										<td>080-9876-5432</td>
										<td><span class="badge bg-secondary">一般</span></td>
										<td>2026-08-15T14:30</td>
										<td><span class="badge bg-success">正常</span></td>
										<td>
											<a href="/admin/member/ban?userId=user01"
												class="btn btn-outline-danger btn-sm fw-bold"
												onclick="return confirm('このユーザーの利用を停止しますか？');">停止</a>
										</td>
									</tr>
									<tr>
										<td>3</td>
										<td class="fw-bold">bad_user</td>
										<td>悪質ユーザー</td>
										<td>bad@example.com</td>
										<td>-</td>
										<td><span class="badge bg-secondary">一般</span></td>
										<td>2026-08-18T09:12</td>
										<td><span class="badge bg-dark">停止中</span></td>
										<td>
											<a href="/admin/member/unban?userId=bad_user"
												class="btn btn-outline-success btn-sm fw-bold">解除</a>
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

	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>