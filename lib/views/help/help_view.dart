//
//  help_view.dart
//  도움받기 — 마음이 많이 힘들 때 닿을 수 있는 곳.
//  (이 앱은 치료가 아니라, 곁에 있어줄 사람에게 다리를 놓아주는 역할이에요.)
//
//  ⚠️ 출시 전, 상담 연락처가 최신인지 꼭 확인하고, 가능하면 전문가 검토를 받으세요.
//

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme.dart';

/// 어느 화면에서든 같은 모양으로 쓰는 '도움' 버튼 (AppBar actions에 넣어요).
Widget helpAction(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(right: 8),
    child: TextButton.icon(
      onPressed: () => Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const HelpView())),
      style: TextButton.styleFrom(
        backgroundColor: AppTheme.greenSoft,
        foregroundColor: AppTheme.green,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      icon: Icon(Icons.favorite, size: 16, color: AppTheme.green),
      label: Text(
        '도움',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppTheme.green,
        ),
      ),
    ),
  );
}

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  Future<void> _call(String number) async {
    await launchUrl(Uri(scheme: 'tel', path: number));
  }

  Future<void> _open(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        foregroundColor: AppTheme.ink,
        title: Text(
          '도움받기',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              '💛',
              style: TextStyle(fontSize: 44),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              '혼자 견디지 않아도 돼요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '하루가 너무 견디기 힘들 땐 혼자 버티지 않아도 괜찮아요.\n'
              '믿을 수 있는 사람, 전문가, 상담 창구 중 닿을 수 있는 곳에 도움을 요청해보세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppTheme.sub, height: 1.6),
            ),
            const SizedBox(height: 10),
            Text(
              '지금 붙잡을 손잡이가 필요할 때, 아래 연락처가 곁에 있어요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: AppTheme.sub, height: 1.5),
            ),
            const SizedBox(height: 24),

            // ── 전화 상담 ──────────────────────────────
            _ResourceCard(
              emoji: '📞',
              title: '자살예방 상담전화',
              subtitle: '109 · 24시간 · 무료',
              actionLabel: '전화 걸기',
              onTap: () => _call('109'),
            ),
            const SizedBox(height: 12),
            _ResourceCard(
              emoji: '📞',
              title: '정신건강 위기상담',
              subtitle: '1577-0199 · 24시간 · 무료',
              actionLabel: '전화 걸기',
              onTap: () => _call('15770199'),
            ),
            const SizedBox(height: 12),
            _ResourceCard(
              emoji: '🧑‍🤝‍🧑',
              title: '청소년 상담 1388',
              subtitle: '1388 · 청소년과 보호자를 위한 상담',
              actionLabel: '전화 걸기',
              onTap: () => _call('1388'),
            ),

            const SizedBox(height: 22),
            Text(
              '전화가 부담스러우면, 글로도 괜찮아요',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 12),
            _ResourceCard(
              emoji: '💬',
              title: '생명의전화 사이버상담',
              subtitle: '말 대신 글로 마음을 나눌 수 있어요',
              actionLabel: '열기',
              onTap: () => _open('https://www.lifeline.or.kr'),
            ),
            const SizedBox(height: 12),
            _ResourceCard(
              emoji: '💬',
              title: '청소년 사이버상담',
              subtitle: '채팅·게시판으로 1388 상담을 받을 수 있어요',
              actionLabel: '열기',
              onTap: () => _open('https://www.cyber1388.kr'),
            ),
            const SizedBox(height: 12),
            _ResourceCard(
              emoji: '🌙',
              title: '자살예방 상담 안내',
              subtitle: '109와 온라인 상담 정보를 확인할 수 있어요',
              actionLabel: '열기',
              onTap: () => _open('https://www.129.go.kr/109'),
            ),

            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.greenSoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '하루쉼은 치료나 진단을 대신하지 않는 작은 마음 돌봄 도구예요.\n'
                '지금 많이 위급하거나 스스로를 해칠 것 같다면, 앱보다 먼저 109 또는 119에 연락해 주세요.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.ink,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  const _ResourceCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
              Text(emoji, style: TextStyle(fontSize: 26)),
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
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: AppTheme.sub),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.green,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  actionLabel,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
