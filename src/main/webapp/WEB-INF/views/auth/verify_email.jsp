<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<title>メール認証 - クマ出没マップ</title>
</head>
<body data-context-path="${pageContext.request.contextPath}">

	<main>
		<h1>メール認証</h1>
		<p id="verificationMessage">メール認証を確認しています。</p>
		<a href="${pageContext.request.contextPath}/login"> ログイン画面へ </a>
	</main>

	<script>
        document.addEventListener("DOMContentLoaded", async function () {
            const contextPath = document.body.dataset.contextPath || "";
            const token = new URLSearchParams(location.search).get("token");
            const message = document.getElementById("verificationMessage");

            if (!token) {
                message.textContent = "認証情報が見つかりません。";
                return;
            }

            try {
                const response = await fetch(
                    contextPath + "/api/email-verification/verify",
                    {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                        },
                        body: new URLSearchParams({ token: token })
                    }
                );

                const result = await response.json();

                if (!response.ok || !result.success) {
                    throw new Error(result.message || "メール認証に失敗しました。");
                }

                message.textContent =
                    "メール認証が完了しました。ログイン画面へ移動します。";

                setTimeout(function () {
                    location.href = contextPath + "/login?verified=true";
                }, 1500);
            } catch (error) {
                message.textContent = error.message;
            }
        });
    </script>

</body>
</html>