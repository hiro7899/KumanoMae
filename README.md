# 🐻 BearWatch (곰 출몰 위기 경보 및 정보 공유 시스템)

> **일본 지역 곰 출몰 정보 시각화 및 입산 주의 기간 알림 웹 서비스**  
> 사용자의 위험 제보 데이터와 서버 시간 기반의 위험 기간 판별 로직을 결합하여, 지역별 곰 출몰 정보를 지도상에 시각화하고 안전 용품 정보를 제공합니다.

---

## 📌 주요 기능 (Key Features)

- 🗺️ **일본 지역 곰 출몰 지도 (OpenStreetMap + Leaflet.js)**
  - 제보된 위도/경도 좌표를 바탕으로 지도 위에 출몰 위치 마커 표시
  - 위험도 레벨(위험/경고/주의)별 마커 시각화 및 상세 인포윈도우 제공
- ⏰ **서버 시간 기반 위험 기간 자동 경보**
  - Java 서버 시간 기준, 곰 활동 왕성 기간(동면 전 등)에 해당하는 위험 지역을 지도상에 붉은 범주(Circle Zone)로 표시
  - 메인 화면 내 위험 기간 주의 알림 팝업/배너 렌더링
- 📝 **곰 출몰 제보 게시판 (CRUD & Map Picker)**
  - 게시글 작성 시 사용자가 지도를 직접 클릭하여 좌표(위도/경도) 자동 입력
  - 사용자 제보 목록 조회, 상세 조회 및 페이징 처리
- 🔐 **회원 관리 시스템**
  - JSP/Servlet 및 Session 기반 로그인, 회원가입, 로그아웃 기능
- 🛡️ **곰 퇴치 용품 추천 및 커머스 연동**
  - 곰 스프레이, 호루라기 등 입산 안전 용품 정보 제공 및 외부 구매 링크 연동

---

## 🛠 기술 스택 (Tech Stack)

### Backend & Server
- **Language**: Java (JDK 17)
- **Framework / Platform**: Java Servlet, JSP (Pure Dynamic Web Project)
- **Database**: Oracle DB (11g 이상)
- **DB Access**: JDBC, DBCP
- **Web Server / WAS**: Apache Tomcat 9.0

### Frontend & API
- **View**: JSP, HTML5, CSS3, JavaScript (ES6)
- **Map API**: OpenStreetMap + Leaflet.js
- **Icons / UI**: FontAwesome, Custom CSS

### Development Tools
- **IDE**: Eclipse IDE for Enterprise Java Developers
- **VCS**: Git / GitHub

---

## 🗄 DB 구조 (Database Schema)
[ USERS ]
USER_ID (PK) : 아이디
PASSWORD    : 비밀번호
USER_NAME   : 이름
EMAIL       : 이메일
CREATED_AT  : 가입일

[ BEAR_BOARDS ]
BOARD_NO (PK): 게시글 번호
USER_ID (FK) : 작성자 ID
TITLE       : 제보 제목
CONTENT     : 상세 내용
LATITUDE    : 위도
LONGITUDE   : 경도
DANGER_LEVEL: 위험도 (위험/경고/주의)
READ_COUNT  : 조회수
CREATED_AT  : 작성일

[ BEAR_DANGER_ZONES ]
ZONE_ID (PK) : 위험지역 ID
ZONE_NAME   : 지역명
LATITUDE    : 위도
LONGITUDE   : 경도
RADIUS      : 반경 (미터 단위)
START_DATE  : 위험 시작일
END_DATE    : 위험 종료일
REASON      : 위험 사유

## 📁 프로젝트 구조 (Directory Structure)

```text
src/
├── main/
│   ├── java/
│   │   └── com/bear/
│   │       ├── controller/   # Servlet (UserServlet, BoardServlet 등)
│   │       ├── dao/          # Database Access Object
│   │       ├── dto/          # Data Transfer Object (UserDTO, BoardDTO 등)
│   │       └── util/         # DBConnection, DateUtil 등 유틸리티 클래스
│   └── webapp/
│       ├── META-INF/
│       ├── WEB-INF/
│       │   ├── lib/          # ojdbc8.jar, jstl.jar 등
│       │   └── web.xml
│       ├── css/
│       ├── js/
│       ├── views/            # JSP 화면 모듈
│       │   ├── login.jsp
│       │   ├── signup.jsp
│       │   ├── boardList.jsp
│       │   └── boardWrite.jsp
│       └── index.jsp (bearMap.jsp)
