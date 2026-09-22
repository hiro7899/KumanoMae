<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ニュース詳細 | 熊の前</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<link rel="stylesheet" href="/resources/css/index.css">
<link rel="stylesheet" href="/resources/css/includes/layout.css">
<link rel="stylesheet" href="/resources/css/board/news-detail.css">
</head>
<body class="news-detail-page">
<%@ include file="/WEB-INF/views/includes/header.jsp"%>

<main class="container py-5">
    <nav class="mb-4">
        <a href="/board/news">ニュース一覧</a> / ニュース詳細
    </nav>
    <article id="newsDetail" class="card card-jp p-4"></article>
</main>

<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
<script src="/resources/js/board/news-data.js"></script>
<script src="/resources/js/index.js"></script>
<script>
    function getNewsCategoryConfig(category) {
        var categoryConfig = {
            SIGHTING: { label: "出没情報", className: "badge-danger-custom" },
            SAFETY: { label: "安全対策", className: "badge-warning-custom" },
            OFFICIAL: { label: "自治体のお知らせ", className: "badge-caution-custom" }
        };

        return categoryConfig[category] || categoryConfig.SIGHTING;
    }

    function renderNewsDetail(news, detailBox) {
        var categoryConfig = getNewsCategoryConfig(news.category);
        var galleryHtml = news.images.map(function (imageUrl, index) {
            return '<img src="' + imageUrl + '" alt="' + newsEscape(news.title) + ' ' + (index + 1) + '" ' +
                'onerror="this.onerror=null;this.src=\'/resources/img/brand/kumano-mae-splash.png\';">';
        }).join('');

        detailBox.innerHTML =
            '<div class="news-detail-gallery">' + galleryHtml + '</div>' +
            '<div class="pt-4">' +
                '<span class="badge ' + categoryConfig.className + '">' + categoryConfig.label + '</span>' +
                '<h1 class="h2 fw-bold mt-3">' + newsEscape(news.title) + '</h1>' +
                '<p class="text-muted">' +
                    '<i class="bi bi-building"></i> ' + newsEscape(news.source) +
                    '　<i class="bi bi-clock-fill"></i> ' + news.date +
                    '　<i class="bi bi-geo-alt-fill"></i> ' + newsEscape(news.region) +
                '</p>' +
                '<p class="lead">' + newsEscape(news.summary) + '</p>' +
                '<div class="news-detail-content">' + newsEscape(news.content) + '</div>' +
                '<p class="small text-muted mt-4">出典：' + newsEscape(news.source) + '</p>' +
                '<a class="btn btn-jp-outline" href="/board/news">ニュース一覧に戻る</a>' +
            '</div>';
    }

    document.addEventListener("DOMContentLoaded", function () {
        var newsId = Number(new URLSearchParams(location.search).get("newsId"));
        var news = HARD_CODED_NEWS.find(function (item) {
            return item.id === newsId;
        });
        var detailBox = document.getElementById("newsDetail");

        if (!news) {
            detailBox.innerHTML = '<p class="text-muted">ニュースを見つけられませんでした。</p>';
            return;
        }

        document.title = news.title + " | 熊の前";
        renderNewsDetail(news, detailBox);
    });
</script>
</body>
</html>
