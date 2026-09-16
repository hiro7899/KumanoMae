<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>最新ニュース - 熊の前</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="/resources/css/includes/layout.css">
<link rel="stylesheet" href="/resources/css/index.css">
<link rel="stylesheet" href="/resources/css/community/community.css">
<link rel="stylesheet" href="/resources/css/board/preview-card.css">
</head>
<body>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>
<main class="container community-container">
  <div class="community-hero">
    <div class="community-hero-icon" aria-hidden="true"><i class="bi bi-newspaper"></i></div>
    <div><span class="community-eyebrow">KUMANO_MAE NEWS</span><h1 class="community-title">ニュース</h1><p class="community-lead mb-0">全国のクマ出没情報や自治体からのお知らせを確認できます。</p></div>
  </div>
  <div class="community-toolbar">
    <nav class="community-tabs" aria-label="ニュースカテゴリ">
      <button type="button" class="community-tab filter-btn active" data-category="all">すべて</button>
      <button type="button" class="community-tab filter-btn" data-category="SIGHTING">出没情報</button>
      <button type="button" class="community-tab filter-btn" data-category="SAFETY">安全対策</button>
      <button type="button" class="community-tab filter-btn" data-category="OFFICIAL">自治体のお知らせ</button>
    </nav>
  </div>
  <div id="newsCardGrid" class="row g-4 community-list-grid"></div>
  <div id="newsPagination" class="client-pagination" aria-label="ニュースページ移動"></div>
</main>
<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
<script src="/resources/js/board/news-data.js"></script>
<script src="/resources/js/index.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function () {
  var grid = document.getElementById('newsCardGrid');
  var pagination = document.getElementById('newsPagination');
  var pageSize = 9;
  var currentCategory = 'all';
  var currentPage = 1;

  function label(category) {
    return category === 'SAFETY' ? '安全対策' : category === 'OFFICIAL' ? '自治体のお知らせ' : '出没情報';
  }

  function badgeClass(category) {
    return category === 'SAFETY' ? 'badge-warning-custom' : category === 'OFFICIAL' ? 'badge-caution-custom' : 'badge-danger-custom';
  }

  function render() {
    var filtered = HARD_CODED_NEWS.filter(function (news) {
      return currentCategory === 'all' || news.category === currentCategory;
    });
    var totalPages = Math.max(1, Math.ceil(filtered.length / pageSize));
    currentPage = Math.min(currentPage, totalPages);
    var start = (currentPage - 1) * pageSize;
    var pageNews = filtered.slice(start, start + pageSize);

    grid.innerHTML = pageNews.map(function (news) {
      return '<div class="col-md-6 col-lg-4"><article class="card h-100 report-card preview-card community-post-card clickable-card" data-card-href="/board/news/detail?newsId=' + news.id + '" tabindex="0" role="link">'
        + '<div class="preview-card-image"><img src="' + newsImage(news) + '" class="preview-card-thumb" alt="' + newsEscape(news.title) + '" onerror="this.onerror=null;this.src=\'/resources/img/brand/kumano-mae-splash.png\';"></div>'
        + '<div class="card-body d-flex flex-column"><span class="badge ' + badgeClass(news.category) + ' mb-2 align-self-start">' + label(news.category) + '</span>'
        + '<h5 class="card-title fw-bold">' + newsEscape(news.title) + '</h5>'
        + '<p class="mb-2 text-muted small"><i class="bi bi-building"></i> ' + newsEscape(news.source) + ' <span class="ms-2"><i class="bi bi-clock-fill"></i> ' + news.date + '</span></p>'
        + '<p class="small text-muted flex-grow-1">' + newsEscape(news.summary) + '</p></div></article></div>';
    }).join('');

    grid.querySelectorAll('.clickable-card').forEach(function (card) {
      card.addEventListener('click', function () { location.href = card.dataset.cardHref; });
      card.addEventListener('keydown', function (event) {
        if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); location.href = card.dataset.cardHref; }
      });
    });

    var buttons = '';
    if (totalPages > 1) {
      for (var page = 1; page <= totalPages; page += 1) {
        buttons += '<button type="button" class="client-page-button' + (page === currentPage ? ' active' : '') + '" data-page="' + page + '">' + page + '</button>';
      }
    }
    pagination.innerHTML = buttons;
    pagination.querySelectorAll('[data-page]').forEach(function (button) {
      button.addEventListener('click', function () {
        currentPage = Number(button.dataset.page);
        render();
        window.scrollTo({ top: 0, behavior: 'smooth' });
      });
    });
  }

  document.querySelectorAll('.filter-btn').forEach(function (button) {
    button.addEventListener('click', function () {
      document.querySelectorAll('.filter-btn').forEach(function (item) { item.classList.remove('active'); });
      button.classList.add('active');
      currentCategory = button.dataset.category;
      currentPage = 1;
      render();
    });
  });
  render();
});
</script>
</body>
</html>
