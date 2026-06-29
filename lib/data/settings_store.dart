//
//  settings_store.dart
//  앱 설정값 저장소. 지금은 '온보딩을 봤는지'만 기억합니다.
//

import 'package:hive/hive.dart';

/// 'settings' 박스(설정 서랍)에 접근하는 통로.
Box get settingsBox => Hive.box('settings');

const int defaultReminderHour = 20;
const int defaultReminderMinute = 30;

/// 사용자가 이미 온보딩(소개 화면)을 봤는지 여부.
bool get hasOnboarded =>
    settingsBox.get('onboarded', defaultValue: false) as bool;

/// 온보딩을 끝냈다고 표시 — 다음부터는 바로 정원으로 들어갑니다.
Future<void> markOnboarded() => settingsBox.put('onboarded', true);

/// 온보딩을 다시 볼 수 있게 되돌립니다.
Future<void> resetOnboarding() => settingsBox.put('onboarded', false);

bool get isDarkMode => settingsBox.get('darkMode', defaultValue: false) as bool;

Future<void> setDarkMode(bool value) => settingsBox.put('darkMode', value);

bool get dailyReminderEnabled =>
    settingsBox.get('dailyReminderEnabled', defaultValue: false) as bool;

Future<void> setDailyReminderEnabled(bool value) =>
    settingsBox.put('dailyReminderEnabled', value);

int get reminderHour =>
    settingsBox.get('reminderHour', defaultValue: defaultReminderHour) as int;

int get reminderMinute =>
    settingsBox.get('reminderMinute', defaultValue: defaultReminderMinute)
        as int;

Future<void> setReminderTime(int hour, int minute) async {
  await settingsBox.put('reminderHour', hour);
  await settingsBox.put('reminderMinute', minute);
}
