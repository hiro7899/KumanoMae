<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty board ? '新規投稿' : '投稿の編集'} - KUMANO_MAE</title>

    <!-- Bootstrap 5 CDN & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- 일본어 폰트 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">

    <!-- 커스텀 CSS 파일들 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/community/community.css">
</head>
<body>
    <!-- 공통 헤더 INCLUDE -->
    <%@ include file="/WEB-INF/views/includes/header.jsp"%>

    <main class="container community-write-container">
        <nav class="community-breadcrumb" aria-label="breadcrumb">
            <a href="${pageContext.request.contextPath}/community/list">コミュニティ</a>
            <i class="bi bi-chevron-right" aria-hidden="true"></i>
            <span>${empty board ? '新規投稿' : '投稿の編集'}</span>
        </nav>
        
        <!-- 타이틀 영역 -->
        <div class="community-write-header">
            <span class="community-eyebrow">WRITE A POST</span>
            <h1>${empty board ? '新規投稿' : '投稿の編集'}</h1>
            <p>${empty board ? '山の情報やおすすめをコミュニティで共有しましょう。' : '投稿内容を確認して更新してください。'}</p>
        </div>

        <!-- 폼 카드 영역 -->
        <div class="community-form-card">
            <form action="${pageContext.request.contextPath}${empty board ? '/community/write' : '/community/edit'}" 
                  method="post" enctype="multipart/form-data">
                
                <c:if test="${not empty board}">
                    <input type="hidden" name="cBoardId" value="${board.cBoardId}">
                </c:if>

                <!-- 카테고리 선택 -->
                <fieldset class="community-form-group">
                    <legend class="community-form-label">カテゴリ <span>*</span></legend>
                    <div class="community-category-grid">
                        <label class="community-category-option">
                            <input type="radio" name="category" value="FREE"
                                ${empty board or board.category == 'FREE' ? 'checked' : ''} required>
                            <span><i class="bi bi-chat-square-text"></i><strong>自由掲示板</strong><small>自由な話題や情報交換</small></span>
                        </label>
                        <label class="community-category-option">
                            <input type="radio" name="category" value="GEAR"
                                ${board.category == 'GEAR' ? 'checked' : ''}>
                            <span><i class="bi bi-backpack2"></i><strong>ギアおすすめ</strong><small>愛用している装備を紹介</small></span>
                        </label>
                        <label class="community-category-option">
                            <input type="radio" name="category" value="REVIEW"
                                ${board.category == 'REVIEW' ? 'checked' : ''}>
                            <span><i class="bi bi-signpost-split"></i><strong>登山レビュー</strong><small>山行の記録や感想</small></span>
                        </label>
                    </div>
                </fieldset>

                <!-- 장비명 입력 (GEAR 선택 시 동적 표시) -->
                <div class="community-form-group" id="gearInputArea" hidden>
                    <label class="community-form-label" for="gearName">ギア名 <em>任意</em></label>
                    <input type="text" id="gearName" name="gearName" class="form-control" value="${board.gearName}" placeholder="おすすめするギア名を入力してください">
                    <p class="community-field-help">メーカー名や製品名を入力すると、ほかのユーザーが見つけやすくなります。</p>
                </div>

                <!-- 제목 -->
                <div class="community-form-group">
                    <div class="community-label-row">
                        <label class="community-form-label" for="postTitle">タイトル <span>*</span></label>
                        <small id="titleCount">0文字</small>
                    </div>
                    <input type="text" id="postTitle" name="title" class="form-control" value="${board.title}" placeholder="内容が伝わるタイトルを入力してください" required>
                </div>

                <!-- 내용 -->
                <div class="community-form-group">
                    <div class="community-label-row">
                        <label class="community-form-label" for="postContent">内容 <span>*</span></label>
                        <small id="contentCount">0文字</small>
                    </div>
                    <textarea id="postContent" name="content" class="form-control" rows="11" placeholder="共有したい内容を入力してください" required>${board.content}</textarea>
                </div>

                <!-- 첨부파일 -->
                <div class="community-form-group">
                    <label class="community-form-label" for="postFiles">添付ファイル <em>任意</em></label>
                    <label class="community-file-box" for="postFiles">
                        <i class="bi bi-cloud-arrow-up"></i>
                        <strong>画像やファイルを選択</strong>
                        <small>複数のファイルをまとめて選択できます</small>
                    </label>
                    <input type="file" id="postFiles" name="files" class="visually-hidden" multiple>
                    <div id="selectedFiles" class="community-selected-files" aria-live="polite"></div>
                </div>

                <!-- 버튼 영역 -->
                <div class="community-form-actions">
                    <a href="${pageContext.request.contextPath}/community/list" class="btn btn-jp-outline">キャンセル</a>
                    <button type="submit" class="btn btn-jp-mustard fw-bold">
                        <i class="bi bi-check-lg"></i> ${empty board ? '投稿する' : '更新する'}
                    </button>
                </div>
            </form>
        </div>
    </main>

    <!-- 공통 푸터 INCLUDE -->
    <%@ include file="/WEB-INF/views/includes/footer.jsp"%>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    function toggleGearInput() {
        var selectedCategory = document.querySelector('input[name="category"]:checked');
        var gearArea = document.getElementById('gearInputArea');
        gearArea.hidden = !selectedCategory || selectedCategory.value !== 'GEAR';
    }

    function updateCharacterCount(inputId, counterId) {
        var input = document.getElementById(inputId);
        var counter = document.getElementById(counterId);
        counter.textContent = input.value.length + '文字';
    }

    document.querySelectorAll('input[name="category"]').forEach(function(input) {
        input.addEventListener('change', toggleGearInput);
    });

    document.getElementById('postTitle').addEventListener('input', function() {
        updateCharacterCount('postTitle', 'titleCount');
    });

    document.getElementById('postContent').addEventListener('input', function() {
        updateCharacterCount('postContent', 'contentCount');
    });

    document.getElementById('postFiles').addEventListener('change', function() {
        var selectedFiles = document.getElementById('selectedFiles');
        selectedFiles.textContent = this.files.length
            ? Array.from(this.files).map(function(file) { return file.name; }).join(' · ')
            : '';
    });

    toggleGearInput();
    updateCharacterCount('postTitle', 'titleCount');
    updateCharacterCount('postContent', 'contentCount');
    </script>
</body>
</html>
