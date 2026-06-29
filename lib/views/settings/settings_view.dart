//
//  settings_view.dart
//  알림, 다크모드, 개인정보 안내처럼 출시 전 신뢰도를 높이는 설정 화면.
//

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/entry_store.dart';
import '../../data/notification_service.dart';
import '../../data/settings_store.dart';
import '../../theme.dart';
import '../onboarding/onboarding_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _busy = false;

  String get _timeLabel {
    final hour = reminderHour;
    final minute = reminderMinute.toString().padLeft(2, '0');
    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$period $displayHour:$minute';
  }

  Future<void> _toggleReminder(bool value) async {
    setState(() => _busy = true);
    if (value) {
      final ok = await NotificationService.scheduleDailyReminder(
        hour: reminderHour,
        minute: reminderMinute,
      );
      if (ok) {
        await setDailyReminderEnabled(true);
      } else if (mounted) {
        _message('알림 권한이 꺼져 있어요. 기기 설정에서 허용해 주세요.');
      }
    } else {
      await NotificationService.cancelDailyReminder();
      await setDailyReminderEnabled(false);
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _clearEntries() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('기록을 초기화할까요?'),
        content: Text('행복 한 줄, 마음 날씨, 숨 고르기 완료 기록이 모두 지워져요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('취소', style: TextStyle(color: AppTheme.sub)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('초기화', style: TextStyle(color: AppTheme.green)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await entriesBox.clear();
    ensureTodayEntry();
    if (mounted) _message('기록을 비웠어요.');
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: settingsBox.listenable(),
      builder: (context, settings, child) {
        return Scaffold(
          backgroundColor: AppTheme.bg,
          appBar: AppBar(
            backgroundColor: AppTheme.bg,
            elevation: 0,
            centerTitle: true,
            title: Text(
              '설정',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppTheme.ink,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _sectionTitle('사용감'),
              _tile(
                icon: Icons.dark_mode_outlined,
                title: '다크모드',
                subtitle: '밤에도 눈부시지 않게 볼 수 있어요.',
                trailing: Switch(
                  value: isDarkMode,
                  activeThumbColor: AppTheme.green,
                  onChanged: setDarkMode,
                ),
              ),
              const SizedBox(height: 12),
              _tile(
                icon: Icons.notifications_none,
                title: '하루 한 번 알림',
                subtitle: dailyReminderEnabled
                    ? '매일 $_timeLabel에 마음 돌봄을 알려드려요.'
                    : '켜면 매일 $_timeLabel에 짧게 찾아갈게요.',
                trailing: Switch(
                  value: dailyReminderEnabled,
                  activeThumbColor: AppTheme.green,
                  onChanged: _busy ? null : _toggleReminder,
                ),
              ),
              const SizedBox(height: 24),
              _sectionTitle('데이터'),
              _infoCard(
                icon: Icons.lock_outline,
                title: '기록은 이 기기 안에만 저장돼요',
                body:
                    '하루쉼은 행복 한 줄과 마음 날씨를 로컬 저장소에 보관합니다. 서버로 전송하거나 계정에 연결하지 않아요.',
              ),
              const SizedBox(height: 12),
              _tile(
                icon: Icons.restart_alt,
                title: '온보딩 다시 보기',
                subtitle: '처음 안내 화면을 다시 확인해요.',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const OnboardingView(returnToPrevious: true),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _tile(
                icon: Icons.delete_outline,
                title: '기록 초기화',
                subtitle: '이 기기에 저장된 마음 기록을 비워요.',
                onTap: _clearEntries,
              ),
              const SizedBox(height: 24),
              _sectionTitle('다음 버전'),
              _infoCard(
                icon: Icons.screenshot_monitor_outlined,
                title: '잠금화면 문구 위젯',
                body:
                    '짧은 쉼 문구 20개는 준비되어 있어요. 네이티브 위젯은 v1.1에서 붙이는 방향으로 남겨두었습니다.',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppTheme.sub,
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: AppTheme.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 22, color: AppTheme.green),
              const SizedBox(width: 14),
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
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.sub,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing,
              ] else
                Icon(Icons.chevron_right, size: 20, color: AppTheme.sub),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.greenSoft,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: AppTheme.green),
          const SizedBox(width: 14),
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
                const SizedBox(height: 5),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.ink,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
