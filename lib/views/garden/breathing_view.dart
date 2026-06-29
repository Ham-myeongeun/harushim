//
//  breathing_view.dart
//  1분 숨 고르기 — 4초 들이쉬고 4초 내쉬기 (Swift의 BreathingView)
//
//  ★ 원래 Swift 코드의 버그 수정:
//    중간에 화면을 닫아도 dispose()에서 타이머와 애니메이션을 확실히 멈춰서
//    메모리에 타이머가 계속 도는 문제를 없앴습니다.
//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/daily_entry.dart';
import '../../theme.dart';

class BreathingView extends StatefulWidget {
  final DailyEntry entry;
  const BreathingView({super.key, required this.entry});

  @override
  State<BreathingView> createState() => _BreathingViewState();
}

class _BreathingViewState extends State<BreathingView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _circle; // 원이 커졌다 작아지는 애니메이션
  Timer? _countdown; // 남은 시간 카운트다운

  bool _running = false;
  int _secondsLeft = 56; // 8초 × 7회 ≈ 1분
  late String _label;

  @override
  void initState() {
    super.initState();
    _label = widget.entry.didBreathe ? '오늘도 완료했어요' : '준비되면 시작을 눌러요';
    _circle =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..addStatusListener((status) {
            if (status == AnimationStatus.forward) {
              setState(() => _label = '들이쉬기');
            } else if (status == AnimationStatus.reverse) {
              setState(() => _label = '내쉬기');
            }
          });
  }

  @override
  void dispose() {
    // ★ 핵심: 화면이 사라질 때 타이머와 애니메이션을 반드시 정리합니다.
    _countdown?.cancel();
    _circle.dispose();
    super.dispose();
  }

  void _start() {
    setState(() {
      _running = true;
      _label = '들이쉬기';
    });
    _circle.repeat(reverse: true); // 들숨↔날숨 반복
    _countdown = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) _finish();
    });
  }

  void _finish() {
    _countdown?.cancel();
    _circle.stop();
    setState(() {
      _running = false;
      _label = '완료 ✨';
    });
    widget.entry.didBreathe = true;
    widget.entry.save();
    HapticFeedback.mediumImpact(); // 완료 진동

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Column(
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
            '🫧 1분 숨 고르기',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 210,
            child: Center(
              child: ScaleTransition(
                // 1.0 → 1.7 배로 부드럽게 커졌다 작아짐
                scale: Tween<double>(begin: 1.0, end: 1.7).animate(
                  CurvedAnimation(parent: _circle, curve: Curves.easeInOut),
                ),
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppTheme.greenSoft,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _label,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppTheme.green),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (_running)
            Text(
              '$_secondsLeft초',
              style: TextStyle(fontSize: 12, color: AppTheme.sub),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _start,
                  child: Text(
                    widget.entry.didBreathe ? '한 번 더 하기' : '시작하기',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
