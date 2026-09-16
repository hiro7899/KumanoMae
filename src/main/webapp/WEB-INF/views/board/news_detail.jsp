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
<style>.news-detail-gallery{display:grid;gap:12px}.news-detail-gallery img{width:100%;max-height:520px;object-fit:cover;border-radius:12px}.news-detail-content{white-space:pre-line;line-height:1.9}</style>
</head>
<body>
<%@ include file="/WEB-INF/views/includes/header.jsp"%>
<main class="container py-5"><nav class="mb-4"><a href="/board/news">ニュース一覧</a> / ニュース詳細</nav><article id="newsDetail" class="card card-jp p-4"></article></main>
<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
<script src="/resources/js/index.js"></script>
<script>
document.addEventListener('DOMContentLoaded',function(){var id=Number(new URLSearchParams(location.search).get('newsId'));var n=HARD_CODED_NEWS.find(function(item){return item.id===id;});var box=document.getElementById('newsDetail');if(!n){box.innerHTML='<p class="text-muted">ニュースを見つけられませんでした。</p>';return;}document.title=n.title+' | 熊の前';box.innerHTML='<div class="news-detail-gallery">'+n.images.map(function(src,i){return '<img src="'+src+'" alt="'+newsEscape(n.title)+' '+(i+1)+'" onerror="this.onerror=null;this.src=\'/resources/img/brand/kumano-mae-splash.png\';">';}).join('')+'</div><div class="pt-4"><span class="badge badge-danger-custom">'+(n.category==='SAFETY'?'安全対策':n.category==='OFFICIAL'?'自治体のお知らせ':'出没情報')+'</span><h1 class="h2 fw-bold mt-3">'+newsEscape(n.title)+'</h1><p class="text-muted"><i class="bi bi-building"></i> '+newsEscape(n.source)+'　<i class="bi bi-clock-fill"></i> '+n.date+'　<i class="bi bi-geo-alt-fill"></i> '+newsEscape(n.region)+'</p><p class="lead">'+newsEscape(n.summary)+'</p><div class="news-detail-content">'+newsEscape(n.content)+'</div><p class="small text-muted mt-4">出典：'+newsEscape(n.source)+'</p><a class="btn btn-jp-outline" href="/board/news">ニュース一覧に戻る</a></div>';});
</script>
</body>
</html>
