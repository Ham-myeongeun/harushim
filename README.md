# 하루쉼 — Flutter 버전 v0.1

정원(행동 3가지 → 씨앗 성장 → "오늘은 충분해요") + 식물 도감 + 주간 회고 + 행복 저금통 + 도움받기 + 설정.
원래 SwiftUI로 만들던 것을 **Flutter(Dart)** 로 옮긴 버전입니다.
맥 없이 윈도우/리눅스 PC에서 안드로이드 앱을 바로 만들고 실행할 수 있어요.

## 모토

하루쉼은 거창한 변화를 요구하지 않습니다. 오늘 하루가 벼랑처럼 느껴지는 사람에게 작은 손잡이 하나를 건네고, 사용자가 다시 자기 하루로 돌아가게 돕는 앱입니다.

## 처음 실행하는 법 (초보용)

1. Flutter SDK 설치 (https://docs.flutter.dev/get-started/install — Windows 선택)
2. 안드로이드 스튜디오 설치 → 에뮬레이터(가상 폰) 하나 만들기,
   또는 안드로이드 폰을 USB로 연결하고 "USB 디버깅" 켜기
3. 이 폴더(`HaruShim`)를 안드로이드 스튜디오나 VS Code로 열기
4. 터미널에서 아래 두 줄 실행
   ```
   flutter pub get      # 필요한 패키지(hive 등) 내려받기
   flutter run          # 앱 실행
   ```
5. 코드를 고친 뒤에는 터미널에서 `r` 키 한 번 → 바로 화면에 반영(핫 리로드)

## 파일 구성

```
pubspec.yaml                의존성 목록 (hive, 알림 패키지 추가됨)
lib/
  main.dart                 앱 진입점 (Hive 준비 + MainTab 띄우기)
  theme.dart                라이트/다크 색 테마
  data/
    entry_store.dart        하루 기록 저장/조회 도우미 (Swift의 @Query 역할)
    notification_service.dart 하루 1회 알림 예약/해제
    settings_store.dart     온보딩, 다크모드, 알림 설정 저장
  models/
    daily_entry.dart        하루 기록 모델(Hive) + 통계
    plant_book.dart         식물 도감 12종 (해금 조건 포함)
  content/
    copy.dart               모든 문구 (유도 질문 30, 충분해요 20, 잠금화면 20, 알림 10)
  views/
    main_tab.dart           하단 탭 4개
    garden/
      garden_view.dart      메인 정원
      happy_line_sheet.dart 행복 한 줄 입력
      breathing_view.dart   1분 숨 고르기 (★ 타이머 버그 수정됨)
      mood_picker_view.dart 마음 날씨
      enough_view.dart      "오늘은 충분해요"
      happy_vault_view.dart 행복 저금통 🫙
    dex/plant_dex_view.dart 식물 도감
    help/help_view.dart     위기 상담/도움받기
    review/weekly_review_view.dart 주간 회고
    settings/settings_view.dart 설정, 개인정보 안내, 데이터 초기화
_swift_backup/              예전 SwiftUI 코드 (참고용 백업, 빌드와 무관)
```

## 데이터 저장

SwiftData 대신 **Hive**(가벼운 로컬 데이터베이스)를 씁니다.
하루 기록은 `entries` 박스에 'YYYY-MM-DD' 열쇠로 저장되고,
화면은 박스가 바뀔 때마다(`ValueListenableBuilder`) 자동으로 새로 그려집니다.
기록은 기기 안에만 저장되며, 서버나 계정으로 전송하지 않습니다.

## 스토어 안전 고지 문구

하루가 너무 견디기 힘들 땐 혼자 버티지 않아도 괜찮아요. 믿을 수 있는 사람, 전문가, 상담 창구 중 닿을 수 있는 곳에 도움을 요청해보세요.

하루쉼은 치료나 진단을 대신하지 않는 작은 마음 돌봄 도구입니다. 지금 많이 위급하거나 스스로를 해칠 것 같다면, 앱보다 먼저 109 또는 119에 연락해 주세요.

## 스토어 제출 파일

- Google Play/Android App Bundle: `build/app/outputs/bundle/release/app-release.aab`
- 원스토어/릴리즈 APK: `build/app/outputs/flutter-apk/app-release.apk`
- 개인정보처리방침 초안: `개인정보처리방침.md`

## 들어간 기능

- [x] 온보딩 3장면
- [x] 하루 1회 알림 (`flutter_local_notifications`)
- [x] 도움받기 화면 보강 (109, 1577-0199, 1388, 사이버상담 링크)
- [x] 설정 화면 (다크모드, 알림, 온보딩 다시 보기, 기록 초기화)
- [x] 개인정보/로컬 저장 안내
- [x] 다크 모드 색 대응

## 아직 없는 것 (다음 단계)

- [ ] 잠금화면 위젯 (v1.1 후보)
- [ ] 앱 아이콘
- [ ] 결제 (v1.1 — in_app_purchase 패키지)

## 동작 확인 포인트

- 행동 3개 완료 → 씨앗이 🌰→🌱→🌿→🌸로 자라고 "오늘은 충분해요"가 뜨는지
- 앱을 껐다 켜도 오늘 기록이 유지되는지 (Hive 저장 확인)
- 숨 고르기를 중간에 닫아도 멈추는지 (버그 수정 확인)
- 도감에서 잠긴 식물 탭 → 해금 조건 안내가 뜨는지
- 설정에서 다크모드 토글 → 전체 화면 색이 즉시 바뀌는지
- 설정에서 하루 1회 알림 토글 → 권한 요청 후 켜짐 상태가 저장되는지
```
flutter test    # 데이터/문구 기본 점검 테스트 실행
flutter build appbundle    # Android 업로드용 AAB 빌드
```
