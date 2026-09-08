<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>目撃通報管理 - KUMANO_MAE ADMIN</title>

<!-- Bootstrap 5 CDN & Fonts & Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">

<!-- 프로젝트 공통 CSS & 어드민 전용 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/admin/list.css">
</head>
<body>

<div class="admin-wrapper">
    <!-- ===================== 관리자 사이드바 ===================== -->
    <aside class="admin-sidebar">
        <div class="admin-brand d-flex align-items-center">
            <div class="logo-badge me-2">熊</div>
            <div class="brand-jp">
                <div class="jp-title text-white">管理システム</div>
                <div class="jp-sub text-warning" style="font-size: 0.7rem;">KUMANO_MAE ADMIN</div>
            </div>
        </div>
        <nav class="mt-2">
            <a href="${pageContext.request.contextPath}/admin/main" class="admin-nav-link">
                <i class="bi bi-speedometer2 me-2"></i>ダッシュボード
            </a>
            <a href="${pageContext.request.contextPath}/admin/board/list" class="admin-nav-link active">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>目撃通報管理
            </a>
            <a href="${pageContext.request.contextPath}/admin/community/list" class="admin-nav-link">
                <i class="bi bi-chat-left-dots-fill me-2"></i>掲示板管理
            </a>
            <a href="${pageContext.request.contextPath}/admin/member/list" class="admin-nav-link">
                <i class="bi bi-people-fill me-2"></i>ユーザー管理
            </a>
            <a href="${pageContext.request.contextPath}/" class="admin-nav-link text-warning mt-4">
                <i class="bi bi-box-arrow-left me-2"></i>メインページへ
            </a>
        </nav>
    </aside>

    <!-- ===================== 메인 콘텐츠 영역 ===================== -->
    <main class="admin-content">
        <!-- 상단 타이틀 -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold m-0"><span class="dash">―</span>目撃通報管理</h2>
            <span class="badge bg-dark px-3 py-2">全 ${not empty boardList ? boardList.size() : 0} 件</span>
        </div>

        <!-- 1. 검색 및 필터 영역 -->
        <div class="stat-card mb-4">
            <form action="${pageContext.request.contextPath}/admin/board/list" method="get" class="row g-3 align-items-center">
                <div class="col-md-3">
                    <label class="form-label small fw-bold mb-1">承認ステータス</label>
                    <select name="status" class="form-select form-select-sm">
                        <option value="">すべて</option>
                        <option value="W" ${param.status eq 'W' ? 'selected' : ''}>承認待ち</option>
                        <option value="Y" ${param.status eq 'Y' ? 'selected' : ''}>承認済み</option>
                        <option value="N" ${param.status eq 'N' ? 'selected' : ''}>却下</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold mb-1">危険解除</label>
                    <select name="clearYn" class="form-select form-select-sm">
                        <option value="">すべて</option>
                        <option value="N" ${param.clearYn eq 'N' ? 'selected' : ''}>危険継続中</option>
                        <option value="Y" ${param.clearYn eq 'Y' ? 'selected' : ''}>解除済み</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label small fw-bold mb-1">検索</label>
                    <input type="text" name="keyword" value="${param.keyword}" class="form-control form-control-sm" placeholder="タイトルまたは位置情報">
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-jp-mustard btn-sm w-100 fw-bold">
                        <i class="bi bi-search me-1"></i> 検索
                    </button>
                </div>
            </form>
        </div>

        <!-- 2. 제보 목록 테이블 -->
        <div class="admin-table-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle text-center mb-0 admin-table">
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>危険度</th>
                            <th>タイトル / 位置</th>
                            <th>通報者</th>
                            <th>目撃日時</th>
                            <th>ステータス</th>
                            <th>危険状態</th>
                            <th>管理</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${not empty boardList}">
                                <c:forEach var="board" items="${boardList}">
                                    <tr>
                                        <td>${board.boardId}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${board.riskLevel eq 'DANGER'}"><span class="badge badge-danger-custom">危険</span></c:when>
                                                <c:when test="${board.riskLevel eq 'WARNING'}"><span class="badge badge-warning-custom">警戒</span></c:when>
                                                <c:otherwise><span class="badge badge-caution-custom">注意</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-start">
                                            <div class="fw-bold">${board.title}</div>
                                            <small class="text-muted"><i class="bi bi-geo-alt-fill"></i> ${board.address} (${board.latitude}, ${board.longitude})</small>
                                        </td>
                                        <td>${board.memberId}</td>
                                        <td>${board.sightingDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${board.status eq 'W'}"><span class="badge bg-warning text-dark">承認待ち</span></c:when>
                                                <c:when test="${board.status eq 'Y'}"><span class="badge bg-success">承認済み</span></c:when>
                                                <c:otherwise><span class="badge bg-danger">却下</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${board.clearYn eq 'Y'}"><span class="badge bg-secondary">解除済み</span></c:when>
                                                <c:otherwise><span class="badge bg-danger">継続中</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="d-flex justify-content-center gap-1">
                                                <c:if test="${board.status eq 'W'}">
                                                    <a href="${pageContext.request.contextPath}/admin/board/approve?boardId=${board.boardId}" class="btn btn-success btn-sm fw-bold">承認</a>
                                                    <a href="${pageContext.request.contextPath}/admin/board/reject?boardId=${board.boardId}" class="btn btn-danger btn-sm fw-bold">却下</a>
                                                </c:if>
                                                <c:if test="${board.status eq 'Y' and board.clearYn eq 'N'}">
                                                    <button type="button" class="btn btn-outline-dark btn-sm fw-bold" 
                                                            onclick="openClearModal('${board.boardId}', '${board.title}')">
                                                        危険解除
                                                    </button>
                                                </c:if>
                                                <a href="${pageContext.request.contextPath}/board/view?boardId=${board.boardId}" class="btn btn-jp-outline btn-sm">詳細</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- 백엔드 데이터 연결 전 프론트엔드 확인용 샘플 데이터 -->
                                <tr>
                                    <td>12</td>
                                    <td><span class="badge badge-danger-custom">危険</span></td>
                                    <td class="text-start">
                                        <div class="fw-bold">札幌近郊の登山道でクマを発見</div>
                                        <small class="text-muted"><i class="bi bi-geo-alt-fill"></i> 北海道札幌市 (43.06, 141.35)</small>
                                    </td>
                                    <td>user01</td>
                                    <td>2026-08-20 07:30</td>
                                    <td><span class="badge bg-warning text-dark">承認待ち</span></td>
                                    <td><span class="badge bg-danger">継続中</span></td>
                                    <td>
                                        <div class="d-flex justify-content-center gap-1">
                                            <a href="${pageContext.request.contextPath}/admin/board/approve?boardId=12" class="btn btn-success btn-sm fw-bold">承認</a>
                                            <a href="${pageContext.request.contextPath}/admin/board/reject?boardId=12" class="btn btn-danger btn-sm fw-bold">却下</a>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>11</td>
                                    <td><span class="badge badge-warning-custom">警戒</span></td>
                                    <td class="text-start">
                                        <div class="fw-bold">登山口付近での足跡目撃</div>
                                        <small class="text-muted"><i class="bi bi-geo-alt-fill"></i> 北海道旭川市 (43.77, 142.36)</small>
                                    </td>
                                    <td>kuma_hunter</td>
                                    <td>2026-08-19 18:10</td>
                                    <td><span class="badge bg-success">承認済み</span></td>
                                    <td><span class="badge bg-danger">継続中</span></td>
                                    <td>
                                        <button type="button" class="btn btn-outline-dark btn-sm fw-bold" 
                                                onclick="openClearModal('11', '登山口付近での足跡目撃')">
                                            危険解除
                                        </button>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<!-- ===================== 위험 해제 모달 ===================== -->
<div class="modal fade" id="clearModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content style-jp-modal" style="border: 3px solid #000;">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold"><i class="bi bi-shield-check me-2"></i>危険解除処理</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/board/clear" method="post">
                <div class="modal-body">
                    <input type="hidden" name="boardId" id="modalBoardId">
                    <p class="mb-2 fw-bold" id="modalBoardTitle"></p>
                    <p class="small text-muted mb-3">この通報の危険状態を解除し、マップ上のマーカーを安全表示に切り替えます。</p>
                    
                    <div class="mb-3">
                        <label for="clearMemo" class="form-label small fw-bold">解除理由 / メモ</label>
                        <textarea class="form-control" name="clearMemo" id="clearMemo" rows="3" placeholder="例：自治体による安全宣言を確認、または駆除完了"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary btn-sm" data-bs-dismiss="modal">キャンセル</button>
                    <button type="submit" class="btn btn-jp-mustard btn-sm fw-bold">解除実行</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openClearModal(boardId, title) {
        document.getElementById('modalBoardId').value = boardId;
        document.getElementById('modalBoardTitle').innerText = "対象: " + title;
        
        var clearModal = new bootstrap.Modal(document.getElementById('clearModal'));
        clearModal.show();
    }
</script>
</body>
</html>
