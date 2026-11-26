# Security Review

## APK에서 확인된 흔적
- Supabase 프로젝트 URL 및 Auth/PostgREST/Realtime/Storage/Functions 경로
- Google Sign-In 관련 라이브러리/식별자
- Google Mobile Ads 플러그인
- WebView 및 App Links 관련 플러그인

## 필수 보안 요구사항
- 클라이언트에는 Supabase anon/publishable key만 사용한다. service_role key는 앱/저장소/CI에 포함하지 않는다.
- 사용자 데이터 테이블에 RLS를 적용한다.
- 학교/학급 소속과 역할을 클라이언트 입력만으로 신뢰하지 않는다.
- 채팅/요청은 참여자만 접근하도록 제한한다.
- OAuth redirect URI와 Android SHA 지문을 검증한다.
- API 키는 dart-define 또는 CI secret으로 주입한다.
- 로그에 토큰, 개인정보, 메시지 본문을 남기지 않는다.
- 딥링크 입력을 검증한다.

## 미확인 사항
APK 내 관리자 키/개인 토큰 존재 여부, 실제 RLS, OAuth 설정, Storage 공개 여부, Edge Function 인증, 광고 동의/개인정보 처리.

## 출시 전 체크리스트
- [ ] APK/AAB secret scan
- [ ] 익명/학생/교사/타 학급 사용자별 RLS 테스트
- [ ] OAuth redirect 검증
- [ ] 딥링크 검증
- [ ] 개인정보 처리방침 검토
- [ ] 로그의 민감정보 제거
