# 딩동 APK 정적 분석 보고서

- 분석 대상: 사용자가 제공한 딩동-release.apk (약 61 MB)
- 분석 방식: APK 내부 파일, Flutter AOT 바이너리 문자열, 의존 라이브러리·리소스 확인
- 분석일: 2026-11-26
- 범위: 정적 분석이며 앱 실행/네트워크 동작은 검증하지 않음.

## 요약
- `libflutter.so`, `libapp.so`, `assets/flutter_assets/` 확인: Flutter 앱으로 판단.
- Dart 식별자 `ssaem_timetable` 확인. Dart 패키지 경로로 보이며 Android applicationId와 같다고 단정할 수 없음.
- Supabase Auth, PostgREST, Realtime, Storage, Edge Functions 사용 흔적.
- Google Sign-In, Google Mobile Ads, WebView, App Links 관련 플러그인/문자열.
- Pretendard Regular/Medium/SemiBold/Bold/ExtraBold 리소스 확인.

## 화면/모듈 식별
아래 기능은 Dart 경로/식별자에 근거한 해석이다. 실행 검증된 UI 명세가 아니다.

| 모듈 | 기능 해석 | 근거 |
|---|---|---|
| screens/login.dart | 로그인 | 경로명 |
| screens/onboarding.dart | 초기 설정 | 경로명 |
| screens/home.dart, student_home.dart | 홈/학생 홈 | 경로명 |
| screens/week_view.dart, my_week.dart | 주간 시간표/개인 일정 | 경로명 |
| screens/class_week.dart | 학급 시간표 | 경로명 |
| screens/periods.dart | 교시 설정/조회 | 경로명 |
| screens/lesson_sheet.dart | 수업 상세 | 경로명 |
| screens/assignments.dart | 과제 | 경로명 |
| screens/meal.dart | 급식 | 경로명 |
| screens/cover_stats.dart | 대체·보강 통계 추정 | 경로명 기반 추정 |
| screens/requests.dart, change_request.dart | 요청/변경 요청 | 경로명 |
| screens/chat.dart | 채팅 | 경로명 |
| screens/more.dart | 설정/추가 메뉴 | 경로명 |

추가 위젯: `widgets/week_grid.dart`, `schedule_card.dart`, `today.dart`, `share_week.dart`, `ad_slot.dart`.
추가 로직/데이터: `logic/timetable.dart`, `core/dates.dart`, `data/api.dart`, `data/auth.dart`, `data/widget_sync.dart`, `models/models.dart`.

## Supabase 단서
프로젝트 URL: `https://jadgrldnmorrjfshtqci.supabase.co`

API 경로 문자열: `/auth/v1`, `/rest/v1`, `/realtime/v1`, `/storage/v1`, `/functions/v1`.

테이블/리소스 후보: `tt_members`, `tt_periods`, `tt_assignments`, `tt_changes`, `tt_electives`, `tt_notes`, `tt_messages`.

RPC/함수 후보: `tt_send_message`, `tt_request_change`, `tt_set_periods`.

필드 문자열 후보: `member_id`, `school_id`, `school_code`, `grade`, `class_nm`, `teacher`, `student`, `requester_id`, `target_id`, `sender_id`, `room_id`, `last_message`, `a_date`, `a_period`, `a_subject`, `b_date`, `b_period`, `b_subject`.

**주의:** 문자열 존재만으로 실제 DB 스키마, 컬럼 타입, RLS 정책, RPC 인자/반환값을 확정할 수 없다. 실제 Supabase 스키마 또는 원본 소스가 필요하다.

## 인증/외부 서비스
- Supabase Auth 및 Google Sign-In 흔적
- Google Mobile Ads Flutter 플러그인
- WebView 및 App Links 관련 플러그인
- OAuth 클라이언트 ID와 Supabase URL은 식별 정보일 수 있다. 서비스 롤 키, 개인 토큰 등 비밀정보 포함 여부는 별도 검사 필요.

## 한계와 후속 자료
이번 분석은 정적 분석이다. AOT에서 원본 Dart 전체를 복원하거나 화면 조작/API 요청/RLS 정책을 검증한 것이 아니다. 정확한 분석을 위해 원본 `lib/`, `pubspec.yaml`, 비밀값을 제거한 Supabase schema-only SQL, 역할별 테스트 절차가 필요하다.
