<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<header class="header-sticky-wrap">
	<nav class="navbar navbar-expand-lg navbar-jp">
		<div
			class="container d-flex align-items-center justify-content-between">

			<a href="${pageContext.request.contextPath}/" class="d-flex align-items-center text-decoration-none">
				<div class="logo-badge me-2">熊</div>
				<div class="brand-jp">
					<div class="jp-title">熊の前</div>
					<div class="jp-sub">KUMA NO MAE</div>
				</div>
			</a>

			<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
				data-bs-target="#mainNavbar" aria-controls="mainNavbar"
				aria-expanded="false" aria-label="メニューを開く">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse flex-grow-0" id="mainNavbar">
				<ul class="navbar-nav mx-lg-4 mb-2 mb-lg-0 align-items-lg-center">

					<li class="nav-item"><a class="nav-link report-nav-link"
						href="${pageContext.request.contextPath}/board/report"> <i
							class="bi bi-exclamation-triangle-fill me-1"></i>目撃を報告する
					</a></li>
					<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/#mapSection">出没マップ</a>
					</li>

					<li class="nav-item dropdown community-menu"><a
						class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown"
						aria-expanded="false"> コミュニティ </a>

						<ul class="dropdown-menu">
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/community/list">
									ユーザーコミュニティ </a></li>
							<li><a class="dropdown-item" target="_blank"
								href="https://webshop.montbell.jp/goods/list.php?category=379300">
									関連装備ショッピング </a></li>
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/board/news"> ニュース掲示板
							</a></li>
						</ul></li>

					<c:choose>
						<c:when test="${not empty sessionScope.user}">
							<li class="nav-item">
								<a class="nav-link text-warning fw-bold" href="${pageContext.request.contextPath}/admin/main">
									<i class="bi bi-gear-fill me-1"></i>管理者
								</a>
							</li>

							<li class="nav-item"><span class="nav-link text-light">
									${sessionScope.user.userName}さま </span></li>

							<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/logout">ログアウト</a>
							</li>
						</c:when>

						<c:otherwise>
							<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/login">ログイン</a>
							</li>

							<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/signup">会員登録</a>
							</li>
						</c:otherwise>
					</c:choose>

				</ul>
			</div>

			<a href="${pageContext.request.contextPath}/#mapSection"
				class="btn btn-jp-mustard d-none d-lg-inline-block"> 地図を見る </a>

		</div>
	</nav>
</header>