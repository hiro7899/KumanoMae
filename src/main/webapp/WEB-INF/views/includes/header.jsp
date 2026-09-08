<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<header class="header-sticky-wrap">
	<nav class="navbar navbar-expand-lg navbar-jp">
		<div
			class="container header-container d-flex align-items-center justify-content-between">

			<a href="${pageContext.request.contextPath}/" class="navbar-brand header-brand d-flex align-items-center text-decoration-none me-0">
				<div class="logo-badge me-2">熊</div>
				<div class="brand-jp">
					<div class="jp-title">熊の前</div>
					<div class="jp-sub">KUMA NO MAE</div>
				</div>
			</a>

			<button class="navbar-toggler ms-auto" type="button" data-bs-toggle="collapse"
				data-bs-target="#mainNavbar" aria-controls="mainNavbar"
				aria-expanded="false" aria-label="メニューを開く">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse header-collapse" id="mainNavbar">
				<ul class="navbar-nav main-nav-links mb-2 mb-lg-0 align-items-lg-center">

					<li class="nav-item"><a class="nav-link report-nav-link"
						href="${pageContext.request.contextPath}/board/report"> <i
							class="bi bi-exclamation-triangle-fill me-1"></i>目撃を報告する
					</a></li>
					<li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/#mapSection">出没マップ</a>
					</li>

					<li class="nav-item dropdown community-menu"><a
						class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown"
						aria-expanded="false"> 情報・コミュニティ </a>

						<ul class="dropdown-menu">
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/community/list">
									ユーザーコミュニティ </a></li>
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/board/list">
									クマ目撃情報 </a></li>
							<li><a class="dropdown-item" href="${pageContext.request.contextPath}/board/news">
									ニュース・お知らせ </a></li>
							<li><a class="dropdown-item" target="_blank"
								href="https://webshop.montbell.jp/goods/list.php?category=379300">
									関連装備ショッピング <i class="bi bi-box-arrow-up-right ms-1"></i></a></li>
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
							<li class="nav-item d-lg-none"><a class="nav-link auth-login-link" href="${pageContext.request.contextPath}/login">ログイン</a>
							</li>

							<li class="nav-item d-lg-none"><a class="nav-link auth-signup-link" href="${pageContext.request.contextPath}/signup">会員登録</a>
							</li>
						</c:otherwise>
					</c:choose>

				</ul>
			</div>

			<c:if test="${empty sessionScope.user}">
				<div class="auth-nav-links d-none d-lg-flex align-items-center">
					<a class="nav-link auth-login-link" href="${pageContext.request.contextPath}/login">ログイン</a>
					<a class="nav-link auth-signup-link" href="${pageContext.request.contextPath}/signup">会員登録</a>
				</div>
			</c:if>

		</div>
	</nav>
</header>

<script>
	// 데스크톱에서는 Bootstrap 드롭다운을 hover로 열고, 모바일 클릭 방식은 유지한다.
	document.addEventListener("DOMContentLoaded", function() {
		document.querySelectorAll(".community-menu").forEach(function(menu) {
			var toggle = menu.querySelector(".dropdown-toggle");
			var dropdown = menu.querySelector(".dropdown-menu");
			var closeTimer;

			function isDesktop() {
				return window.matchMedia("(min-width: 992px)").matches;
			}

			function openDropdown() {
				if (!isDesktop()) return;
				window.clearTimeout(closeTimer);
				dropdown.classList.add("show");
				toggle.setAttribute("aria-expanded", "true");
			}

			function closeDropdown() {
				if (!isDesktop()) return;
				closeTimer = window.setTimeout(function() {
					dropdown.classList.remove("show");
					toggle.setAttribute("aria-expanded", "false");
				}, 120);
			}

			menu.addEventListener("mouseenter", openDropdown);
			menu.addEventListener("mouseleave", closeDropdown);
			menu.addEventListener("focusin", openDropdown);
			menu.addEventListener("focusout", function(event) {
				if (!menu.contains(event.relatedTarget)) closeDropdown();
			});
		});
	});
</script>
