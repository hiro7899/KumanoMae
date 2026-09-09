<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><c:out value="${not empty board ? board.title : '目撃情報詳細'}"/> | クマ出没マップ</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/index.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board/view.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/index.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/board/view.css">
</head>
<body>
    <%@ include file="/WEB-INF/views/includes/header.jsp"%>

    <main class="board-detail-page">
        <div class="container py-4 py-lg-5">
            <nav aria-label="breadcrumb" class="detail-breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">ホーム</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/board/list">目撃情報一覧</a></li>
                    <li class="breadcrumb-item active" aria-current="page">目撃情報詳細</li>
                </ol>
            </nav>

            <c:choose>
                <c:when test="${empty board}">
                    <div class="alert alert-warning mt-4" role="alert">目撃情報を読み込めませんでした。</div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4 mt-1">
                        <div class="col-lg-8">
                            <article class="detail-card">
                                <header class="detail-header">
                                    <div class="d-flex justify-content-between align-items-start gap-3 mb-3">
                                        <c:choose>
                                            <c:when test="${board.riskLevel eq 'DANGER'}"><span class="risk-badge risk-danger"><i class="bi bi-exclamation-triangle-fill" aria-hidden="true"></i> 危険</span></c:when>
                                            <c:when test="${board.riskLevel eq 'WARNING'}"><span class="risk-badge bg-warning text-dark"><i class="bi bi-exclamation-triangle-fill" aria-hidden="true"></i> 警戒</span></c:when>
                                            <c:otherwise><span class="risk-badge bg-secondary text-white"><i class="bi bi-exclamation-circle-fill" aria-hidden="true"></i> 注意</span></c:otherwise>
                                        </c:choose>
                                        <span class="post-number">REPORT NO. <c:out value="${board.boardId}"/></span>
                                    </div>
                                    <h1><c:out value="${board.title}"/></h1>
                                    <div class="post-meta">
                                        <span><i class="bi bi-person-circle" aria-hidden="true"></i> 投稿者 #<c:out value="${board.memberId}"/></span>
                                        <span><i class="bi bi-calendar3" aria-hidden="true"></i> <c:out value="${board.sightingDate}"/></span>
                                        <span><i class="bi bi-eye" aria-hidden="true"></i> <c:out value="${board.viewCnt}"/></span>
                                    </div>
                                </header>

                                <section class="sighting-summary" aria-label="目撃情報の概要">
                                    <div class="summary-item">
                                        <i class="bi bi-geo-alt-fill" aria-hidden="true"></i>
                                        <div><span>目撃場所</span><strong><c:out value="${not empty board.address ? board.address : '住所情報なし'}"/></strong></div>
                                    </div>
                                    <div class="summary-item">
                                        <i class="bi bi-clock-fill" aria-hidden="true"></i>
                                        <div><span>目撃日時</span><strong><c:out value="${board.sightingDate}"/></strong></div>
                                    </div>
                                    <div class="summary-item">
                                        <i class="bi bi-signpost-split-fill" aria-hidden="true"></i>
                                        <div><span>当時の状況</span><strong><c:out value="${not empty board.situationTag ? board.situationTag : '情報なし'}"/></strong></div>
                                    </div>
                                </section>

                                <section class="post-content">
                                    <p><c:out value="${board.content}"/></p>

                                    <c:forEach var="file" items="${fileList}" varStatus="status">
                                        <c:url var="imageUrl" value="${file.filePath}/${file.saveName}"/>
                                        <figure class="report-photo">
                                            <a href="${imageUrl}" target="_blank" rel="noopener">
                                                <img src="${imageUrl}" alt="${fn:escapeXml(file.originName)}">
                                            </a>
                                            <figcaption><i class="bi bi-image" aria-hidden="true"></i> 添付写真 <c:out value="${status.count}"/>枚目: <c:out value="${file.originName}"/></figcaption>
                                        </figure>
                                    </c:forEach>

                                    <c:if test="${empty fileList}">
                                        <p class="text-muted small mb-0"><i class="bi bi-image" aria-hidden="true"></i> 添付写真はありません。</p>
                                    </c:if>
                                </section>
                            </article>
                        </div>

                        <aside class="col-lg-4">
                            <div class="location-card">
                                <div class="location-card-head">
                                    <span><i class="bi bi-map-fill" aria-hidden="true"></i> 目撃位置</span>
                                    <c:choose>
                                        <c:when test="${board.clearYn eq 'Y'}"><span class="status-live">危険解除済み</span></c:when>
                                        <c:when test="${board.status eq 'Y'}"><span class="status-live">確認済み</span></c:when>
                                        <c:otherwise><span class="status-live">確認待ち</span></c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="map-preview" aria-hidden="true"><div class="map-grid"></div><div class="map-pin"><i class="bi bi-exclamation-lg"></i></div><span class="map-label">目撃地点</span></div>
                                <div class="location-card-body">
                                    <strong><c:out value="${not empty board.address ? board.address : '住所情報なし'}"/></strong>
                                    <p>緯度 <c:out value="${board.latitude}"/> / 経度 <c:out value="${board.longitude}"/></p>
                                    <a href="${pageContext.request.contextPath}/map" class="btn btn-jp-outline btn-sm w-100"><i class="bi bi-map" aria-hidden="true"></i> 地図で確認する</a>
                                </div>
                            </div>

                            <div class="safety-note mt-4">
                                <div class="safety-icon"><i class="bi bi-shield-fill-exclamation" aria-hidden="true"></i></div>
                                <div><h2>安全のために</h2><p>クマを見かけても近づかず、静かにその場を離れてください。</p></div>
                            </div>
                            <a href="${pageContext.request.contextPath}/board/list" class="back-to-list"><i class="bi bi-arrow-left" aria-hidden="true"></i> 一覧に戻る</a>
                        </aside>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/includes/footer.jsp"%>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
