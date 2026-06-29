//
//  weekly_review_view.dart
//  주간 회고 — 이번 주 마음 날씨와 행복 한 줄 모음 (Swift의 WeeklyReviewView)
//

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/entry_store.dart';
import '../../models/daily_entry.dart';
import '../../theme.dart';
import '../help/help_view.dart';

class WeeklyReviewView extends StatelessWidget {
  const WeeklyReviewView({super.key});

  static const List<String> _weekdayShort = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '주간 회고 🌤️',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
        ),
        actions: [helpAction(context)],
      ),
      body: ValueListenableBuilder(
        valueListenable: entriesBox.listenable(),
        builder: (context, Box<DailyEntry> box, _) {
          final lastWeek = _lastWeekEntries();
          final happyLines = lastWeek
              .where((e) => e.happyLine != null)
              .toList();
          final feelingLines = lastWeek
              .where((e) => e.dayFeeling != null)
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '이번 주 마음 날씨',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.ink,
                  ),
                ),
                const SizedBox(height: 16),
                _weekRow(lastWeek),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.greenSoft,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _summaryText(lastWeek),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.ink,
                      height: 1.5,
                    ),
                  ),
                ),
                if (happyLines.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    '이번 주의 행복 한 줄',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...happyLines.map((e) => _happyCard(e)),
                ],
                if (feelingLines.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    '이번 주의 기분 한마디',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...feelingLines.map((e) => _feelingCard(e)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  /// 최근 7일 기록 (오늘 포함), 과거→오늘 순서.
  List<DailyEntry> _lastWeekEntries() {
    final cutoff = startOfDay(DateTime.now()).subtract(const Duration(days: 6));
    final list = entriesBox.values
        .where((e) => !e.date.isBefore(cutoff))
        .toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  Widget _weekRow(List<DailyEntry> lastWeek) {
    final today = startOfDay(DateTime.now());
    return Row(
      children: List.generate(7, (i) {
        final day = today.subtract(Duration(days: 6 - i));
        final entry = lastWeek
            .where((e) => e.date == day)
            .cast<DailyEntry?>()
            .firstWhere((e) => true, orElse: () => null);
        final label = _weekdayShort[day.weekday - 1];
        final mood = entry?.mood ?? '·';
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: AppTheme.sub),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(mood, style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _happyCard(DailyEntry e) {
    final weekdayFull = '${_weekdayShort[e.date.weekday - 1]}요일';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weekdayFull,
            style: TextStyle(fontSize: 10, color: AppTheme.sub),
          ),
          const SizedBox(height: 3),
          Text(
            e.happyLine ?? '',
            style: TextStyle(fontSize: 13, color: AppTheme.ink),
          ),
        ],
      ),
    );
  }

  Widget _feelingCard(DailyEntry e) {
    final weekdayFull = '${_weekdayShort[e.date.weekday - 1]}요일';
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('💭 ', style: TextStyle(fontSize: 13)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weekdayFull,
                  style: TextStyle(fontSize: 10, color: AppTheme.sub),
                ),
                const SizedBox(height: 3),
                Text(
                  e.dayFeeling ?? '',
                  style: TextStyle(fontSize: 13, color: AppTheme.ink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _summaryText(List<DailyEntry> lastWeek) {
    final moods = lastWeek.map((e) => e.mood).whereType<String>().toList();
    if (moods.isEmpty) {
      return '기록이 적은 주도 당신의 한 주예요. 🌱';
    }
    final sunny = moods.where((m) => m == '☀️' || m == '⛅').length;
    if (sunny >= moods.length ~/ 2 + 1) {
      return '이번 주는 맑은 날이 많았어요. 그 좋은 기운, 기억해두세요. 🌱';
    } else {
      return '흐린 날에도 기록하러 와준 것 — 그게 내면의 힘이에요. 🌱';
    }
  }
}
