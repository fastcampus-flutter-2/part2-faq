# Part 2 - FAQ

### 01. Flutter SDK 버전 대응
- 3.16.9 => 3.19.6

### 02. Flutter 라이브러리 버전 대응
- 3.16.9 에서 라이브러리 최신화

### 03. Flutter SDK & 라이브러리 버전 대응
- 3.16.9 => 3.19.6
- 3.19.6 에서 라이브러리 최신화

### 04. iOS 파일 정리 주의사항
- Runner-Bridging-Header.h
- Info.plist

### 05. 모듈간의 데이터 통신
- A Screen -> B Screen -> C Screen 에서 C Screen 이탈 시, A Screen 통신
- A Feature <-> B Feature 통신

### 06. 특정 모듈만 점검하는 방법
- Community Feature Example
  - Community
  - Search

### 07. 특정 기능만 다른 상태 관리로 변경하기
- 특정 모듈 전체를 Bloc 대신 다른 상태 관리 라이브러리 적용 (ex. Provider)
- 특정 모듈 일부 기능만 Bloc 대신 다른 상태 관리 라이브러리 적용 (ex. Provider)

### 08. 요구사항이 변경되었을 때
- 커뮤니티 홈에서 인기 탭을 하단 GNB 로 분리해주세요.
- 글쓰기 버튼을 하단 GNB 로 옮겨주세요.

### 09. 로컬 서버가 안되면? Mock 이라도 사용하자
- 구현된 임의의 로컬 서버가 iOS Simulator 에서는 문제가 없음
- 그러나, 다른 플랫폼이나 실기기에는 문제가 발생할 수 있으니 json 파일로 대체해서 최소한의 테스트 진행

### 10. 새로운 앱을 만들 때, 재사용하기
- 글 작성 기반의 앱을 만든다고 가정
  - 글 작성
  - 마이 페이지 

### 11. DI 최적화 방법
- 중복으로 등록되는 의존성을 최소화 하기 위해 Modular 를 사용하여 최적화 하는 방법
