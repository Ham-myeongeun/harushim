//
//  garden_view.dart
//  메인 정원 — 씨앗과 오늘의 작은 행동 3가지 (Swift의 GardenView)
//

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../content/copy.dart';
import '../../data/entry_store.dart';
import '../../models/daily_entry.dart';
import '../../theme.dart';
import 'breathing_view.dart';
import 'enough_view.dart';
import 'happy_line_sheet.dart';
import 'happy_vault_view.dart';
import 'mood_picker_view.dart';
import '../help/help_view.dart';

class GardenView extends StatefulWidget {
  const GardenView({super.key});

  @override
  State<GardenView> createState() => _GardenViewState();
}

class _GardenViewState extends State<GardenView> {
  @override
  void initState() {
    super.initState();
    // 화면이 처음 뜰 때 오늘 기록이 없으면 하나 만들어 둡니다.
    ensureTodayEntry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '하루쉼 🌱',
          style: TextStyle(
            color: AppTheme.ink,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          helpAction(context),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const HappyVaultView())),
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.greenSoft, // 옅은 초록 배경으로 눈에 띄게
                foregroundColor: AppTheme.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              icon: Icon(
                Icons.archive_outlined,
                size: 20,
                color: AppTheme.green,
              ),
              label: Text(
                '기록',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.green,
                ),
              ),
            ),
          ),
        ],
      ),
      // entriesBox가 바뀔 때마다(저장될 때마다) 화면을 자동으로 다시 그립니다.
      body: ValueListenableBuilder(
        valueListenable: entriesBox.listenable(),
        builder: (context, Box<DailyEntry> box, _) {
          final today = todayEntryOrNull();
          if (today == null) {
            return const SizedBox.shrink();
          }
          return _buildContent(today);
        },
      ),
    );
  }

  Widget _buildContent(DailyEntry today) {
    final stageEmoji = ['🌰', '🌱', '🌿', '🌸'][today.completedCount];
    final stageName = ['씨앗', '새싹', '줄기', '꽃'][today.completedCount];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // 자라나는 씨앗 (완료 개수에 따라 이모지가 바뀜)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Text(
              stageEmoji,
              key: ValueKey(stageEmoji),
              style: TextStyle(fontSize: 64),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.greenSoft,
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: Text(
              '$stageName · 오늘의 행동 ${today.completedCount}/3',
              style: TextStyle(fontSize: 12, color: AppTheme.green),
            ),
          ),
          const SizedBox(height: 14),
          _questCard(
            title: '🌼 행복 한 줄',
            hint: today.dayFeeling != null && today.happyLine == null
                ? '기분 한마디를 남겼어요 · 행복 한 줄은 비워둬도 괜찮아요'
                : Copy.todays(Copy.prompts),
            done: today.happyLine != null,
            onTap: () => _openSheet(today, _SheetKind.happy),
          ),
          const SizedBox(height: 14),
          _questCard(
            title: '🫧 1분 숨 고르기',
            hint: '원을 따라 천천히 숨을 골라보세요',
            done: today.didBreathe,
            onTap: () => _openSheet(today, _SheetKind.breathe),
          ),
          const SizedBox(height: 14),
          _questCard(
            title: '🌤️ 마음 날씨',
            hint: '지금 마음은 어떤 날씨인가요? 탭 한 번이면 끝',
            done: today.mood != null,
            onTap: () => _openSheet(today, _SheetKind.mood),
          ),
          const SizedBox(height: 18),
          Text(
            '알림은 하루 한 번 · 광고 없음 · 시들지 않아요',
            style: TextStyle(fontSize: 11, color: AppTheme.sub),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// 시트(바텀시트)를 열고, 닫힌 뒤 '방금 3개를 다 채웠는지' 확인합니다.
  Future<void> _openSheet(DailyEntry today, _SheetKind kind) async {
    final wasComplete = today.isComplete;

    switch (kind) {
      case _SheetKind.happy:
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppTheme.bg,
          builder: (_) => HappyLineSheet(entry: today),
        );
        break;
      case _SheetKind.breathe:
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppTheme.bg,
          builder: (_) => BreathingView(entry: today),
        );
        break;
      case _SheetKind.mood:
        await showModalBottomSheet(
          context: context,
          backgroundColor: AppTheme.bg,
          builder: (_) => MoodPickerView(entry: today),
        );
        break;
    }

    if (!mounted) return;
    // 이번 행동으로 '미완료 → 완료'가 됐다면 "오늘은 충분해요"를 띄웁니다.
    if (!wasComplete && today.isComplete) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => const EnoughView(),
        ),
      );
    }
  }

  Widget _questCard({
    required String title,
    required String hint,
    required bool done,
    required VoidCallback onTap,
  }) {
    final displayHint = done ? '완료했어요 · 다시 눌러 볼 수 있어요' : hint;

    return Opacity(
      opacity: done ? 0.78 : 1,
      child: Material(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        displayHint,
                        style: TextStyle(fontSize: 12, color: AppTheme.sub),
                      ),
                    ],
                  ),
                ),
                Icon(
                  done ? Icons.check_circle : Icons.circle_outlined,
                  color: done
                      ? AppTheme.green
                      : AppTheme.sub.withValues(alpha: 0.4),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _SheetKind { happy, breathe, mood }
