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
    <main class="error-page error-page-500">
        <section class="error-card" aria-labelledby="errorTitle">
            <img class="error-logo" src="/resources/img/brand/kumanomae-paw-seal.png" alt="クマノマエ">
            <p class="error-code" aria-hidden="true">500</p>
            <h1 id="errorTitle">少しお待ちください。</h1>
            <p class="error-message">システムに問題が発生しました。しばらくしてから、もう一度お試しください。</p>
            <div class="error-actions">
                <a class="error-button error-button-primary" href="/">ホームへ戻る</a>
                <button class="error-button error-button-secondary" type="button" onclick="location.reload()">もう一度試す</button>
            </div>
        </section>
    </main>
</body>
</html>
