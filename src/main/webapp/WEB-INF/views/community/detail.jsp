<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${communityBoard.title}"/> - KUMANO_MAE</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/index.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/community/community.css">
</head>
<body>
    <%@ include file="/WEB-INF/views/includes/header.jsp"%>

    <c:set var="loginUser" value="${sessionScope.loginUser}"/>
    <c:set var="canManageBoard"
        value="${not empty loginUser and (communityBoard.memberId eq loginUser.memberId or loginUser.role eq 'ADMIN')}"/>

    <main class="container community-detail-container">
        <nav class="community-breadcrumb" aria-label="breadcrumb">
            <a href="${pageContext.request.contextPath}/community/list">コミュニティ</a>
            <i class="bi bi-chevron-right" aria-hidden="true"></i>
            <span>投稿詳細</span>
        </nav>

        <article class="community-detail-card">
            <header class="community-detail-header">
                <div class="mb-2">
                    <c:choose>
                        <c:when test="${communityBoard.category eq 'REVIEW'}"><span class="badge badge-cat-review">レビュー</span></c:when>
                        <c:when test="${communityBoard.category eq 'GEAR'}"><span class="badge badge-cat-gear">ギア</span></c:when>
                        <c:when test="${communityBoard.category eq 'FREE'}"><span class="badge badge-cat-board">自由掲示板</span></c:when>
                        <c:otherwise><span class="badge badge-cat-board"><c:out value="${communityBoard.category}"/></span></c:otherwise>
                    </c:choose>
                </div>

                <h1 class="community-detail-title"><c:out value="${communityBoard.title}"/></h1>
                <div class="community-detail-meta">
                    <div class="community-author-meta">
                        <span><i class="bi bi-person-circle" aria-hidden="true"></i> <c:out value="${communityBoard.memberId}"/></span>
                        <span><i class="bi bi-clock" aria-hidden="true"></i> <c:out value="${fn:replace(communityBoard.regDate, 'T', ' ')}"/></span>
                    </div>
                    <div class="community-count-meta">
                        <span><i class="bi bi-eye" aria-hidden="true"></i> <c:out value="${communityBoard.viewCnt}"/></span>
                        <span><i class="bi bi-heart" aria-hidden="true"></i> <span data-like-count><c:out value="${communityBoard.likeCnt}"/></span></span>
                    </div>
                </div>
            </header>

            <c:if test="${not empty communityBoard.gearName}">
                <div class="community-gear-box">
                    <i class="bi bi-bag-check-fill" aria-hidden="true"></i>
                    <div><strong>おすすめギア:</strong> <c:out value="${communityBoard.gearName}"/></div>
                </div>
            </c:if>

            <div class="community-detail-content"><c:out value="${communityBoard.content}"/></div>

            <c:if test="${not empty fileList}">
                <c:set var="hasAttachmentFile" value="false"/>
                <c:forEach var="file" items="${fileList}">
                    <c:set var="fileName" value="${fn:toLowerCase(file.originName)}"/>
                    <c:if test="${not (fn:endsWith(fileName, '.jpg') or fn:endsWith(fileName, '.jpeg') or fn:endsWith(fileName, '.png') or fn:endsWith(fileName, '.gif') or fn:endsWith(fileName, '.webp'))}">
                        <c:set var="hasAttachmentFile" value="true"/>
                    </c:if>
                </c:forEach>

                <div class="community-image-gallery" aria-label="添付画像">
                    <c:forEach var="file" items="${fileList}">
                        <c:set var="fileName" value="${fn:toLowerCase(file.originName)}"/>
                        <c:if test="${fn:endsWith(fileName, '.jpg') or fn:endsWith(fileName, '.jpeg') or fn:endsWith(fileName, '.png') or fn:endsWith(fileName, '.gif') or fn:endsWith(fileName, '.webp')}">
                            <c:url var="imageUrl" value="${file.filePath}/${file.saveName}"/>
                            <a href="${imageUrl}" target="_blank" rel="noopener">
                                <img src="${imageUrl}" alt="${fn:escapeXml(file.originName)}">
                            </a>
                        </c:if>
                    </c:forEach>
                </div>

                <c:if test="${hasAttachmentFile}">
                <section class="community-attachment-box" aria-labelledby="attachmentTitle">
                    <h2 id="attachmentTitle" class="community-attachment-title">
                        <i class="bi bi-paperclip" aria-hidden="true"></i> 添付ファイル
                    </h2>
                    <ul class="community-attachment-list">
                        <c:forEach var="file" items="${fileList}">
                            <c:set var="fileName" value="${fn:toLowerCase(file.originName)}"/>
                            <c:if test="${not (fn:endsWith(fileName, '.jpg') or fn:endsWith(fileName, '.jpeg') or fn:endsWith(fileName, '.png') or fn:endsWith(fileName, '.gif') or fn:endsWith(fileName, '.webp'))}">
                            <c:url var="downloadUrl" value="${file.filePath}/${file.saveName}"/>
                            <li>
                                <a href="${downloadUrl}" download="${fn:escapeXml(file.originName)}">
                                    <i class="bi bi-file-earmark-arrow-down" aria-hidden="true"></i>
                                    <c:out value="${file.originName}"/>
                                </a>
                            </li>
                            </c:if>
                        </c:forEach>
                    </ul>
                </section>
                </c:if>
            </c:if>

            <div class="community-detail-actions">
                <a href="${pageContext.request.contextPath}/community/list" class="btn btn-jp-outline">
                    <i class="bi bi-arrow-left" aria-hidden="true"></i> 一覧へ戻る
                </a>

                <div class="community-action-group">
                    <button type="button" id="communityLikeButton"
                        class="community-like-btn${liked ? ' active' : ''}"
                        data-board-id="${communityBoard.CBoardId}" aria-pressed="${liked}">
                        <i class="bi ${liked ? 'bi-heart-fill' : 'bi-heart'}" aria-hidden="true"></i>
                        <span>いいね</span>
                        <span>(<span data-like-count><c:out value="${communityBoard.likeCnt}"/></span>)</span>
                    </button>
                    <span id="likeStatus" class="visually-hidden" role="status" aria-live="polite"></span>

                    <c:if test="${canManageBoard}">
                        <c:url var="editUrl" value="/community/update">
                            <c:param name="cBoardId" value="${communityBoard.CBoardId}"/>
                        </c:url>
                        <a href="${editUrl}" class="btn btn-jp-mustard">編集</a>
                        <form action="${pageContext.request.contextPath}/community/delete" method="post" class="community-inline-form"
                            onsubmit="return confirm('本当に削除しますか？');">
                            <input type="hidden" name="cBoardId" value="${communityBoard.CBoardId}">
                            <button type="submit" class="btn btn-danger">削除</button>
                        </form>
                    </c:if>
                </div>
            </div>

            <section class="comment-section" aria-labelledby="commentTitle">
                <h2 id="commentTitle" class="comment-section-title">
                    <i class="bi bi-chat-dots" aria-hidden="true"></i> コメント
                </h2>

                <form action="${pageContext.request.contextPath}/community/comment/add" method="post" class="community-comment-form">
                    <input type="hidden" name="cBoardId" value="${communityBoard.CBoardId}">
                    <div class="community-comment-input">
                        <label for="commentContent" class="visually-hidden">コメント内容</label>
                        <textarea id="commentContent" name="content" class="form-control" rows="2"
                            placeholder="コメントを入力してください..." required></textarea>
                        <button type="submit" class="btn btn-jp-mustard fw-bold px-4">登録</button>
                    </div>
                </form>

                <div class="comment-list">
                    <c:forEach var="comment" items="${commentList}">
                        <article class="comment-item">
                            <div class="d-flex justify-content-between align-items-start">
                                <div class="comment-body">
                                    <div class="comment-author-line">
                                        <i class="bi bi-person-circle" aria-hidden="true"></i>
                                        <strong><c:out value="${comment.memberId}"/></strong>
                                        <time class="text-muted small"><c:out value="${fn:replace(comment.regDate, 'T', ' ')}"/></time>
                                    </div>
                                    <p class="comment-content"><c:out value="${comment.content}"/></p>
                                </div>

                                <c:if test="${not empty loginUser and (comment.memberId eq loginUser.memberId or loginUser.role eq 'ADMIN')}">
                                    <form action="${pageContext.request.contextPath}/community/comment/delete" method="post"
                                        class="community-inline-form ms-2" onsubmit="return confirm('コメントを削除しますか？');">
                                        <input type="hidden" name="cCommentId" value="${comment.CCommentId}">
                                        <button type="submit" class="btn btn-sm btn-link text-danger text-decoration-none p-0">削除</button>
                                    </form>
                                </c:if>
                            </div>
                        </article>
                    </c:forEach>

                    <c:if test="${empty commentList}">
                        <div class="comment-empty"><i class="bi bi-chat-square" aria-hidden="true"></i> コメントはまだありません。</div>
                    </c:if>
                </div>
            </section>
        </article>
    </main>

    <%@ include file="/WEB-INF/views/includes/footer.jsp"%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    (function() {
        'use strict';

        var likeButton = document.getElementById('communityLikeButton');
        var likeStatus = document.getElementById('likeStatus');

        if (!likeButton) {
            return;
        }

        likeButton.addEventListener('click', function() {
            if (likeButton.disabled) {
                return;
            }

            likeButton.disabled = true;

            fetch('${pageContext.request.contextPath}/api/community/like/toggle', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json'
                },
                body: JSON.stringify({ cBoardId: Number(likeButton.dataset.boardId) })
            })
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('HTTP ' + response.status);
                }
                return response.json();
            })
            .then(function(result) {
                var isLiked = result.liked === true;
                var icon = likeButton.querySelector('i');

                likeButton.classList.toggle('active', isLiked);
                likeButton.setAttribute('aria-pressed', String(isLiked));
                icon.classList.toggle('bi-heart-fill', isLiked);
                icon.classList.toggle('bi-heart', !isLiked);

                document.querySelectorAll('[data-like-count]').forEach(function(countElement) {
                    countElement.textContent = result.likeCnt;
                });
                likeStatus.textContent = isLiked ? 'いいねしました。' : 'いいねを取り消しました。';
            })
            .catch(function() {
                likeStatus.textContent = 'いいねの更新に失敗しました。';
                window.alert('いいねを更新できませんでした。しばらくしてからもう一度お試しください。');
            })
            .finally(function() {
                likeButton.disabled = false;
            });
        });
    }());
    </script>
</body>
</html>
