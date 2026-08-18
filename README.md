# 🚀 KumanoMae 팀 프로젝트 개발 가이드

프로젝트의 원활한 진행과 효율적인 협업을 위한 개발 가이드라인입니다.  
처음 시작할 때 아래 규칙을 꼭 숙지하고 작업을 진행해 주세요!

---

# 📁 1. 폴더 & 패키지 구조 규칙

정해진 구조에 맞춰 적절한 위치에 파일 및 클래스를 생성해 주세요.

## 🔹 JSP (화면) 파일 위치
`src/main/webapp/WEB-INF/views/`
- **auth/**: 로그인, 회원가입 관련
- **board/**: 게시판 관련
- **includes/**: `header.jsp`, `footer.jsp` 등 공통 레이아웃
- **admin/**: 관리자 페이지
- **user/**: 사용자 페이지 (마이페이지 등)
- **error/**: 404, 500 등 에러 페이지

> ⚠️ **주의:** `WEB-INF` 내부의 JSP 파일은 보안 구역이므로 브라우저 주소창에 직접 URL을 입력하여 접근할 수 없습니다. 반드시 **Controller(서블릿)**를 거쳐서 이동해야 합니다.

## 🔹 Java 클래스 위치
`src/main/java/com/jsl/`
- **controller/**: 서블릿 객체 (URL 요청 수신 및 화면 이동 안내)
- **service/**: 화면(Controller)과 DB(DAO) 사이에서 **실제 비즈니스 로직(검증, 계산, 조건 처리)을 담당하는 클래스**
- **dao/**: DB 접근 객체 (Data Access Object, SQL 실행)
- **dto/**: 데이터 전달 객체 (Data Transfer Object, DB-Java간 데이터 전달)
- **util/**: `DBManager`, `EncodingFilter` 등 공통 유틸리티

### 💡 역할 구분 (왜 Service를 쓰나요?)
- **Controller (서블릿):** 요청을 받고, 어느 화면(JSP)으로 이동할지 **길 안내만 담당**
- **Service:** 실제 **머리 쓰는 일** (아이디 중복 검사, 가입 자격 확인, 데이터 가공 및 계산 등)
- **DAO:** DB에서 **데이터를 빼오거나 넣는 일만 담당**

---

# 🔄 2. 이클립스 GUI Git 작업 순서

터미널 명령어 대신 **이클립스 Git GUI**를 사용한 표준 작업 절차입니다.

## 📥 [매일 시작 전] 최신 코드 가져오기 (Pull)
1. `Git Repositories` 뷰 ➔ `Branches` ➔ `Local` ➔ `develop` 우클릭 ➔ **Checkout**
2. 프로젝트 우클릭 ➔ **Team** ➔ **Pull** 클릭 (`develop` 최신화)
3. `Local` ➔ `본인 브랜치(feature/이름)` 우클릭 ➔ **Checkout**
4. 본인 브랜치 우클릭 ➔ **Merge...** ➔ `develop` 선택 후 **Merge** 클릭

## 📤 [개발 완료 후] 내 코드 올리기 (Commit & Push)
1. 하단 **`Git Staging`** 탭 이동
2. Unstaged Changes의 변경된 파일 선택 ➔ **`+`** 눌러 Staged Changes로 이동
3. Commit Message 작성 (아래 커밋 메시지 작성 규칙 참고)
4. **`[Commit and Push...]`** 클릭 후 완료

## 🔀 [GitHub] PR (Pull Request) 보내기
1. GitHub 웹 접속 ➔ **`Compare & pull request`** 클릭
2. **브랜치 방향 확인:**  
   `base: develop` ⬅️ `compare: feature/본인이름`
3. 작업 내용 요약 작성 후 **`Create pull request`** 클릭

---

# 💬 3. Git 커밋 메시지 작성 규칙

커밋 메시지는 **`타입: 설명`** 형태로 작성합니다. (첫 글자 대문자)

### 📌 자주 쓰는 커밋 타입 요약

| 타입 | 의미 | 작성 예시 |
| :--- | :--- | :--- |
| **`Feat`** | 새로운 기능 구현 | `Feat: 회원가입 아이디 중복체크 기능 구현` |
| **`Fix`** | 버그 및 오류 수정 | `Fix: 로그인 시 세션 생성 안 되는 오류 수정` |
| **`Style`** | UI 디자인, CSS, 코드 포맷팅 | `Style: 헤더 네비게이션 바 CSS 디자인 수정` |
| **`Refactor`** | 코드 개선 (기능 변경 없음) | `Refactor: DBManager 자원 반납 로직 공통화` |
| **`Chore`** | 기타 세팅, 폴더/파일 추가 | `Chore: board 패키지 생성 및 .gitkeep 추가` |

---

# ⚠️ 4. 필독 주의사항

1. **Pull & Push 기준:**
   - **Pull 받을 때:** 무조건 `develop` 브랜치에서 받기!
   - **Push 할 때:** 무조건 `내 개인 브랜치(feature/이름)`로 올리기!
2. **JSP 접근 규칙:**
   - `WEB-INF` 내부 JSP는 브라우저 주소창 직접 접속 금지 (서블릿 타고 이동)
3. **인코딩 설정:**
   - `EncodingFilter`가 세팅되어 있으므로 서블릿마다 `request.setCharacterEncoding("UTF-8")`을 별도로 작성하지 않아도 됩니다.
4. **에러 발생 시:**
   - 이클립스 콘솔창에 빨간 줄(Exception)이 뜨면, **가장 위쪽에 찍힌 첫 번째 에러 메시지**를 복사해서 팀장에게 문의해 주세요.

## 📐 네이밍 규칙 (Naming Conventions)

코드의 일관성과 가독성을 위해 표기법 가이드 및 명명 규칙을 엄격히 준수합니다.

### 🔤 표기법 요약 (Case Styles)

| 표기법 | 명명 형태 | 설명 및 예시 | 주요 사용처 |
| :--- | :--- | :--- | :--- |
| **camelCase** | 소문자 시작 + 단어 조합 대문자 | `userId`, `boardList`, `submitBtn` | Java 변수/메서드, JS 변수/함수, HTML ID |
| **PascalCase** | 대문자 시작 + 단어 조합 대문자 | `BoardController`, `UserDAO` | Java 클래스/인터페이스/컨트롤러 |
| **kebab-case** | 전체 소문자 + 하이픈(`-`) 연결 | `board-list`, `danger-marker` | HTML Class, URL Path, CSS 스타일 |
| **SNAKE_CASE** | 전체 대문자 + 언더바(`_`) 연결 | `BOARD_NO`, `MAX_FILE_SIZE` | DB 테이블/컬럼(대문자), Java 상수 |
---

### 1. Java (Backend)
- **컨트롤러명 (Controller)**: `PascalCase` (`[도메인]Controller` 형태)
  - `BoardController` (`@WebServlet("/board/*")`), `UserController`
- **DAO / DTO / Service 명**: `PascalCase`
  - `BoardDAO`, `UserDAO`, `DangerZoneDTO`
- **변수명 및 메서드명**: `camelCase`
  - `selectBoardList()`, `dangerZoneList`, `userId`
- **상수 (Constant)**: `UPPER_SNAKE_CASE`
  - `MAX_FILE_SIZE`, `DEFAULT_PAGE_SIZE`
- **패키지명 (Package)**: `lowercase` (전체 소문자)
  - `com.bear.controller`, `com.bear.dao`, `com.bear.dto`

### 2. Database (Oracle DB)
- **테이블명 및 컬럼명**: `UPPER_SNAKE_CASE`
  - 테이블: `BEAR_BOARDS`, `BEAR_DANGER_ZONES`
  - 컬럼: `BOARD_NO`, `DANGER_LEVEL`, `CREATED_AT`
- **시퀀스 (Sequence)**: `UPPER_SNAKE_CASE` (`SEQ_[테이블명]_[PK]`)
  - `SEQ_BEAR_BOARDS_NO`

### 3. Frontend & Web Path
- **JSP 파일명**: `camelCase` 또는 `lowercase`
  - `bearMap.jsp`, `boardList.jsp`, `boardWrite.jsp`
- **URL / Servlet Mapping 경로**: RESTful 스타일 `kebab-case` (확장자 `.do` 제거)
  - `/board/list`, `/board/write`, `/board/detail`
  - `/user/login`, `/user/signup`
- **JavaScript 변수/함수명**: `camelCase`
  - `initMap()`, `drawDangerZone()`, `selectedLat`
- **HTML DOM ID / Class**:
  - `id`: `camelCase` (JS 제어 및 식별 목적 / 예: `#mapContainer`, `#submitBtn`)
  - `class`: `kebab-case` (CSS 스타일링 목적 / 예: `.danger-marker`, `.board-table`)
 
### 2. Database (Oracle DB) & DAO SQL 작성 규칙
- **테이블명 및 컬럼명**: `UPPER_SNAKE_CASE` (DB DDL 정의 시)
  - 테이블: `BEAR_BOARDS`, `BEAR_DANGER_ZONES`
  - 컬럼: `BOARD_NO`, `DANGER_LEVEL`, `CREATED_AT`
- **시퀀스 (Sequence)**: `UPPER_SNAKE_CASE` (`SEQ_[테이블명]_[PK]`)
  - `SEQ_BEAR_BOARDS_NO`

#### ✍️ DAO 클래스 내 SQL 쿼리 대소문자 작성 규칙
Java DAO 파일 내부에서 PreparedStatement용 SQL 문을 작성할 때 아래 가이드를 준수합니다.

1. **SQL 예약어 / 키워드**: `전체 대문자` 사용
   - `SELECT`, `FROM`, `WHERE`, `INSERT INTO`, `VALUES`, `UPDATE`, `SET`, `DELETE`, `ORDER BY`, `AND`, `OR` 등
2. **테이블명 및 컬럼명**: `전체 대문자` (`UPPER_SNAKE_CASE`) 사용
   - Oracle DB 스키마와 일치시켜 가독성 확보 (`BEAR_BOARDS`, `TITLE`, `CREATED_AT`)
3. **컬럼 별칭 (Alias)**: `소문자` 또는 `camelCase` 사용 (필요 시 큰따옴표 `" "` 활용)
   - 예: `COUNT(*) AS totalCount`
4. **Java 내 텍스트 블록 / String 작성 가이드**:
   - 가독성을 위해 각 절(`SELECT`, `FROM`, `WHERE` 등)마다 줄바꿈 및 들여쓰기 적용

**[DAO SQL 작성 예시]**
```java
// 게시글 목록 조회 쿼리 예시
String sql = "SELECT BOARD_NO, USER_ID, TITLE, DANGER_LEVEL, READ_COUNT, CREATED_AT "
           + "FROM BEAR_BOARDS "
           + "WHERE DANGER_LEVEL = ? "
           + "ORDER BY BOARD_NO DESC";

// 신규 제보 등록 쿼리 예시
String sql = "INSERT INTO BEAR_BOARDS (BOARD_NO, USER_ID, TITLE, CONTENT, LATITUDE, LONGITUDE, DANGER_LEVEL) "
           + "VALUES (SEQ_BEAR_BOARDS_NO.NEXTVAL, ?, ?, ?, ?, ?, ?)";
