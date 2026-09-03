<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<!-- ===================== Footer ===================== -->

	<footer class="footer-jp pt-5 pb-3">
		<div class="container">
			<div class="row">
				<div class="col-md-4 mb-4">
					<div class="d-flex align-items-center mb-3">
						<div class="logo-badge me-2">熊</div>
						<div class="brand-jp">
							<div class="jp-title">クマ出没マップ</div>
						</div>
					</div>
					<p class="small footer-muted">
						里山に近づく足音を見逃さない。<br>全国のクマ目撃情報をリアルタイムに共有するサービスです。
					</p>
				</div>
				<div class="col-md-4 mb-4">
					<h6 class="fw-bold mb-3 footer-heading">会社情報</h6>
					<ul class="list-unstyled small footer-muted">
						<li class="mb-2">株式会社ベアセーフ（BearSafe Inc.）</li>
						<li class="mb-2"><i class="bi bi-telephone-fill me-2"></i>03-1234-5678</li>
						<li class="mb-2"><i class="bi bi-geo-alt-fill me-2"></i>日本
							北海道 札幌市 中央区 1-1-1</li>
					</ul>
				</div>
				<div class="col-md-4 mb-4">
					<h6 class="fw-bold mb-3 footer-heading">サイトマップ</h6>
					<ul class="list-unstyled small">
						<li class="mb-2"><a
							href="${pageContext.request.contextPath}/map">出没マップ</a></li>
						<li class="mb-2"><a
							href="${pageContext.request.contextPath}/board/news">目撃情報掲示板</a></li>
						<li class="mb-2"><a
							href="${pageContext.request.contextPath}/login">ログイン</a></li>
						<li class="mb-2"><a
							href="${pageContext.request.contextPath}/signup">会員登録</a></li>
					</ul>
				</div>
			</div>
			<hr class="footer-divider">
			<div class="text-center small footer-copyright">&copy; 2026
				BearSafe Inc. All Rights Reserved.</div>
		</div>
	</footer>


</body>
</html>