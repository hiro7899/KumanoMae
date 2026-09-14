<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ページが見つかりません | クマノマエ</title>
<link rel="stylesheet" href="/resources/css/error/error.css">
</head>
<body>
    <main class="error-page error-page-404">
        <section class="error-card" aria-labelledby="errorTitle">
            <div class="error-scene">
                <img src="/resources/img/kumano-mae-splash.png" alt="" aria-hidden="true">
                <span class="error-scene-code">404</span>
            </div>
            <div class="error-content">
                <h1 id="errorTitle">道に迷いました。</h1>
                <p class="error-message">お探しのページが見つかりません。</p>
                <div class="error-actions">
                    <a class="error-button error-button-primary" href="/">ホームへ戻る</a>
                    <button class="error-button error-button-secondary" type="button" onclick="history.back()">前のページへ戻る</button>
                </div>
            </div>
        </section>
    </main>
</body>
</html>
