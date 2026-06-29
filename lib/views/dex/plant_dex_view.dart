//
//  plant_dex_view.dart
//  식물 도감 — 해금 조건과 식물의 작은 철학 (Swift의 PlantDexView)
//

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/entry_store.dart';
import '../../models/daily_entry.dart';
import '../../models/plant_book.dart';
import '../../theme.dart';
import '../help/help_view.dart';

class PlantDexView extends StatelessWidget {
  const PlantDexView({super.key});

  // 잠긴 식물을 흑백으로 보이게 하는 색 필터.
  static const List<double> _grayscale = [
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0, //
    0, 0, 0, 1, 0, //
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        centerTitle: true,
        title: Text(
          '식물 도감 📖',
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
          final stats = UserStats(entriesBox.values.toList());

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: PlantBook.all.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (context, i) {
                    final plant = PlantBook.all[i];
                    final unlocked = plant.unlock(stats);
                    return _plantCell(context, plant, unlocked);
                  },
                ),
                const SizedBox(height: 14),
                Text(
                  '식물마다 작은 철학이 있어요. 탭해서 읽어보세요.\n잠긴 식물은 꾸준함이 열쇠예요 — 조급할 필요는 없어요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: AppTheme.sub),
                ),
                const SizedBox(height: 14),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _plantCell(BuildContext context, Plant plant, bool unlocked) {
    Widget emoji = Text(plant.emoji, style: TextStyle(fontSize: 30));
    if (!unlocked) {
      emoji = ColorFiltered(
        colorFilter: const ColorFilter.matrix(_grayscale),
        child: emoji,
      );
    }

    return Opacity(
      opacity: unlocked ? 1 : 0.45,
      child: Material(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showPlant(context, plant, unlocked),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                emoji,
                const SizedBox(height: 5),
                Text(
                  plant.name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  plant.unlockHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, color: AppTheme.sub),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPlant(BuildContext context, Plant plant, bool unlocked) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.card,
        title: Text(
          '${plant.emoji} ${plant.name}',
          style: TextStyle(color: AppTheme.ink),
        ),
        content: Text(
          unlocked
              ? '"${plant.philosophy}"'
              : '🔒 ${plant.unlockHint}이면 만날 수 있어요',
          style: TextStyle(color: AppTheme.ink),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('닫기', style: TextStyle(color: AppTheme.green)),
          ),
        ],
      ),
    );
  }
}
