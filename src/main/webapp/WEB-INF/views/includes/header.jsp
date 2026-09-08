<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<header class="header-sticky-wrap">
	<nav class="navbar navbar-expand-lg navbar-jp">
		<div
			class="container header-container d-flex align-items-center justify-content-between">

			<a href="${pageContext.request.contextPath}/" class="navbar-brand header-brand d-flex align-items-center text-decoration-none me-0">
				<div class="logo-badge me-2" aria-label="熊の前">
					<svg class="bear-logo" width="25" height="25" viewBox="0 0 40 40" aria-hidden="true">
						<circle cx="8.5" cy="10.5" r="6" fill="#332d25" />
						<circle cx="31.5" cy="10.5" r="6" fill="#332d25" />
						<circle cx="20" cy="22" r="16" fill="#332d25" />
						<ellipse cx="20" cy="27" rx="9" ry="6.5" fill="#fdfaf3" />
						<circle cx="14.4" cy="19.6" r="1.8" fill="#fdfaf3" />
						<circle cx="25.6" cy="19.6" r="1.8" fill="#fdfaf3" />
						<path d="M17 25.1 Q20 22.6 23 25.1 Q20 28.4 17 25.1Z" fill="#332d25" />
						<path d="M20 27.2 V29.6 M20 29.6 Q17.8 31 16.1 29.8 M20 29.6 Q22.2 31 23.9 29.8"
							fill="none" stroke="#332d25" stroke-width="1.25" stroke-linecap="round" />
					</svg>
				</div>
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
							<li><a class="dropdown-item" target="_blank" rel="noopener noreferrer"
								href="https://webshop.montbell.jp/goods/list.php?category=379300">
									関連装備を見る（外部サイト） <i class="bi bi-box-arrow-up-right ms-1"></i></a></li>
						</ul></li>

				<c:choose>
					<c:when test="${not empty sessionScope.user}">
							<c:if test="${sessionScope.user.userGrade eq 'A'}">
								<li class="nav-item">
									<a class="nav-link text-warning fw-bold" href="${pageContext.request.contextPath}/admin/main">
										<i class="bi bi-gear-fill me-1"></i>管理者
									</a>
								</li>
							</c:if>

							<li class="nav-item d-lg-none"><a class="nav-link text-light user-profile-link"
								href="${pageContext.request.contextPath}/user/profile">
									${sessionScope.user.userName}さま </a></li>

							<li class="nav-item d-lg-none"><a class="nav-link" href="${pageContext.request.contextPath}/logout">ログアウト</a>
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

			<div class="auth-nav-links d-none d-lg-flex align-items-center">
				<c:choose>
					<c:when test="${not empty sessionScope.user}">
						<a class="nav-link text-light user-profile-link" href="${pageContext.request.contextPath}/user/profile">
							${sessionScope.user.userName}さま</a>
						<a class="nav-link" href="${pageContext.request.contextPath}/logout">ログアウト</a>
					</c:when>
					<c:otherwise>
						<a class="nav-link auth-login-link" href="${pageContext.request.contextPath}/login">ログイン</a>
						<a class="nav-link auth-signup-link" href="${pageContext.request.contextPath}/signup">会員登録</a>
					</c:otherwise>
				</c:choose>
			</div>

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
