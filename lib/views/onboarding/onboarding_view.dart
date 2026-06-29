//
//  onboarding_view.dart
//  처음 켰을 때 나오는 소개 3장면.
//  좌우로 넘기거나(다음) 버튼으로 진행하고, 마지막에 정원으로 들어갑니다.
//

import 'package:flutter/material.dart';

import '../../data/settings_store.dart';
import '../../theme.dart';
import '../main_tab.dart';

/// 한 장면에 들어가는 내용 묶음.
class _Scene {
  final String emoji;
  final String title;
  final String body;
  const _Scene(this.emoji, this.title, this.body);
}

class OnboardingView extends StatefulWidget {
  final bool returnToPrevious;

  const OnboardingView({super.key, this.returnToPrevious = false});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _controller = PageController();
  int _page = 0;

  static const List<_Scene> _scenes = [
    _Scene(
      '🌱',
      '하루 3분, 마음에 물 주기',
      '행복 한 줄, 1분 숨 고르기, 마음 날씨.\n작은 행동 세 가지면 오늘 몫은 끝이에요.',
    ),
    _Scene(
      '🪴',
      '꾸준함이 정원이 돼요',
      '행동을 채우면 씨앗이 자라고,\n식물 도감이 한 칸씩 채워져요.\n조급할 필요는 없어요.',
    ),
    _Scene(
      '🌙',
      '"오늘은 충분해요"',
      '광고 없음, 알림은 하루 한 번.\n이 앱의 목표는 단 하나 —\n당신이 화면 밖에서 행복한 것.',
    ),
  ];

  bool get _isLast => _page == _scenes.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await markOnboarded(); // 다음부터는 온보딩을 건너뜁니다.
    if (!mounted) return;
    if (widget.returnToPrevious) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainTab()));
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Column(
          children: [
            // 건너뛰기 (마지막 장면에서는 숨김)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isLast ? null : _finish,
                child: Text(
                  _isLast ? '' : '건너뛰기',
                  style: TextStyle(color: AppTheme.sub, fontSize: 13),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _scenes.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => _scenePage(_scenes[i]),
              ),
            ),
            _dots(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _next,
                  child: Text(
                    _isLast ? '시작하기' : '다음',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _scenePage(_Scene scene) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(scene.emoji, style: TextStyle(fontSize: 80)),
          const SizedBox(height: 28),
          Text(
            scene.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.ink,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            scene.body,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: AppTheme.sub, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _dots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_scenes.length, (i) {
        final active = i == _page;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active
                ? AppTheme.green
                : AppTheme.sub.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}
