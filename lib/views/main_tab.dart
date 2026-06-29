//
//  main_tab.dart
//  하단 탭 3개: 정원 · 도감 · 회고 (Swift의 MainTabView)
//

import 'package:flutter/material.dart';

import '../theme.dart';
import 'garden/garden_view.dart';
import 'dex/plant_dex_view.dart';
import 'review/weekly_review_view.dart';
import 'settings/settings_view.dart';

class MainTab extends StatefulWidget {
  const MainTab({super.key});

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  int _index = 0;

  final List<Widget> _pages = const [
    GardenView(),
    PlantDexView(),
    WeeklyReviewView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      // IndexedStack: 탭을 옮겨다녀도 각 화면 상태를 유지합니다.
      body: IndexedStack(index: _index, children: _pages),
      // 탭바를 본문과 또렷이 분리하기 위해, 불투명 배경 + 위쪽 경계선 + 옅은 그림자를
      // 가진 Container로 감쌉니다. (흰색 위 흰색이라 안 보이는 문제 방지)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.card, // 불투명 배경 — 본문이 비치지 않게
          border: Border(
            top: BorderSide(color: AppTheme.sub.withValues(alpha: 0.15)),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.sub.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          backgroundColor: Colors.transparent, // 뒤의 Container 색을 그대로 사용
          elevation: 0,
          indicatorColor: AppTheme.greenSoft,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.eco_outlined),
              selectedIcon: Icon(Icons.eco, color: AppTheme.green),
              label: '정원',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book, color: AppTheme.green),
              label: '도감',
            ),
            NavigationDestination(
              icon: Icon(Icons.cloud_outlined),
              selectedIcon: Icon(Icons.cloud, color: AppTheme.green),
              label: '회고',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: AppTheme.green),
              label: '설정',
            ),
          ],
        ),
      ),
    );
  }
}
