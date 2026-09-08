<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>新規投稿 - KUMANO_MAE</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/index.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/community/community.css">
    <!-- Bootstrap 5 CDN & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <!-- 일본어 폰트 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">

    <!-- 커스텀 CSS 파일들 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/index.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/community/community.css">
</head>
<body>
    <%@ include file="/WEB-INF/views/includes/header.jsp"%>

    <main class="container community-write-container">
        <nav class="community-breadcrumb" aria-label="breadcrumb">
            <a href="${pageContext.request.contextPath}/community/list">コミュニティ</a>
            <i class="bi bi-chevron-right" aria-hidden="true"></i>
            <span>新規投稿</span>
        </nav>

        <header class="community-write-header">
            <span class="community-eyebrow">WRITE A POST</span>
            <h1>新規投稿</h1>
            <p>山の情報やおすすめをコミュニティで共有しましょう。</p>
        </header>

        <div class="community-form-card">
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger d-flex align-items-center gap-2" role="alert">
                    <i class="bi bi-exclamation-triangle-fill" aria-hidden="true"></i>
                    <span><c:out value="${errorMsg}"/></span>
                </div>
            </c:if>

            <form id="communityWriteForm" action="${pageContext.request.contextPath}/community/write"
                method="post" enctype="multipart/form-data">
                <div class="community-form-group">
                    <label class="community-form-label" for="category">カテゴリ <span>*</span></label>
                    <select id="category" name="category" class="form-select" required>
                        <option value="" disabled ${empty param.category ? 'selected' : ''}>カテゴリを選択してください</option>
                        <option value="REVIEW" ${param.category eq 'REVIEW' ? 'selected' : ''}>REVIEW</option>
                        <option value="GEAR" ${param.category eq 'GEAR' ? 'selected' : ''}>GEAR</option>
                        <option value="FREE" ${param.category eq 'FREE' ? 'selected' : ''}>FREE</option>
                    </select>
                </div>

                <div class="community-form-group">
                    <label class="community-form-label" for="postTitle">タイトル <span>*</span></label>
                    <input type="text" id="postTitle" name="title" class="form-control"
                        value="${fn:escapeXml(param.title)}" placeholder="内容が伝わるタイトルを入力してください" required>
                </div>

                <div class="community-form-group">
                    <label class="community-form-label" for="postContent">内容 <span>*</span></label>
                    <textarea id="postContent" name="content" class="form-control" rows="11"
                        placeholder="共有したい内容を入力してください" required><c:out value="${param.content}"/></textarea>
                </div>

                <div class="community-form-group">
                    <label class="community-form-label" for="gearName">ギア名 <em>任意</em></label>
                    <input type="text" id="gearName" name="gearName" class="form-control"
                        value="${fn:escapeXml(param.gearName)}" placeholder="おすすめするギア名を入力してください">
                </div>

                <div class="community-form-group">
                    <label class="community-form-label" for="photoFile">写真 <em>任意・最大5枚</em></label>
                    <label class="community-file-box" for="photoFile">
                        <i class="bi bi-cloud-arrow-up" aria-hidden="true"></i>
                        <strong>写真を選択</strong>
                        <small>一度に最大5枚まで選択できます</small>
                    </label>
                    <input type="file" id="photoFile" name="photoFile" class="visually-hidden" accept="image/*" multiple>
                    <div id="selectedFiles" class="community-selected-files" aria-live="polite"></div>
                </div>

                <div class="community-form-actions">
                    <a href="${pageContext.request.contextPath}/community/list" class="btn btn-jp-outline">キャンセル</a>
                    <button type="submit" class="btn btn-jp-mustard fw-bold">
                        <i class="bi bi-check-lg" aria-hidden="true"></i> 投稿する
                    </button>
                </div>
            </form>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/includes/footer.jsp"%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    (function() {
        'use strict';

        var form = document.getElementById('communityWriteForm');
        var fileInput = document.getElementById('photoFile');
        var selectedFiles = document.getElementById('selectedFiles');
        var maxFileCount = 5;

        function renderSelectedFiles() {
            if (fileInput.files.length > maxFileCount) {
                fileInput.value = '';
                selectedFiles.textContent = '写真は最大' + maxFileCount + '枚まで選択できます。';
                return false;
            }

            selectedFiles.textContent = fileInput.files.length
                ? Array.from(fileInput.files).map(function(file) { return file.name; }).join(' · ')
                : '';
            return true;
        }

        fileInput.addEventListener('change', renderSelectedFiles);
        form.addEventListener('submit', function(event) {
            if (!renderSelectedFiles()) {
                event.preventDefault();
            }
        });
    }());
    </script>
</body>
</html>
