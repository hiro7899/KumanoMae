<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>コミュニティ</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2 class="fw-bold mb-4">コミュニティ</h2>

    <!-- カテゴリタブ & 新規投稿ボタン -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="btn-group" role="group">
            <a href="/community/list" class="btn btn-outline-primary ${empty param.category ? 'active' : ''}">すべて</a>
            <a href="/community/list?category=FREE" class="btn btn-outline-primary ${param.category == 'FREE' ? 'active' : ''}">掲示板</a>
            <a href="/community/list?category=GEAR" class="btn btn-outline-primary ${param.category == 'GEAR' ? 'active' : ''}">ギアおすすめ</a>
            <a href="/community/list?category=REVIEW" class="btn btn-outline-primary ${param.category == 'REVIEW' ? 'active' : ''}">レビュー</a>
        </div>
        <a href="/community/write" class="btn btn-success fw-bold">＋ 新規投稿</a>
    </div>

    <!-- 投稿一覧テーブル -->
    <table class="table table-hover text-center align-middle">
        <thead class="table-light">
            <tr>
                <th style="width: 10%;">No.</th>
                <th style="width: 15%;">カテゴリ</th>
                <th style="width: 40%;">タイトル</th>
                <th style="width: 15%;">投稿者</th>
                <th style="width: 10%;">閲覧数</th>
                <th style="width: 10%;">いいね</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="board" items="${communityList}">
                <c:if test="${board.status eq 'Y'}">
                    <tr>
                        <td>${board.cBoardId}</td>
                        <td>
                            <c:choose>
                                <c:when test="${board.category eq 'FREE'}"><span class="badge bg-secondary">掲示板</span></c:when>
                                <c:when test="${board.category eq 'GEAR'}"><span class="badge bg-info text-dark">ギア</span></c:when>
                                <c:when test="${board.category eq 'REVIEW'}"><span class="badge bg-success">レビュー</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">${board.category}</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-start">
                            <a href="/community/detail?cBoardId=${board.cBoardId}" class="text-decoration-none text-dark fw-bold">
                                ${board.title}
                            </a>
                        </td>
                        <td>${board.memberId}</td>
                        <td>${board.viewCnt}</td>
                        <td>${board.likeCnt}</td>
                    </tr>
                </c:if>
            </c:forEach>
            <c:if test="${empty communityList}">
                <tr>
                    <td colspan="6" class="text-muted py-4">投稿がありません。</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>
</body>
</html>