<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Community-KUMANO_MAE</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/main.css">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/index.css">

</head>
<body>
	<%@ include file="/WEB-INF/views/includes/header.jsp"%>
	<section class="container my-5">
    <h2 class="mb-4">最新ニュース</h2>

    <div class="row g-4">

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 report-card">
                <img src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=600"
                     class="card-img-top"
                     alt="クマ出没ニュース">

                <div class="card-body d-flex flex-column">
                    <span class="badge badge-danger-custom mb-2 align-self-start">
                        出没情報
                    </span>

                    <h5 class="card-title">
                        北海道でクマの目撃情報が相次ぐ
                    </h5>

                    <p class="mb-2 text-muted small">
                        <i class="bi bi-clock-fill"></i> 2026-09-01
                    </p>

                    <p class="small flex-grow-1">
                        北海道内でクマの目撃情報が相次いでいます。
                        登山や外出の際には十分ご注意ください。
                    </p>

                    <a href="#" class="btn btn-jp-outline btn-sm mt-2">
                        詳細を見る
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 report-card">
                <img src="https://images.unsplash.com/photo-1465311440653-ba9b1d9b5f04?w=600"
                     class="card-img-top"
                     alt="安全対策ニュース">

                <div class="card-body d-flex flex-column">
                    <span class="badge badge-warning-custom mb-2 align-self-start">
                        安全対策
                    </span>

                    <h5 class="card-title">
                        秋の登山シーズンに向けた安全対策
                    </h5>

                    <p class="mb-2 text-muted small">
                        <i class="bi bi-clock-fill"></i> 2026-08-30
                    </p>

                    <p class="small flex-grow-1">
                        入山前に出没情報を確認し、熊鈴などの装備を準備しましょう。
                    </p>

                    <a href="#" class="btn btn-jp-outline btn-sm mt-2">
                        詳細を見る
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-4">
            <div class="card h-100 report-card">
                <img src="https://images.unsplash.com/photo-1500534623283-312aade485b2?w=600"
                     class="card-img-top"
                     alt="自治体お知らせ">

                <div class="card-body d-flex flex-column">
                    <span class="badge badge-caution-custom mb-2 align-self-start">
                        自治体のお知らせ
                    </span>

                    <h5 class="card-title">
                        札幌市が注意喚起を発表
                    </h5>

                    <p class="mb-2 text-muted small">
                        <i class="bi bi-clock-fill"></i> 2026-08-28
                    </p>

                    <p class="small flex-grow-1">
                        市内の山間部周辺ではクマの活動が確認されています。
                    </p>

                    <a href="#" class="btn btn-jp-outline btn-sm mt-2">
                        詳細を見る
                    </a>
                </div>
            </div>
        </div>

    </div>

</section>
	<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>