# 딩동 (DingDong)

학교 시간표·급식·학급 운영을 돕는 Flutter 기반 Android 앱 프로젝트입니다.

## APK 분석
제공된 release APK의 정적 분석 결과는 [docs/APP_ANALYSIS.md](docs/APP_ANALYSIS.md)에 기록했습니다. Flutter AOT 앱이며 Supabase, Google Sign-In, Google Mobile Ads 사용 흔적이 확인되었습니다. APK 문자열만으로 원본 DB 스키마나 모든 기능의 실제 동작을 확정하지 않습니다.

## 저장소 구조
```
lib/
  main.dart
  models/
  screens/
  services/
docs/
  APP_ANALYSIS.md
  FEATURES.md
  BACKEND_SCHEMA.md
  SECURITY_REVIEW.md
pubspec.yaml
```

## 현재 구현
- Flutter + Material 3 앱 기반
- NEIS 학교 검색
- 학교급별 시간표 조회 API 연결
- 날짜별 급식 조회
- 시간표/급식 기본 화면
- Supabase Flutter 초기화 지점(환경변수 제공 시)
- GitHub Actions 정적 분석 및 Android debug APK 빌드

## 로컬 실행
Flutter SDK와 Android SDK가 설치된 환경에서 실행합니다.

```bash
flutter create . --platforms=android --org kr.dingdong
flutter pub get
flutter run --dart-define=NEIS_API_KEY=YOUR_NEIS_KEY
```

Supabase를 활성화할 때는 아래 값을 추가로 전달합니다.

```bash
--dart-define=SUPABASE_URL=YOUR_SUPABASE_URL
--dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

실제 키를 소스코드나 저장소에 커밋하지 마세요. GitHub Actions에서는 Repository Secrets의 `NEIS_API_KEY`를 사용합니다.

## APK 빌드
```bash
flutter build apk --release --dart-define=NEIS_API_KEY=YOUR_NEIS_KEY
```

## 중요한 제한
- 현재 구현은 기능 기반 초기 골격이며, 원본 APK와 동일한 화면/동작을 재현한 상태가 아닙니다.
- Supabase 테이블/RPC/RLS는 정적 문자열만 확인되어 실제 스키마 확보 전까지 연동하지 않습니다.
- Android 홈 화면 위젯, Google 로그인, 광고, 채팅, 과제, 변경 요청은 후속 구현 대상입니다.
- NEIS에 변경 사항이 입력된 뒤 재조회하면 반영할 수 있습니다. NEIS에 아직 등록되지 않은 변경은 앱이 감지할 수 없습니다.
- Android 위젯/백그라운드 갱신은 OS 정책에 따라 지연될 수 있습니다.

## 문서
- [기능 명세](docs/FEATURES.md)
- [백엔드 스키마 확인 목록](docs/BACKEND_SCHEMA.md)
- [보안 검토](docs/SECURITY_REVIEW.md)
