<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>目撃情報詳細 | クマ出没マップ</title>
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
	href="${pageContext.request.contextPath}/resources/css/index.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/includes/layout.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/board/view.css">
</head>
<body>
	<%@ include file="/WEB-INF/views/includes/header.jsp"%>
	<main class="board-detail-page">
		<div class="container py-4 py-lg-5">
			<nav aria-label="breadcrumb" class="detail-breadcrumb">
				<ol class="breadcrumb mb-0">
					<li class="breadcrumb-item"><a href="/">ホーム</a></li>
					<li class="breadcrumb-item"><a
						href="${pageContext.request.contextPath}/board/list">ユーザーコミュニティ</a></li>
					<li class="breadcrumb-item active" aria-current="page">目撃情報詳細</li>
				</ol>
			</nav>
			<div class="row g-4 mt-1">
				<div class="col-lg-8">
					<article class="detail-card">
						<header class="detail-header">
							<div
								class="d-flex justify-content-between align-items-start gap-3 mb-3">
								<span class="risk-badge risk-danger"><i
									class="bi bi-exclamation-triangle-fill"></i> 危険</span><span
									class="post-number">REPORT NO. 000124</span>
							</div>
							<h1>札幌近郊の登山道でクマを発見</h1>
							<div class="post-meta">
								<span><i class="bi bi-person-circle"></i> 山歩き太郎</span><span><i
									class="bi bi-calendar3"></i> 2026. 08. 20</span><span><i
									class="bi bi-eye"></i> 128</span>
							</div>
						</header>
						<section class="sighting-summary" aria-label="目撃情報の概要">
							<div class="summary-item">
								<i class="bi bi-geo-alt-fill"></i>
								<div>
									<span>目撃場所</span><strong>北海道札幌市南区 定山渓・登山道入口付近</strong>
								</div>
							</div>
							<div class="summary-item">
								<i class="bi bi-clock-fill"></i>
								<div>
									<span>目撃日時</span><strong>2026年 08月 20日 07:30 ごろ</strong>
								</div>
							</div>
							<div class="summary-item">
								<i class="bi bi-signpost-split-fill"></i>
								<div>
									<span>当時の状況</span><strong>登山中 / 単独で移動</strong>
								</div>
							</div>
						</section>
						<section class="post-content">
							<p>登山道の入口から少し進んだ場所で、成獣と思われるクマを1頭見かけました。</p>
							<p>クマは山側の茂みに入っていきましたが、周辺を歩く方は十分に注意してください。近くを通る予定の方は、鈴など音の出るものを携帯し、単独行動は避けることをおすすめします。</p>
							<figure class="report-photo">
								<img
									src="https://images.unsplash.com/photo-1589656966895-2f33e7653819?w=1200"
									alt="森の中にいるクマのイメージ">
								<figcaption>
									<i class="bi bi-image"></i> 添付写真 1枚
								</figcaption>
							</figure>
						</section>
						<div class="post-actions">
							<button type="button" class="action-button" id="likeButton"
								aria-pressed="false">
								<i class="bi bi-heart"></i> 役に立った <span id="likeCount">24</span>
							</button>
							<button type="button" class="action-button" id="shareButton">
								<i class="bi bi-share"></i> 共有する
							</button>
							<button type="button" class="action-button ms-auto text-danger">
								<i class="bi bi-flag"></i> 不適切な投稿を報告
							</button>
						</div>
					</article>
					<section class="comments-section mt-4"
						aria-labelledby="comments-title">
						<div class="section-heading">
							<h2 id="comments-title">
								コメント <span>3</span>
							</h2>
						</div>
						<div class="comment-compose">
							<label for="commentText" class="visually-hidden">コメントを入力</label>
							<textarea id="commentText" placeholder="安全に関する情報や補足を投稿してください。"></textarea>
							<div class="d-flex justify-content-end mt-2">
								<button type="button" class="btn btn-jp-mustard btn-sm px-3">コメントを投稿</button>
							</div>
						</div>
						<div class="comment-list">
							<article class="comment-item">
								<div class="comment-avatar">森</div>
								<div>
									<div class="comment-top">
										<strong>森の案内人</strong>
										<time>2026. 08. 20 09:12</time>
									</div>
									<p>情報ありがとうございます。今週末に向かう予定でしたが、別のコースを検討します。</p>
								</div>
							</article>
							<article class="comment-item">
								<div class="comment-avatar avatar-mustard">熊</div>
								<div>
									<div class="comment-top">
										<strong>安全第一</strong>
										<time>2026. 08. 20 10:04</time>
									</div>
									<p>定山渓周辺は早朝・夕方の目撃が多いようです。皆さんお気をつけください。</p>
								</div>
							</article>
						</div>
					</section>
				</div>
				<aside class="col-lg-4">
					<div class="location-card">
						<div class="location-card-head">
							<span><i class="bi bi-map-fill"></i> 目撃位置</span><span
								class="status-live">確認中</span>
						</div>
						<div class="map-preview">
							<div class="map-grid"></div>
							<div class="map-pin">
								<i class="bi bi-exclamation-lg"></i>
							</div>
							<span class="map-label">目撃地点</span>
						</div>
						<div class="location-card-body">
							<strong>北海道札幌市南区</strong>
							<p>定山渓・登山道入口付近</p>
							<a href="/map" class="btn btn-jp-outline btn-sm w-100"><i
								class="bi bi-map"></i> 地図で確認する</a>
						</div>
					</div>
					<div class="safety-note mt-4">
						<div class="safety-icon">
							<i class="bi bi-shield-fill-exclamation"></i>
						</div>
						<div>
							<h2>安全のために</h2>
							<p>クマを見かけても近づかず、静かにその場を離れてください。</p>
							<a href="#">遭遇時の対処法 <i class="bi bi-arrow-right"></i></a>
						</div>
					</div>
					<a href="${pageContext.request.contextPath}/board/list"
						class="back-to-list"><i class="bi bi-arrow-left"></i> 一覧に戻る</a>
				</aside>
			</div>
		</div>
	</main>
	<%@ include file="/WEB-INF/views/includes/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script>
    const likeButton = document.getElementById('likeButton'); const likeCount = document.getElementById('likeCount');
    likeButton.addEventListener('click', () => { const liked = likeButton.getAttribute('aria-pressed') === 'true'; likeButton.setAttribute('aria-pressed', String(!liked)); likeButton.classList.toggle('is-liked', !liked); likeButton.querySelector('i').className = liked ? 'bi bi-heart' : 'bi bi-heart-fill'; likeCount.textContent = Number(likeCount.textContent) + (liked ? -1 : 1); });
    document.getElementById('shareButton').addEventListener('click', async () => { try { await navigator.clipboard.writeText(location.href); alert('投稿のURLをコピーしました。'); } catch (e) { alert('URLをコピーできませんでした。'); } });
    </script>
</body>
</html>
