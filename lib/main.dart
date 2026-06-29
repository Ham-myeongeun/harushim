//
//  main.dart
//  하루쉼 — 앱 진입점 (Swift의 HaruShimApp)
//
//  앱이 시작되면 Hive(로컬 저장소)를 준비하고 MainTab 화면을 띄웁니다.
//

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/notification_service.dart';
import 'data/settings_store.dart';
import 'models/daily_entry.dart';
import 'theme.dart';
import 'views/main_tab.dart';
import 'views/onboarding/onboarding_view.dart';

Future<void> main() async {
  // Flutter가 화면을 그리기 전에 저장소 준비를 먼저 끝내기 위한 한 줄.
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 시작 + DailyEntry 번역기 등록 + 서랍(박스) 열기
  await Hive.initFlutter();
  Hive.registerAdapter(DailyEntryAdapter());
  await Hive.openBox<DailyEntry>('entries');
  await Hive.openBox('settings'); // 온보딩 여부 등 설정값
  await NotificationService.init();

  runApp(const HaruShimApp());
}

class HaruShimApp extends StatelessWidget {
  const HaruShimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: settingsBox.listenable(),
      builder: (context, settings, child) {
        AppTheme.dark = isDarkMode;
        return MaterialApp(
          title: '하루쉼',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.materialTheme(),
          // 처음 켠 사람은 온보딩(소개 3장면), 그 다음부터는 바로 정원으로.
          home: hasOnboarded ? const MainTab() : const OnboardingView(),
        );
      },
    );
  }
}
