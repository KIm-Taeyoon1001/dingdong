# Backend Schema — 검증 대기

이 문서는 APK 문자열에서 확인된 리소스 후보만 기록한다. 실제 DB 스키마가 아니다.

- Supabase URL: `https://jadgrldnmorrjfshtqci.supabase.co`
- 서비스 흔적: Auth, PostgREST, Realtime, Storage, Edge Functions

## 테이블/리소스 후보
`tt_members`, `tt_periods`, `tt_assignments`, `tt_changes`, `tt_electives`, `tt_notes`, `tt_messages`.

## RPC 후보
`tt_send_message`, `tt_request_change`, `tt_set_periods`.

## 필드 문자열 후보
`member_id`, `school_id`, `school_code`, `grade`, `class_nm`, `teacher`, `student`, `requester_id`, `target_id`, `sender_id`, `room_id`, `last_message`, `a_date`, `a_period`, `a_subject`, `b_date`, `b_period`, `b_subject`.

## 스키마 확정에 필요한 자료
1. Supabase schema-only SQL
2. RLS 정책 및 인덱스
3. RPC 함수 정의/인자
4. Storage bucket 정책
5. Edge Function 소스

서비스 롤 키, 개인 토큰, 사용자 데이터는 공유하거나 저장소에 올리지 않는다.
