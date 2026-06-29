//
//  enough_view.dart
//  "오늘은 충분해요" — 이 앱의 시그니처 화면 (Swift의 EnoughView)
//

import 'dart:math';

import 'package:flutter/material.dart';

import '../../content/copy.dart';
import '../../theme.dart';

class EnoughView extends StatefulWidget {
  const EnoughView({super.key});

  @override
  State<EnoughView> createState() => _EnoughViewState();
}

class _EnoughViewState extends State<EnoughView> {
  // 화면이 만들어질 때 문구 하나를 무작위로 골라 고정합니다.
  late final String _message =
      Copy.enoughMessages[Random().nextInt(Copy.enoughMessages.length)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🌙', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 18),
              Text(
                '오늘은 충분해요',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.ink,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                _message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.sub,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 34),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.sub,
                  side: BorderSide(color: AppTheme.sub.withValues(alpha: 0.3)),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 10,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('정원 한 번 더 보기', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
