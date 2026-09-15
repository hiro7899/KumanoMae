<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>エラーが発生しました | クマノマエ</title>
<link rel="stylesheet" href="/resources/css/error/error.css">
</head>
<body>
    <main class="error-page error-page-image error-page-500">
        <section class="error-card" aria-labelledby="errorTitle">
            <div class="error-scene">
                <img src="/resources/img/error/error-500-ja.png" alt="500サーバーエラー。システムで問題が発生したため、ホームへ戻る案内。">
            </div>
            <div class="error-content">
                <h1 id="errorTitle" class="visually-hidden">サーバーエラーが発生しました</h1>
                <a class="error-home-link" href="/">ホームへ戻る</a>
            </div>
        </section>
    </main>
</body>
</html>
