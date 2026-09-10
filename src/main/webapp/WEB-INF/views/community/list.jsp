<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>コミュニティ - KUMANO_MAE</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/index.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/index.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/community/community.css">
</head>
<body>
    <%@ include file="/WEB-INF/views/includes/header.jsp"%>

    <c:url var="allCategoryUrl" value="/community/list">
        <c:param name="category" value="all"/>
    </c:url>
    <c:url var="reviewCategoryUrl" value="/community/list">
        <c:param name="category" value="REVIEW"/>
    </c:url>
    <c:url var="gearCategoryUrl" value="/community/list">
        <c:param name="category" value="GEAR"/>
    </c:url>
    <c:url var="freeCategoryUrl" value="/community/list">
        <c:param name="category" value="FREE"/>
    </c:url>

    <main class="container community-container">
        <div class="community-hero">
            <div class="community-hero-icon" aria-hidden="true"><i class="bi bi-people-fill"></i></div>
            <div>
                <span class="community-eyebrow">KUMANO_MAE COMMUNITY</span>
                <h1 class="community-title">コミュニティ</h1>
                <p class="community-lead mb-0">登山装備のおすすめやレビュー、山の情報をみんなで共有しましょう。</p>
            </div>
        </div>

        <div class="community-toolbar">
            <nav class="community-tabs" aria-label="投稿カテゴリ">
                <a href="${allCategoryUrl}" class="community-tab${empty currentCategory ? ' active' : ''}"
                    aria-current="${empty currentCategory ? 'page' : 'false'}">すべて</a>
                <a href="${reviewCategoryUrl}" class="community-tab${currentCategory eq 'REVIEW' ? ' active' : ''}"
                    aria-current="${currentCategory eq 'REVIEW' ? 'page' : 'false'}">レビュー</a>
                <a href="${gearCategoryUrl}" class="community-tab${currentCategory eq 'GEAR' ? ' active' : ''}"
                    aria-current="${currentCategory eq 'GEAR' ? 'page' : 'false'}">ギアおすすめ</a>
                <a href="${freeCategoryUrl}" class="community-tab${currentCategory eq 'FREE' ? ' active' : ''}"
                    aria-current="${currentCategory eq 'FREE' ? 'page' : 'false'}">掲示板</a>
            </nav>

            <a href="${pageContext.request.contextPath}/community/write" class="community-write-btn">
                <i class="bi bi-pencil-fill" aria-hidden="true"></i> 新規投稿
            </a>
        </div>

        <div class="row g-4 community-list-grid" id="communityCardGrid" data-pagination data-page-size="9">
            <c:forEach var="board" items="${communityList}">
                <c:url var="detailUrl" value="/community/detail">
                    <c:param name="cBoardId" value="${board.CBoardId}"/>
                </c:url>
                <div class="col-md-6 col-lg-4" data-page-item>
                    <article class="card h-100 report-card preview-card community-post-card clickable-card" data-card-href="${detailUrl}">
                        <c:choose>
                            <c:when test="${board.category eq 'GEAR'}"><div class="preview-card-image preview-card-image-gear"><i class="bi bi-backpack-fill"></i></div></c:when>
                            <c:when test="${board.category eq 'REVIEW'}"><div class="preview-card-image preview-card-image-trail"><i class="bi bi-map-fill"></i></div></c:when>
                            <c:otherwise><div class="preview-card-image preview-card-image-talk"><i class="bi bi-people-fill"></i></div></c:otherwise>
                        </c:choose>
                        <div class="card-body d-flex flex-column">
                            <c:choose>
                                <c:when test="${board.category eq 'REVIEW'}"><span class="badge badge-cat-review mb-2 align-self-start">レビュー</span></c:when>
                                <c:when test="${board.category eq 'GEAR'}"><span class="badge badge-cat-gear mb-2 align-self-start">ギア</span></c:when>
                                <c:otherwise><span class="badge badge-cat-board mb-2 align-self-start">自由掲示板</span></c:otherwise>
                            </c:choose>
                            <h5 class="card-title text-truncate fw-bold community-card-title"><c:out value="${board.title}"/></h5>
                            <p class="mb-2 text-muted small"><i class="bi bi-person-circle"></i> <c:out value="${board.writerName}"/></p>
                            <p class="small text-secondary flex-grow-1"><i class="bi bi-eye me-1"></i><c:out value="${board.viewCnt}"/> <span class="ms-2"><i class="bi bi-heart me-1"></i><c:out value="${board.likeCnt}"/></span> <span class="ms-2"><i class="bi bi-chat-square-text me-1"></i><c:out value="${board.commentCnt}"/></span></p>
                            <div class="d-flex justify-content-between align-items-center text-muted small border-top pt-2">
                                <time><i class="bi bi-clock me-1"></i><c:out value="${fn:substring(fn:replace(board.regDate, 'T', ' '), 0, 16)}"/></time>
                            </div>
                        </div>
                    </article>
                </div>
            </c:forEach>
            <c:if test="${empty communityList}">
                <div class="col-12">
                    <div class="card border-0 bg-light py-5 text-center community-table-empty">
                        <div class="card-body text-muted"><i class="bi bi-chat-square-dots fs-1 d-block mb-3"></i><span>まだ投稿がありません。</span></div>
                    </div>
                </div>
            </c:if>
        </div>
        <div class="client-pagination" data-pagination-controls="communityCardGrid" aria-label="ページ移動"></div>
    </main>

    <%@ include file="/WEB-INF/views/includes/footer.jsp"%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const grid = document.getElementById("communityCardGrid"), controls = document.querySelector('[data-pagination-controls="communityCardGrid"]'), items = Array.from(grid.querySelectorAll('[data-page-item]'));
            function render(page) { const total = Math.max(1, Math.ceil(items.length / 9)); page = Math.min(Math.max(page || 1, 1), total); items.forEach(i => i.classList.add('pagination-hidden')); items.slice((page - 1) * 9, page * 9).forEach(i => i.classList.remove('pagination-hidden')); controls.innerHTML = ''; for (let i = 1; i <= total; i++) { const b = document.createElement('button'); b.type = 'button'; b.className = 'client-page-button' + (i === page ? ' active' : ''); b.textContent = i; b.onclick = () => render(i); controls.appendChild(b); } }
            render(1);
            document.querySelectorAll('.clickable-card[data-card-href]').forEach(card => { card.setAttribute('tabindex', '0'); card.onclick = () => window.location.href = card.dataset.cardHref; card.onkeydown = e => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); window.location.href = card.dataset.cardHref; } }; });
        });
    </script>
</body>
</html>
