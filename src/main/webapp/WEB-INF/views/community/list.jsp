<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/index.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
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

        <div class="community-card table-responsive">
            <table class="table community-table">
                <thead>
                    <tr>
                        <th scope="col" class="community-title-column">タイトル</th>
                        <th scope="col">カテゴリ</th>
                        <th scope="col" class="community-number-column">閲覧数</th>
                        <th scope="col" class="community-number-column">いいね</th>
                        <th scope="col" class="community-date-column">投稿日</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="board" items="${communityList}">
                        <c:url var="detailUrl" value="/community/detail">
                            <c:param name="cBoardId" value="${board.CBoardId}"/>
                        </c:url>
                        <tr>
                            <td class="community-list-title"><a href="${detailUrl}"><c:out value="${board.title}"/></a></td>
                            <td>
                                <c:choose>
                                    <c:when test="${board.category eq 'REVIEW'}"><span class="badge badge-cat-review">レビュー</span></c:when>
                                    <c:when test="${board.category eq 'GEAR'}"><span class="badge badge-cat-gear">ギア</span></c:when>
                                    <c:when test="${board.category eq 'FREE'}"><span class="badge badge-cat-board">自由掲示板</span></c:when>
                                    <c:otherwise><span class="badge badge-cat-board"><c:out value="${board.category}"/></span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="community-number-column"><c:out value="${board.viewCnt}"/></td>
                            <td class="community-number-column"><c:out value="${board.likeCnt}"/></td>
                            <td class="community-date-column"><time><c:out value="${board.regDate}"/></time></td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty communityList}">
                        <tr>
                            <td colspan="5" class="community-table-empty">
                                <i class="bi bi-chat-square-dots" aria-hidden="true"></i>
                                <span>まだ投稿がありません。</span>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/includes/footer.jsp"%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
