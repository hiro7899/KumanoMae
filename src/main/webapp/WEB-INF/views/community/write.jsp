<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>${empty board ? '新規投稿' : '投稿の編集'}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5" style="max-width: 700px;">
    <h2 class="fw-bold">${empty board ? '新規投稿' : '投稿の編集'}</h2>
    
    <form action="${empty board ? '/community/write' : '/community/edit'}" 
          method="post" enctype="multipart/form-data" class="mt-4">
        
        <c:if test="${not empty board}">
            <input type="hidden" name="cBoardId" value="${board.cBoardId}">
        </c:if>

        <div class="mb-3">
            <label class="form-label fw-bold">カテゴリ</label>
            <select name="category" id="categorySelect" class="form-select" required onchange="toggleGearInput()">
                <option value="FREE" ${board.category == 'FREE' ? 'selected' : ''}>掲示板</option>
                <option value="GEAR" ${board.category == 'GEAR' ? 'selected' : ''}>ギアおすすめ</option>
                <option value="REVIEW" ${board.category == 'REVIEW' ? 'selected' : ''}>レビュー</option>
            </select>
        </div>

        <div class="mb-3" id="gearInputArea" style="display: none;">
            <label class="form-label fw-bold">ギア名</label>
            <input type="text" name="gearName" class="form-control" value="${board.gearName}" placeholder="おすすめするギア名を入力してください">
        </div>

        <div class="mb-3">
            <label class="form-label fw-bold">タイトル</label>
            <input type="text" name="title" class="form-control" value="${board.title}" placeholder="タイトルを入力してください" required>
        </div>

        <div class="mb-3">
            <label class="form-label fw-bold">内容</label>
            <textarea name="content" class="form-control" rows="10" placeholder="内容を入力してください" required>${board.content}</textarea>
        </div>

        <div class="mb-3">
            <label class="form-label fw-bold">添付ファイル</label>
            <input type="file" name="files" class="form-control" multiple>
        </div>

        <div class="d-flex justify-content-end gap-2 mt-4">
            <a href="/community/list" class="btn btn-secondary">キャンセル</a>
            <button type="submit" class="btn btn-primary fw-bold">${empty board ? '投稿する' : '更新する'}</button>
        </div>
    </form>
</div>

<script>
function toggleGearInput() {
    var category = document.getElementById('categorySelect').value;
    var gearArea = document.getElementById('gearInputArea');
    if (category === 'GEAR') {
        gearArea.style.display = 'block';
    } else {
        gearArea.style.display = 'none';
    }
}
window.onload = toggleGearInput;
</script>
</body>
</html>