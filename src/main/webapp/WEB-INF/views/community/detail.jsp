<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>${board.title}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5" style="max-width: 800px;">
    <!-- 投稿ヘッダー -->
    <div class="border-bottom pb-3 mb-3">
        <span class="badge bg-primary fs-6 mb-2">
            <c:choose>
                <c:when test="${board.category eq 'FREE'}">掲示板</c:when>
                <c:when test="${board.category eq 'GEAR'}">ギアおすすめ</c:when>
                <c:when test="${board.category eq 'REVIEW'}">レビュー</c:when>
                <c:otherwise>${board.category}</c:otherwise>
            </c:choose>
        </span>
        <h3 class="fw-bold">${board.title}</h3>
        <div class="text-muted small d-flex justify-content-between mt-2">
            <span>投稿者: ${board.memberId} | 投稿日: <fmt:formatDate value="${board.regDate}" pattern="yyyy.MM.dd HH:mm"/></span>
            <span>閲覧数 ${board.viewCnt} | いいね ${board.likeCnt}</span>
        </div>
    </div>

    <!-- おすすめギア表示エリア (GEARカテゴリ時) -->
    <c:if test="${not empty board.gearName}">
        <div class="alert alert-info py-2 my-3">
            <strong>おすすめギア:</strong> ${board.gearName}
        </div>
    </c:if>

    <!-- 投稿本文 -->
    <div class="my-4 fs-6" style="min-height: 200px; white-space: pre-wrap; line-height: 1.6;">${board.content}</div>

    <!-- 添付ファイル一覧 -->
    <c:if test="${not empty fileList}">
        <div class="card mb-4">
            <div class="card-header bg-light fw-bold">添付ファイル</div>
            <ul class="list-group list-group-flush">
                <c:forEach var="file" items="${fileList}">
                    <li class="list-group-item">
                        <a href="${file.filePath}/${file.saveName}" download="${file.originName}" class="text-decoration-none">
                            📎 ${file.originName}
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </c:if>

    <!-- ボタンエリア -->
    <div class="d-flex justify-content-between align-items-center my-4">
        <a href="/community/list" class="btn btn-outline-secondary">一覧へ戻る</a>
        <div>
            <!-- いいねボタン -->
            <a href="/community/like?cBoardId=${board.cBoardId}" class="btn btn-outline-danger">
                ❤️ いいね (${board.likeCnt})
            </a>
            <!-- 投稿者本人の場合のみ表示 -->
            <c:if test="${sessionScope.loginMemberId eq board.memberId}">
                <a href="/community/edit?cBoardId=${board.cBoardId}" class="btn btn-warning ms-1">編集</a>
                <a href="/community/delete?cBoardId=${board.cBoardId}" class="btn btn-danger" onclick="return confirm('本当に削除しますか？');">削除</a>
            </c:if>
        </div>
    </div>

    <!-- コメントエリア -->
    <div class="card mt-5">
        <div class="card-header bg-light fw-bold">コメント</div>
        <div class="card-body">
            <!-- コメント投稿フォーム -->
            <form action="/community/comment/write" method="post" class="mb-4">
                <input type="hidden" name="cBoardId" value="${board.cBoardId}">
                <div class="input-group">
                    <textarea name="content" class="form-control" rows="2" placeholder="コメントを入力してください..." required></textarea>
                    <button type="submit" class="btn btn-primary fw-bold">登録</button>
                </div>
            </form>

            <!-- コメント一覧 -->
            <ul class="list-group list-group-flush">
                <c:forEach var="comment" items="${commentList}">
                    <li class="list-group-item d-flex justify-content-between align-items-start">
                        <div>
                            <strong class="me-2">${comment.memberId}</strong>
                            <span class="text-muted small"><fmt:formatDate value="${comment.regDate}" pattern="yyyy.MM.dd HH:mm"/></span>
                            <p class="mb-0 mt-1">${comment.content}</p>
                        </div>
                        <c:if test="${sessionScope.loginMemberId eq comment.memberId}">
                            <a href="/community/comment/delete?cCommentId=${comment.cCommentId}&cBoardId=${board.cBoardId}" 
                               class="btn btn-sm btn-outline-danger" onclick="return confirm('コメントを削除しますか？');">削除</a>
                        </c:if>
                    </li>
                </c:forEach>
                <c:if test="${empty commentList}">
                    <li class="list-group-item text-center text-muted py-3">コメントはまだありません。</li>
                </c:if>
            </ul>
        </div>
    </div>
</div>
</body>
</html>