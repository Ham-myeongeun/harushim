//
//  mood_picker_view.dart
//  마음 날씨 — 묻고, 답에 반응해주기. (Swift의 MoodPickerView 확장)
//  날씨를 고르면 짧게 한마디를 건네고, 흐린 날엔 '도움받기' 손을 내밉니다.
//

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/daily_entry.dart';
import '../../theme.dart';
import '../help/help_view.dart';

class MoodPickerView extends StatefulWidget {
  final DailyEntry entry;
  const MoodPickerView({super.key, required this.entry});

  @override
  State<MoodPickerView> createState() => _MoodPickerViewState();
}

class _MoodPickerViewState extends State<MoodPickerView> {
  static const List<String> _moods = ['☀️', '⛅', '☁️', '🌧️', '⛈️'];

  String? _selected; // null이면 아직 고르는 중

  bool get _isHard => _selected == '🌧️' || _selected == '⛈️';
  bool get _isStormy => _selected == '⛈️';

  String get _reply {
    switch (_selected) {
      case '☀️':
        return '좋은 날이네요. 그 기분, 오래 기억해두세요.';
      case '⛅':
        return '괜찮은 하루였군요. 그걸 알아차린 것도 멋져요.';
      case '☁️':
        return '무던한 날도 당신의 하루예요. 와줘서 고마워요.';
      case '🌧️':
        return '오늘 마음이 좀 무거웠군요. 여기 와줘서 고마워요.';
      case '⛈️':
        return '오늘 많이 힘들었군요. 그래도 잘 버텨냈어요.';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();
    _selected = widget.entry.mood;
  }

  void _pick(String m) {
    widget.entry.mood = m;
    widget.entry.save();
    HapticFeedback.lightImpact();
    setState(() => _selected = m);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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
            const SizedBox(height: 20),
            _selected == null ? _picker() : _response(),
          ],
        ),
      ),
    );
  }

  Widget _picker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '🌤️ 마음 날씨',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '지금 마음은 어떤 날씨인가요?',
          style: TextStyle(fontSize: 14, color: AppTheme.sub),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _moods.map((m) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _pick(m),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(m, style: TextStyle(fontSize: 34)),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _response() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_selected!, style: TextStyle(fontSize: 44)),
        const SizedBox(height: 14),
        Text(
          _reply,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: AppTheme.ink, height: 1.5),
        ),

        // ⛈️ 폭풍우 날엔 더 깊은 한마디 (힘든 날의 한마디)
        if (_isStormy) ...[
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.greenSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              '거울을 보고, 오늘도 무사히 스스로를 해치지 않고 지나왔음에\n'
              '스스로를 칭찬해 주세요. 혼자 견디지 않아도 돼요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppTheme.ink, height: 1.6),
            ),
          ),
        ],

        const SizedBox(height: 18),

        // 🌧️·⛈️ 힘든 날엔 도움받기 손 내밀기
        if (_isHard) ...[
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.green,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final nav = Navigator.of(context);
                nav.pop(); // 시트 닫고
                nav.push(MaterialPageRoute(builder: (_) => const HelpView()));
              },
              icon: Icon(Icons.favorite, size: 18, color: Colors.white),
              label: Text(
                '마음이 힘들 땐, 도움받기',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],

        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () => setState(() => _selected = null),
            child: Text(
              '다시 고르기',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.green,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.sub,
              side: BorderSide(color: AppTheme.sub.withValues(alpha: 0.3)),
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
            child: Text('정원으로 돌아가기', style: TextStyle(fontSize: 14)),
          ),
        ),
      ],
    );
  }
}
