<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>目撃情報を報告する - クマ出没マップ</title>

<!-- Bootstrap 5 CDN & Fonts & Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700;900&display=swap" rel="stylesheet">

<!-- 프로젝트 메인 CSS (index.jsp와 동일) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/index.css">

<style>
    /* index.jsp 고유 스타일 적용 */
    body {
        background-color: #f7f5ed; /* index.jsp의 크림 베이지 배경 */
        font-family: 'Noto Sans JP', sans-serif;
    }
    .report-container {
        max-width: 860px;
        margin: 50px auto 80px;
        padding: 0 15px;
    }
    .card-jp-form {
        background: #fff;
        border: 3px solid #000;
        border-radius: 12px;
        box-shadow: 6px 6px 0px #000;
        padding: 35px;
    }
    .section-title-jp {
        border-left: 6px solid #d35400;
        padding-left: 12px;
        font-weight: 900;
    }
    .form-label-jp {
        font-weight: 700;
        font-size: 0.95rem;
        color: #000;
    }
    .map-preview-box {
        width: 100%;
        height: 320px;
        background-color: #e9ecef;
        border: 2px solid #000;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    /* index.jsp 스타일의 머스타드 & 라인 버튼 */
    .btn-jp-mustard {
        background-color: #f39c12;
        color: #000;
        border: 2px solid #000;
        font-weight: 700;
        box-shadow: 3px 3px 0px #000;
        transition: all 0.15s ease-in-out;
    }
    .btn-jp-mustard:hover {
        background-color: #e67e22;
        color: #000;
        transform: translate(-1px, -1px);
        box-shadow: 4px 4px 0px #000;
    }
    .btn-jp-outline {
        background-color: #fff;
        color: #000;
        border: 2px solid #000;
        font-weight: 700;
        box-shadow: 3px 3px 0px #000;
    }
    .btn-jp-outline:hover {
        background-color: #f8f9fa;
        color: #000;
    }
    /* 상황 태그 체크박스 버튼 스타일 */
    .tag-check-label {
        border: 2px solid #000 !important;
        font-weight: 700 !important;
        border-radius: 6px !important;
        padding: 6px 14px !important;
        box-shadow: 2px 2px 0px #000;
    }
    .btn-check:checked + .tag-check-label {
        background-color: #000 !important;
        color: #fff !important;
    }
</style>
</head>
<body>

    <!-- 공통 상단 헤더 include -->
    <%@ include file="/WEB-INF/views/includes/header.jsp" %>

    <main class="report-container">
        <!-- 타이틀 영역 -->
        <div class="mb-4">
            <p class="hero-eyebrow mb-1"><span class="dash">―</span>目撃情報提供</p>
            <h2 class="section-title-jp m-0">クマ出没・目撃情報を報告する</h2>
            <p class="text-muted small mt-2">地域の safe（安全）のために目撃情報を共有してください。管理者承認後にマップに反映されます。</p>
        </div>

        <!-- 제보 Form 카드 -->
        <div class="card-jp-form">
            <form action="${pageContext.request.contextPath}/board/report" method="post" id="reportForm">
                
                <!-- 1. 제보 제목 (TITLE) -->
                <div class="mb-4">
                    <label for="title" class="form-label form-label-jp">通報タイトル <span class="text-danger">*</span></label>
                    <input type="text" class="form-control form-control-lg border-2 border-dark" id="title" name="title" placeholder="例：札幌近郊の登山道でクマを発見" required>
                </div>

                <!-- 2. 위험도 (RISK_LEVEL) -->
                <div class="mb-4">
                    <label class="form-label form-label-jp">危険度区分 <span class="text-danger">*</span></label>
                    <div class="d-flex gap-4 p-3 bg-light border border-2 border-dark rounded">
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="riskLevel" id="riskDanger" value="DANGER" checked>
                            <label class="form-check-label text-danger fw-bold" for="riskDanger">
                                <i class="bi bi-exclamation-octagon-fill me-1"></i> 危険 (DANGER)
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="riskLevel" id="riskWarning" value="WARNING">
                            <label class="form-check-label text-warning-emphasis fw-bold" for="riskWarning">
                                <i class="bi bi-exclamation-triangle-fill me-1"></i> 警戒 (WARNING)
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="riskLevel" id="riskCaution" value="CAUTION">
                            <label class="form-check-label text-primary fw-bold" for="riskCaution">
                                <i class="bi bi-info-circle-fill me-1"></i> 注意 (CAUTION)
                            </label>
                        </div>
                    </div>
                </div>

                <!-- 3. 목격 일시 (SIGHTING_DATE) -->
                <div class="mb-4">
                    <label for="sightingDate" class="form-label form-label-jp">目撃日時 <span class="text-danger">*</span></label>
                    <input type="datetime-local" class="form-control border-2 border-dark" id="sightingDate" name="sightingDate" required>
                </div>

                <!-- 4. 위치 선택 및 지도 (LATITUDE, LONGITUDE, ADDRESS) -->
                <div class="mb-4">
                    <label class="form-label form-label-jp">目撃位置の指定 <span class="text-danger">*</span></label>
                    <p class="small text-muted mb-2">マップをクリックして正確な目撃場所を指定してください。</p>
                    
                    <!-- 지도 API 영역 -->
                    <div id="map" class="map-preview-box mb-2">
                        <span class="fw-bold text-muted"><i class="bi bi-geo-alt-fill fs-3 d-block text-center mb-1"></i>地図読み込み中...</span>
                    </div>

                    <div class="row g-2">
                        <div class="col-md-6">
                            <input type="text" class="form-control form-control-sm border-2 border-dark bg-light" id="address" name="address" placeholder="自動変換住所" readonly required>
                        </div>
                        <div class="col-md-3">
                            <input type="text" class="form-control form-control-sm border-2 border-dark bg-light" id="latitude" name="latitude" placeholder="緯度 (Latitude)" readonly required>
                        </div>
                        <div class="col-md-3">
                            <input type="text" class="form-control form-control-sm border-2 border-dark bg-light" id="longitude" name="longitude" placeholder="経度 (Longitude)" readonly required>
                        </div>
                    </div>
                </div>

                <!-- 5. 상황 태그 (SITUATION_TAG) -->
                <div class="mb-4">
                    <label class="form-label form-label-jp">状況タグ (複数選択可)</label>
                    <div class="d-flex flex-wrap gap-2">
                        <input type="checkbox" class="btn-check" id="tag1" value="足跡" onchange="updateTags()">
                        <label class="btn btn-outline-dark tag-check-label" for="tag1"># 足跡</label>

                        <input type="checkbox" class="btn-check" id="tag2" value="糞" onchange="updateTags()">
                        <label class="btn btn-outline-dark tag-check-label" for="tag2"># 糞</label>

                        <input type="checkbox" class="btn-check" id="tag3" value="威嚇音" onchange="updateTags()">
                        <label class="btn btn-outline-dark tag-check-label" for="tag3"># 威嚇音</label>

                        <input type="checkbox" class="btn-check" id="tag4" value="成獣" onchange="updateTags()">
                        <label class="btn btn-outline-dark tag-check-label" for="tag4"># 成獣</label>

                        <input type="checkbox" class="btn-check" id="tag5" value="親仔" onchange="updateTags()">
                        <label class="btn btn-outline-dark tag-check-label" for="tag5"># 親仔</label>
                    </div>
                    <!-- 실제 DB로 전송되는 히든 필드 -->
                    <input type="hidden" id="situationTag" name="situationTag">
                </div>

                <!-- 6. 상세 내용 (CONTENT - CLOB) -->
                <div class="mb-5">
                    <label for="content" class="form-label form-label-jp">詳細内容 <span class="text-danger">*</span></label>
                    <textarea class="form-control border-2 border-dark" id="content" name="content" rows="5" placeholder="クマの移動方向、大きさ、当時の状況などを詳細に入力してください。" required></textarea>
                </div>

                <!-- 하단 버튼 영역 -->
                <div class="d-flex justify-content-between align-items-center pt-3 border-top border-2">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-jp-outline px-4">キャンセル</a>
                    <button type="submit" class="btn btn-jp-mustard btn-lg px-5">報告を送信する →</button>
                </div>
            </form>
        </div>
    </main>

    <!-- Footer Include -->
    <footer class="footer-jp pt-5 pb-3">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="d-flex align-items-center mb-3">
                        <div class="logo-badge me-2">熊</div>
                        <div class="brand-jp">
                            <div class="jp-title">クマ出没マップ</div>
                        </div>
                    </div>
                    <p class="small footer-muted">
                        里山に近づく足音を見逃さない。<br>全国のクマ目撃情報をリアルタイムに共有するサービスです。
                    </p>
                </div>
                <div class="col-md-4 mb-4">
                    <h6 class="fw-bold mb-3 footer-heading">会社情報</h6>
                    <ul class="list-unstyled small footer-muted">
                        <li class="mb-2">株式会社ベアセーフ（BearSafe Inc.）</li>
                        <li class="mb-2"><i class="bi bi-telephone-fill me-2"></i>03-1234-5678</li>
                        <li class="mb-2"><i class="bi bi-geo-alt-fill me-2"></i>日本 北海道 札幌市 中央区 1-1-1</li>
                    </ul>
                </div>
                <div class="col-md-4 mb-4">
                    <h6 class="fw-bold mb-3 footer-heading">サイトマップ</h6>
                    <ul class="list-unstyled small">
                        <li class="mb-2"><a href="/map">出没マップ</a></li>
                        <li class="mb-2"><a href="#">目撃情報掲示板</a></li>
                        <li class="mb-2"><a href="/login">ログイン</a></li>
                        <li class="mb-2"><a href="/signup">会員登録</a></li>
                    </ul>
                </div>
            </div>
            <hr class="footer-divider">
            <div class="text-center small footer-copyright">&copy; 2026 BearSafe Inc. All Rights Reserved.</div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // 현재 시간을 datetime-local 기본값으로 설정
        document.getElementById('sightingDate').value = new Date().toISOString().slice(0, 16);

        // 상황 태그 콤마(,) 구분 업데이트 함수
        function updateTags() {
            const checkboxes = document.querySelectorAll('.btn-check:checked');
            const selectedTags = Array.from(checkboxes).map(cb => cb.value);
            document.getElementById('situationTag').value = selectedTags.join(',');
        }
    </script>
</body>
</html>