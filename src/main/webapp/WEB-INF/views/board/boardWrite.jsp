<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Community-KUMANO_MAE</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/main.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/index.css">

</head>
<body>
	<%@ include file="/WEB-INF/views/includes/header.jsp"%>

	<div class="container my-5">
		<div class="write_wrap">
			<h2 class="fw-bold mb-4">新規投稿</h2>
			<form name="boardWrite" method="post" action="boardWrite_insert.html"
				onsubmit="return check()" enctype="multipart/form-data">
				<table class="table table-bordered align-middle">
					<colgroup>
						<col width="15%">
						<col width="85%">
					</colgroup>
					<tbody>
						<tr>
							<th class="bg-light text-center">タイトル</th>
							<td><input type="text" name="title" class="form-control"></td>
						</tr>
						<tr>
							<th class="bg-light text-center">内容</th>
							<!-- rows 숫자로 세로 높이 조절 -->
							<td><textarea name="contents" class="form-control" rows="18"></textarea></td>
						</tr>
						<tr>
							<th class="bg-light text-center">添付ファイル</th>
							<td><input type="file" name="photo" class="form-control"></td>
						</tr>
					</tbody>
				</table>
				<div class="d-flex justify-content-center gap-2 mt-4">
					<input type="submit" value="登録" class="btn btn-jp-mustard">
					<input type="reset" value="リセット" class="btn btn-secondary">
					<input type="button" value="一覧へ" class="btn btn-jp-outline"
						onClick="location.href='boardList.jsp';">
				</div>
			</form>
		</div>
	</div>
	<script>
		function check() {
			const form = document.boardWrite;
			if (!form.title.value.trim()) {
				alert("タイトルを入力してください。"); // 타이틀을 입력해주세요
				form.title.focus();
				return false;
			}
			if (!form.contents.value.trim()) {
				alert("内容を入力してください。"); // 내용을 입력해주세요
				form.contents.focus();
				return false;
			}
			return true;
		}
	</script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
