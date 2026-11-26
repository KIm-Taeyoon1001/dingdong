# 딩동 (DingDong)

NEIS Open API를 이용해 학교 시간표와 급식을 확인하고 Android 홈 화면 위젯으로 보여주는 앱입니다.

## 현재 구현 범위
- Kotlin + Jetpack Compose 기반 Android 앱
- NEIS 학교 검색 API 연동
- 초·중·고 시간표 API 경로 지원
- 급식식단정보 API 연동
- Glance 홈 화면 위젯(시간표/급식 요약)
- WorkManager 주기 동기화 및 위젯 갱신
- 학교/학년/반 설정 로컬 저장

> NEIS 데이터 반영 시점은 학교의 원천 데이터 입력 및 NEIS 제공 주기에 좌우됩니다. 앱은 주기적으로 다시 조회하지만, 아직 NEIS에 등록되지 않은 변경사항을 미리 알 수는 없습니다.

## 빌드
1. Android Studio에서 프로젝트를 엽니다.
2. 프로젝트 루트의 `local.properties`에 다음 값을 추가합니다.
   ```properties
   sdk.dir=...
   NEIS_API_KEY=발급받은_인증키
   ```
   또는 사용자 Gradle 속성에 `NEIS_API_KEY`를 설정할 수 있습니다.
3. Gradle Sync 후 `app`의 debug 빌드를 실행합니다.

인증키는 저장소에 커밋하지 마세요. `local.properties`는 Git에서 제외됩니다.

## NEIS API
- 학교기본정보: `schoolInfo`
- 급식식단정보: `mealServiceDietInfo`
- 초등학교 시간표: `elsTimetable`
- 중학교 시간표: `misTimetable`
- 고등학교 시간표: `hisTimetable`

공식 개발자 가이드: https://open.neis.go.kr/portal/guide/apiGuidePage.do

## 알려진 제한
- 첫 실행 시 API 인증키와 학교 정보를 설정해야 합니다.
- 학교 검색 결과 선택은 현재 학교명/교육청코드를 입력하는 기본 설정 흐름으로 제공됩니다.
- 시간표 조회는 학교급별 API의 필수 파라미터 및 학사 운영 형태에 따라 결과가 없을 수 있습니다.
- Android 위젯 갱신 주기는 OS 배터리 정책에 따라 지연될 수 있습니다.
- 현재 저장소에는 APK 바이너리가 포함되어 있지 않습니다.

## 보안
- 인증키를 코드, README, 이슈, 커밋에 넣지 마세요.
- 공개 저장소에 실수로 키를 올렸다면 NEIS 포털에서 키를 재발급/폐기하세요.
