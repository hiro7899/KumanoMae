<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ダッシュボード - KUMANO_MAE ADMIN</title>

<!-- Bootstrap 5 CDN & Fonts & Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">

<!-- 프로젝트 공통 CSS & 어드민 CSS -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/main.css">
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
            <!-- 메인 대시보드 active -->
            <a href="${pageContext.request.contextPath}/admin/main" class="admin-nav-link active">
                <i class="bi bi-speedometer2 me-2"></i>ダッシュボード
            </a>
            <a href="${pageContext.request.contextPath}/admin/board/list" class="admin-nav-link">
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
            <h2 class="fw-bold m-0"><span class="dash">―</span>ダッシュボード</h2>
            <span class="small text-muted">最終更新: 2026-09-02</span>
        </div>

        <!-- 1. 현황 요약 카드 영역 -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="stat-card d-flex align-items-center justify-content-between p-3" style="background:#fff; border:2.5px solid #000; border-radius:12px;">
                    <div>
                        <div class="small text-muted fw-bold">承認待ち通報</div>
                        <div class="fs-3 fw-bold text-warning">${pendingCount != null ? pendingCount : 3} 件</div>
                    </div>
                    <i class="bi bi-hourglass-split fs-1 text-warning"></i>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card d-flex align-items-center justify-content-between p-3" style="background:#fff; border:2.5px solid #000; border-radius:12px;">
                    <div>
                        <div class="small text-muted fw-bold">危険継続中</div>
                        <div class="fs-3 fw-bold text-danger">${activeDangerCount != null ? activeDangerCount : 5} 件</div>
                    </div>
                    <i class="bi bi-exclamation-diamond-fill fs-1 text-danger"></i>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card d-flex align-items-center justify-content-between p-3" style="background:#fff; border:2.5px solid #000; border-radius:12px;">
                    <div>
                        <div class="small text-muted fw-bold">総コミュニティ投稿</div>
                        <div class="fs-3 fw-bold text-dark">${totalCommunityCount != null ? totalCommunityCount : 28} 件</div>
                    </div>
                    <i class="bi bi-chat-square-text-fill fs-1 text-secondary"></i>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card d-flex align-items-center justify-content-between p-3" style="background:#fff; border:2.5px solid #000; border-radius:12px;">
                    <div>
                        <div class="small text-muted fw-bold">総会員数</div>
                        <div class="fs-3 fw-bold text-primary">${totalMemberCount != null ? totalMemberCount : 14} 名</div>
                    </div>
                    <i class="bi bi-people-fill fs-1 text-primary"></i>
                </div>
            </div>
        </div>

        <!-- 2. 빠른 바로가기 카드 영역 -->
        <div class="row g-3">
            <div class="col-md-6">
                <div class="p-4" style="background:#fff; border:2.5px solid #000; border-radius:12px;">
                    <h4 class="fw-bold mb-3"><i class="bi bi-exclamation-triangle-fill text-warning me-2"></i>目撃通報の承認管理</h4>
                    <p class="text-muted small">ユーザーから届いた最新のクマ出没通報を確認・承認します。</p>
                    <a href="${pageContext.request.contextPath}/admin/board/list" class="btn btn-dark fw-bold btn-sm">通報一覧へ移動 →</a>
                </div>
            </div>
            <div class="col-md-6">
                <div class="p-4" style="background:#fff; border:2.5px solid #000; border-radius:12px;">
                    <h4 class="fw-bold mb-3"><i class="bi bi-chat-left-dots-fill text-success me-2"></i>コミュニティ掲示板管理</h4>
                    <p class="text-muted small">掲示板の不適切な投稿の非表示処理やお知らせの管理を行います。</p>
                    <a href="${pageContext.request.contextPath}/admin/community/list" class="btn btn-dark fw-bold btn-sm">掲示板一覧へ移動 →</a>
                </div>
            </div>
        </div>
    </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>