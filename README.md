🚀 [KumanoMae] 팀 프로젝트 개발 가이드
안녕하세요 팀원 여러분! 프로젝트의 원활한 진행과 효율적인 협업을 위한 기본 가이드입니다.

처음이라 어색할 수 있지만, 아래 규칙만 잘 따라주시면 큰 문제 없이 개발을 진행할 수 있습니다.

1. 📁 폴더 & 패키지 구조 규칙
우리가 미리 세팅해 둔 프로젝트 기본 구조입니다. 정해진 위치에 맞게 파일을 생성해 주세요.

🔹 JSP (화면) 파일 위치: src/main/webapp/WEB-INF/views/
⚠️ 주의: 브라우저 주소창에 .jsp를 직접 입력해서 들어갈 수 없습니다. (보안 구역)

반드시 서블릿(Controller)을 거쳐서 접속해야 합니다.

layout/: header.jsp, footer.jsp 등 공통 화면 조각

auth/: login.jsp, join.jsp 등 로그인/회원가입/인증 페이지

user/: mypage.jsp, profile.jsp 등 로그인 후 마이페이지

board/: list.jsp, detail.jsp, write.jsp 등 게시판 관련

error/: 404.jsp, 500.jsp 등 에러 페이지

🔹 Java 클래스 위치: src/main/java/com/jsl/
controller/: 요청을 받는 서블릿 (@WebServlet("/경로"))

dao/: DB에 접근해서 SQL 실행하는 클래스 (Data Access Object)

dto/: 데이터를 담아 전달하는 자바 객체 (Data Transfer Object)

service/: (선택) 주요 비즈니스 로직 처리 클래스

util/: DBManager, EncodingFilter 등 공통 도구

🔹 정적 자원 위치: src/main/webapp/resources/
css/: 스타일시트 (.css)

js/: 자바스크립트 (.js)

img/: 이미지 및 아이콘 파일

2. 🌿 Git 브랜치 전략 & 작업 순서
우리는 main - develop - 개인 기능 브랜치 구조를 사용합니다.

main: 최종 완료된 완성본 저장소 (함부로 푸시 금지)

develop: 팀원들의 코드가 모이는 개발 중심 저장소

feature/이름: 개인별 작업 영역 (예: feature/gwanho, feature/minji)

🔄 매일 개발 시작 전 & 작업 진행 순서
작업 시작 전 develop 최신화 받기

Bash
git checkout develop
git pull origin develop
내 기능 브랜치로 이동 후 develop 병합하기

Bash
git checkout feature/본인이름
git merge develop
열심히 코드 작성 및 기능 구현

로컬 커밋 및 GitHub 푸시

Bash
git add .
git commit -m "Feat: 로그인 화면 UI 및 Form 구현"
git push origin feature/본인이름
GitHub에서 Pull Request (PR) 생성

base: develop ⬅️ compare: feature/본인이름 으로 PR 제출!

3. 💬 Git 커밋 메시지 작성 규칙
커밋 메시지 첫 단어는 아래 규칙에 맞게 써주시면 나중에 코드를 찾기 편합니다.

Feat: 새로운 기능 추가 (예: Feat: 회원가입 아이디 중복체크 기능 구현)

Fix: 버그/오류 수정 (예: Fix: 로그인 시 세션 생성 안 되는 오류 수정)

Style: UI 디자인, CSS 수정, 코드 포맷팅 (예: Style: header.jsp 네비게이션 바 레이아웃 수정)

Chore: 빌드, 패키지 생성, 기타 파일 세팅 (예: Chore: board 패키지 및 .gitkeep 추가)

4. 💡 개발 시 필수 주의사항 (꼭 지켜주세요!)
한글 깨짐 문제:

이미 EncodingFilter가 세팅되어 있으니, 각 서블릿마다 따로 request.setCharacterEncoding("UTF-8")을 작성하지 않아도 됩니다.

WEB-INF 내부 JSP 직접 열기 금지:

브라우저에서 http://localhost:8080/.../WEB-INF/views/auth/login.jsp로 접속하면 404 에러가 납니다.

무조건 AuthController 서블릿 URL(예: /auth/login)을 통해 접근하세요.

🚀 [KumanoMae] 이클립스 GUI 버전 Git 작업 가이드
안녕하세요 팀원 여러분!

명령어(CLI) 없이 이클립스 GUI로 손쉽게 Git Pull & Push 하는 방법입니다.

📍 0. 기본 화면 세팅 (최초 1회만)
이클립스 우측 상단의 Perspective 아이콘을 눌러 Git을 선택하거나,

상단 메뉴 Window ➔ Show View ➔ Other... ➔ Git Staging 및 Git Repositories를 열어두면 작업하기 훨씬 수월합니다.

🔄 1. 매일 개발 시작 전 (최신 코드 가져오기)
다른 팀원이 만든 코드가 누락되지 않도록 작업 시작 전 항상 내 브랜치를 최신 상태로 유지합니다.

Git Repositories 뷰에서 Branches ➔ Local의 develop 브랜치 우클릭 ➔ Checkout

develop 브랜치가 선택되면, 해당 프로젝트 우클릭 ➔ Team ➔ Pull... (또는 상단 Pull 버튼)

다시 Local에서 본인 브랜치(feature/이름) 우클릭 ➔ Checkout

본인 브랜치 우클릭 ➔ Merge... ➔ develop 선택 후 Merge 클릭

📤 2. 개발 완료 후 GitHub에 올리기 (Commit & Push)
코드를 새로 작성했거나 수정한 후, GitHub에 올리는 순서입니다.

하단 Git Staging 탭을 엽니다.

Unstaged Changes에 있는 수정된 파일들을 선택 후 + 버튼을 눌러 Staged Changes로 이동시킵니다.

오른쪽 Commit Message 박스에 커밋 메시지를 규칙에 맞게 작성합니다.

예시: Feat: 로그인 페이지 UI 구현

오른쪽 아래 [Commit and Push...] 버튼을 클릭합니다.

안내 창에서 Push 버튼을 눌러 완료합니다.

🔀 3. GitHub에서 Pull Request (PR) 보내기
Commit and Push를 마치면 GitHub 웹사이트로 이동합니다.

본인 GitHub 저장소 페이지 상단에 노란색 띠로 뜨는 Compare & pull request 버튼을 누릅니다.

base: develop ⬅️ compare: feature/본인이름 으로 세팅되어 있는지 확인합니다.

작업한 주요 내용을 작성하고 Create pull request 버튼을 누르면 끝!

💡 자주 발생하는 주의사항 & 팁
코드 충돌(Conflict)이 났을 때:

파일 아이콘에 빨간색 C 표시가 뜨면, 해당 파일을 열어 <<<<<<< 와 >>>>>>> 표시 사이의 코드를 확인하고 팀장(Gwanho)에게 도움을 요청하세요!

매일 퇴근/수업 종료 전:

작성하던 코드 저장이 안 끝났더라도 꼭 내 브랜치(feature/이름)에 Commit & Push 해두는 습관을 들이는 것이 좋습니다.

막히거나 에러가 발생할 때:

이클립스 콘솔창에 빨간 줄(Exception)이 뜨면 당황하지 말고 가장 위쪽의 첫 번째 에러 메시지를 복사해서 팀장에게 공유해 주세요!
