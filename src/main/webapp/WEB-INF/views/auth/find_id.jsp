<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%--
    =========================================================
    findId.jsp

    - 아이디 찾기 화면
    - 이메일 + 전화번호를 이용하여 아이디 찾기
    - 전화번호는 선택 입력
    - 실제 DB 조회는 Servlet/DAO에서 처리
    - input name은 회원 정보 필드명과 동일하게 사용
      userId
      userPw
      userName
      email
      phone
    =========================================================
--%>

<!DOCTYPE html>

<html lang="ja">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>IDを忘れた方 - クマ出没マップ</title>


<!-- Bootstrap 5 -->

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">


<!-- Bootstrap Icons -->

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">


<!-- 일본어 폰트 -->

<link rel="preconnect" href="https://fonts.googleapis.com">

<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap"
	rel="stylesheet">


<!-- 아이디 찾기 전용 CSS -->

<link rel="stylesheet" href="/resources/css/login/find_id.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/includes/layout.css">

</head>


<body>

	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<!-- =====================================================
     Find ID
     ===================================================== -->

	<main class="findid-main">

		<div class="container">


			<div class="findid-card">


				<!-- =========================
                 Header
                 ========================= -->

				<div class="findid-header">

					<span class="header-line"></span>

					<p class="findid-eyebrow">― ACCOUNT</p>

					<h1>IDを忘れた方</h1>

					<p>
						ご登録いただいたメールアドレスと電話番号を入力してください。<br> IDの確認手続きをご案内します。
					</p>

				</div>



				<!-- =================================================
                 아이디 찾기 Form

                 email : 필수
                 phone : 선택
                 ================================================= -->

				<form method="post" action="/find_id" id="findIdForm">


					<!-- =========================
                     이메일
                     ========================= -->

					<div class="form-group">

						<label for="email"> メールアドレス </label>


						<div class="input-wrapper">

							<i class="bi bi-envelope"></i> <input type="email" id="email"
								name="email" class="form-control"
								placeholder="example@email.com" autocomplete="email" required>

						</div>

					</div>



					<!-- =========================
                     전화번호
                     
                     - 선택 입력
                     - required 사용하지 않음
                     ========================= -->

					<div class="form-group">

						<label for="phone"> 電話番号 <span class="optional">
								（任意） </span>
						</label>


						<div class="input-wrapper">

							<i class="bi bi-telephone"></i> <input type="tel" id="phone"
								name="phone" class="form-control" placeholder="090-1234-5678"
								autocomplete="tel">

						</div>

					</div>



					<!-- =========================
                     확인 버튼
                     ========================= -->

					<button type="submit" id="findIdBtn" class="findid-submit-btn">

						IDを確認する <i class="bi bi-arrow-right"></i>

					</button>



					<!-- =========================
                     다른 화면으로 이동
                     ========================= -->

					<div class="find-link-area">


						<a href="/find-pw"> パスワードをお忘れの方 </a> <a href="/login">
							ログインはこちら </a>

					</div>


				</form>

			</div>

		</div>

	</main>



	<!-- =====================================================
     Bootstrap 5 JS
     ===================================================== -->

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
		
	</script>


	<!-- =====================================================
     아이디/비밀번호 찾기 JS
     ===================================================== -->

	<script src="/resources/js/login/find_id.js">
		
	</script>

	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>

</body>

</html>
