//
//  happy_line_sheet.dart
//  행복 한 줄 입력 시트 (Swift의 HappyLineSheet)
//

import 'package:flutter/material.dart';

import '../../content/copy.dart';
import '../../models/daily_entry.dart';
import '../../theme.dart';

class HappyLineSheet extends StatefulWidget {
  final DailyEntry entry;
  const HappyLineSheet({super.key, required this.entry});

  @override
  State<HappyLineSheet> createState() => _HappyLineSheetState();
}

class _HappyLineSheetState extends State<HappyLineSheet> {
  final _controller = TextEditingController();
  final _feelingController = TextEditingController();
  String _placeholder = '한 줄이면 충분해요';

  @override
  void initState() {
    super.initState();
    // 이미 적어둔 내용이 있으면 불러와서 이어서 고칠 수 있게 합니다.
    _controller.text = widget.entry.happyLine ?? '';
    _feelingController.text = widget.entry.dayFeeling ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    _feelingController.dispose();
    super.dispose();
  }

  void _save() {
    final trimmed = _controller.text.trim();
    final feeling = _feelingController.text.trim();
    if (trimmed.isEmpty && feeling.isEmpty) {
      setState(() => _placeholder = '한 글자라도 괜찮아요 :)');
      return;
    }
    widget.entry.happyLine = trimmed.isEmpty ? null : trimmed;
    // 기분 한마디는 선택 입력 — 비어 있으면 null로 저장합니다.
    widget.entry.dayFeeling = feeling.isEmpty ? null : feeling;
    widget.entry.save(); // Hive에 저장
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // 키보드가 올라올 때 시트가 가려지지 않도록 아래 여백을 줍니다.
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, bottomInset + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: AppTheme.sub.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '🌼 행복 한 줄',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            Copy.todays(Copy.prompts),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: AppTheme.sub),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 3,
            minLines: 3,
            decoration: InputDecoration(
              hintText: _placeholder,
              filled: true,
              fillColor: AppTheme.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          // ── 오늘의 기분 한마디 (선택 입력) ────────────────────────
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  '💭 오늘의 기분 한마디',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.ink,
                  ),
                ),
                SizedBox(width: 6),
                Text(
                  '(선택)',
                  style: TextStyle(fontSize: 12, color: AppTheme.sub),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _feelingController,
            minLines: 2,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '예: 지쳤지만 괜찮았어요 / 조금 가벼워졌어요',
              filled: true,
              fillColor: AppTheme.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '짧아도 길어도 괜찮아요. 오늘을 지나온 마음만 남겨도 돼요.',
              style: TextStyle(fontSize: 11, color: AppTheme.sub, height: 1.4),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.green,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _save,
              child: Text(
                '저장하기',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
