# 🚀 KumanoMae 팀 프로젝트 개발 가이드

---

# 📁 1. 폴더 & 패키지 구조 규칙

## 🔹 JSP (화면) 파일 위치
`src/main/webapp/WEB-INF/views/`
- **auth/**: 로그인, 회원가입 관련
- **board/**: 게시판 관련
- **includes/**: header, footer 등 공통 레이아웃
- **admin/**: 관리자 페이지
- **error/**: 에러 페이지
- **user/**: 사용자 페이지(마이페이지 등)

## 🔹 Java 클래스 위치
`src/main/java/com/jsl/`
- **controller/**: 서블릿 (URL 요청 처리)
- **service/**  화면(Controller)과 DB(DAO) 사이에서 실제 비즈니스 로직(검증, 계산, 조건 처리)을 담당하는 클래스
- **dao/**: DB 접근 객체
- **dto/**: 데이터 전달 객체
- **util/**: DBManager, EncodingFilter 등 공통 유틸

##💡 บทบาท 구분 (왜 Service를 쓰나요?)

- Controller (서블릿): 요청을 받고, 어느 화면(JSP)으로 이동할지 길 안내만 담당
- Service: 실제 머리 쓰는 일 (아이디 중복 검사, 가입 자격 확인, 계산 등)
- DAO: DB에서 데이터를 빼오거나 넣는 일만 담당  

---

# 🔄 2. 이클립스 GUI Git 작업 순서

## 🔹 [매일 시작 전] 최신 코드 가져오기 (Pull)
1. `Git Repositories` 뷰 ➔ `Branches` ➔ `Local` ➔ `develop` 우클릭 ➔ **Checkout**
2. 프로젝트 우클릭 ➔ **Team** ➔ **Pull**
3. `Local` ➔ `본인 브랜치(feature/이름)` 우클릭 ➔ **Checkout**
4. 본인 브랜치 우클릭 ➔ **Merge...** ➔ `develop` 선택 후 Merge

## 🔹 [개발 완료 후] 내 코드 올리기 (Commit & Push)
1. `Git Staging` 탭 이동
2. 변경된 파일 **Unstaged** ➔ **Staged(`+`)** 이동
3. Commit Message 작성 (예: `Feat: 로그인 UI 구현`)
4. **[Commit and Push...]** 클릭

## 🔹 [GitHub] PR(Pull Request) 보내기
- GitHub 웹 접속 ➔ **Compare & pull request** 클릭
- **base:** `develop` ⬅️ **compare:** `feature/본인이름` 확인 후 PR 생성!

---

# ⚠️ 3. 필독 주의사항

1. **Pull 받을 때:** 무조건 `develop` 브랜치에서 받기!
2. **Push 할 때:** 무조건 `내 개인 브랜치(feature/이름)`로 올리기!
3. **JSP 접근:** `WEB-INF` 내부 JSP는 브라우저 주소창 직접 접속 금지 (서블릿 타고 이동)
