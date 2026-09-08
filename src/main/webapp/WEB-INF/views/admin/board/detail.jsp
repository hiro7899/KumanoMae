<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>目撃通報詳細管理 - KUMANO_MAE ADMIN</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/list.css">
</head>
<body>
    <div class="admin-wrapper">
        <aside class="admin-sidebar">
            <div class="admin-brand d-flex align-items-center">
                <div class="logo-badge me-2">熊</div>
                <div class="brand-jp">
                    <div class="jp-title text-white">管理システム</div>
                    <div class="jp-sub text-warning" style="font-size: 0.7rem;">KUMANO_MAE ADMIN</div>
                </div>
            </div>
            <nav class="mt-2">
                <a href="${pageContext.request.contextPath}/admin/main" class="admin-nav-link"><i class="bi bi-speedometer2 me-2"></i>ダッシュボード</a>
                <a href="${pageContext.request.contextPath}/admin/board/list" class="admin-nav-link active"><i class="bi bi-exclamation-triangle-fill me-2"></i>目撃通報管理</a>
                <a href="${pageContext.request.contextPath}/admin/community/list" class="admin-nav-link"><i class="bi bi-chat-left-dots-fill me-2"></i>掲示板管理</a>
                <a href="${pageContext.request.contextPath}/admin/member/list" class="admin-nav-link"><i class="bi bi-people-fill me-2"></i>ユーザー管理</a>
                <a href="${pageContext.request.contextPath}/" class="admin-nav-link text-warning mt-4"><i class="bi bi-box-arrow-left me-2"></i>メインページへ</a>
            </nav>
        </aside>

        <main class="admin-content">
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger d-flex align-items-center gap-2" role="alert">
                    <i class="bi bi-exclamation-triangle-fill" aria-hidden="true"></i>
                    <span><c:out value="${errorMsg}"/></span>
                </div>
            </c:if>

            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold m-0"><span class="dash">―</span>目撃通報詳細管理</h2>
                <a href="${pageContext.request.contextPath}/admin/board/list" class="btn btn-outline-secondary btn-sm"><i class="bi bi-arrow-left me-1" aria-hidden="true"></i> 一覧へ戻る</a>
            </div>

            <c:choose>
                <c:when test="${empty board}">
                    <div class="stat-card text-center text-muted py-5"><i class="bi bi-inbox fs-2 d-block mb-2" aria-hidden="true"></i>目撃通報を読み込めませんでした。</div>
                </c:when>
                <c:otherwise>
                    <section class="stat-card mb-4">
                        <div class="d-flex justify-content-between align-items-start gap-3 border-bottom pb-3 mb-3">
                            <div>
                                <c:choose>
                                    <c:when test="${board.riskLevel eq 'DANGER'}"><span class="badge bg-danger mb-2">危険</span></c:when>
                                    <c:when test="${board.riskLevel eq 'WARNING'}"><span class="badge bg-warning text-dark mb-2">警戒</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary mb-2">注意</span></c:otherwise>
                                </c:choose>
                                <h3 class="fw-bold m-0"><c:out value="${board.title}"/></h3>
                            </div>
                            <div class="text-end">
                                <c:choose>
                                    <c:when test="${board.status eq 'W'}"><span class="badge bg-warning text-dark">承認待ち</span></c:when>
                                    <c:when test="${board.status eq 'Y'}"><span class="badge bg-success">承認済み</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary">却下</span></c:otherwise>
                                </c:choose>
                                <c:if test="${board.clearYn eq 'Y'}"><span class="badge bg-dark ms-1">危険解除済み</span></c:if>
                            </div>
                        </div>

                        <div class="row g-3 text-muted small mb-4">
                            <div class="col-md-3"><strong>通報番号:</strong> <c:out value="${board.boardId}"/></div>
                            <div class="col-md-3"><strong>投稿者:</strong> <c:out value="${board.memberId}"/></div>
                            <div class="col-md-3"><strong>目撃日時:</strong> <c:out value="${board.sightingDate}"/></div>
                            <div class="col-md-3"><strong>閲覧数:</strong> <c:out value="${board.viewCnt}"/></div>
                            <div class="col-md-6"><strong>住所:</strong> <c:out value="${not empty board.address ? board.address : '住所情報なし'}"/></div>
                            <div class="col-md-6"><strong>座標:</strong> <c:out value="${board.latitude}"/>, <c:out value="${board.longitude}"/></div>
                        </div>

                        <c:if test="${not empty board.situationTag}">
                            <div class="alert alert-light border py-2 mb-3"><strong><i class="bi bi-signpost-split-fill me-1" aria-hidden="true"></i> 当時の状況:</strong> <c:out value="${board.situationTag}"/></div>
                        </c:if>

                        <section class="mb-4" aria-labelledby="reportContentTitle">
                            <h4 id="reportContentTitle" class="h6 fw-bold">通報内容</h4>
                            <div class="bg-light rounded p-3" style="min-height: 140px; white-space: pre-wrap;"><c:out value="${board.content}"/></div>
                        </section>

                        <section aria-labelledby="attachmentTitle">
                            <h4 id="attachmentTitle" class="h6 fw-bold"><i class="bi bi-paperclip me-1" aria-hidden="true"></i> 添付写真 (<c:out value="${not empty fileList ? fileList.size() : 0}"/>件)</h4>
                            <c:choose>
                                <c:when test="${not empty fileList}">
                                    <div class="row g-3">
                                        <c:forEach var="file" items="${fileList}">
                                            <c:url var="imageUrl" value="${file.filePath}/${file.saveName}"/>
                                            <div class="col-md-4">
                                                <a href="${imageUrl}" target="_blank" rel="noopener" class="d-block border rounded overflow-hidden bg-light">
                                                    <img src="${imageUrl}" alt="<c:out value='${file.originName}'/>" class="img-fluid w-100" style="height: 180px; object-fit: cover;">
                                                </a>
                                                <p class="small text-muted text-truncate mt-1 mb-0"><c:out value="${file.originName}"/></p>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise><p class="text-muted small mb-0">添付写真はありません。</p></c:otherwise>
                            </c:choose>
                        </section>

                        <div class="d-flex justify-content-end flex-wrap gap-2 mt-4 pt-3 border-top">
                            <c:if test="${board.status eq 'W'}">
                                <form action="${pageContext.request.contextPath}/admin/board/approve" method="post" onsubmit="return confirm('この通報を承認しますか？');">
                                    <input type="hidden" name="boardId" value="${board.boardId}">
                                    <button type="submit" class="btn btn-success btn-sm fw-bold">承認</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin/board/reject" method="post" onsubmit="return confirm('この通報を却下しますか？');">
                                    <input type="hidden" name="boardId" value="${board.boardId}">
                                    <button type="submit" class="btn btn-danger btn-sm fw-bold">却下</button>
                                </form>
                            </c:if>
                            <c:if test="${board.status eq 'Y' and board.clearYn eq 'N'}">
                                <button type="button" class="btn btn-outline-dark btn-sm fw-bold" data-bs-toggle="modal" data-bs-target="#clearModal">危険解除</button>
                            </c:if>
                        </div>
                    </section>

                    <c:if test="${board.status eq 'Y' and board.clearYn eq 'N'}">
                        <div class="modal fade" id="clearModal" tabindex="-1" aria-labelledby="clearModalTitle" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered">
                                <div class="modal-content" style="border: 2px solid #000;">
                                    <form action="${pageContext.request.contextPath}/admin/board/clear" method="post">
                                        <div class="modal-header bg-dark text-white">
                                            <h5 class="modal-title" id="clearModalTitle">危険解除処理</h5>
                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="閉じる"></button>
                                        </div>
                                        <div class="modal-body">
                                            <input type="hidden" name="boardId" value="${board.boardId}">
                                            <label for="clearMemo" class="form-label fw-bold">解除理由 / メモ</label>
                                            <textarea id="clearMemo" name="clearMemo" class="form-control" rows="3" placeholder="例：自治体による安全宣言を確認、または駆除完了" required></textarea>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">キャンセル</button>
                                            <button type="submit" class="btn btn-jp-mustard btn-sm fw-bold">解除を実行</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
