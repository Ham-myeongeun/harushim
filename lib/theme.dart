//
//  theme.dart
//  앱 전체에서 쓰는 색 (Swift의 Theme enum을 옮긴 것)
//  Assets에 색을 등록하지 않아도 되도록 코드로 정의합니다.
//

import 'package:flutter/material.dart';

class AppTheme {
  static bool dark = false;

  static const Color _lightBg = Color(0xFFF3EFE7);
  static const Color _lightCard = Color(0xFFFFFDF8);
  static const Color _lightInk = Color(0xFF4A4540);
  static const Color _lightSub = Color(0xFF8D857B);
  static const Color _lightGreenSoft = Color(0xFFE3ECDD);

  static const Color _darkBg = Color(0xFF171A18);
  static const Color _darkCard = Color(0xFF242822);
  static const Color _darkInk = Color(0xFFECE7DE);
  static const Color _darkSub = Color(0xFFB4ADA2);
  static const Color _darkGreenSoft = Color(0xFF2D3B2A);

  static Color get bg => dark ? _darkBg : _lightBg; // 배경
  static Color get card => dark ? _darkCard : _lightCard; // 카드 배경
  static Color get ink => dark ? _darkInk : _lightInk; // 진한 글자
  static Color get sub => dark ? _darkSub : _lightSub; // 옅은 글자
  static Color get green => const Color(0xFF7A9D6F); // 포인트 초록
  static Color get greenSoft =>
      dark ? _darkGreenSoft : _lightGreenSoft; // 연한 초록

  static ThemeData materialTheme() {
    final scheme = ColorScheme.fromSeed(
      seedColor: green,
      brightness: dark ? Brightness.dark : Brightness.light,
    );

    return ThemeData(
      scaffoldBackgroundColor: bg,
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: ink,
        elevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: card,
        titleTextStyle: TextStyle(
          color: ink,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: TextStyle(color: ink, fontSize: 14),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
