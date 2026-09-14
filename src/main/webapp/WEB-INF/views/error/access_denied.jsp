<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>アクセスが拒否されました | クマノマエ</title>
<link rel="stylesheet" href="/resources/css/error/error.css">
</head>
<body>
    <main class="error-page error-page-403">
        <section class="error-card" aria-labelledby="errorTitle">
            <img class="error-logo" src="/resources/img/brand/kumanomae-paw-seal.png" alt="クマノマエ">
            <p class="error-code" aria-hidden="true">403</p>
            <h1 id="errorTitle">このページは見られません。</h1>
            <p class="error-message">このページを利用する権限がありません。ログイン状態やアカウント権限をご確認ください。</p>
            <div class="error-actions">
                <a class="error-button error-button-primary" href="/">ホームへ戻る</a>
                <button class="error-button error-button-secondary" type="button" onclick="history.back()">前のページへ戻る</button>
            </div>
        </section>
    </main>
</body>
</html>
