//
//  happy_vault_view.dart
//  기록 🫙 — 힘든 날 꺼내 보는 행복 한 줄과 기분 한마디.
//  + 키워드 검색: 적어둔 기록을 단어로 찾아볼 수 있어요.
//

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/entry_store.dart';
import '../../models/daily_entry.dart';
import '../../theme.dart';

class HappyVaultView extends StatefulWidget {
  const HappyVaultView({super.key});

  @override
  State<HappyVaultView> createState() => _HappyVaultViewState();
}

class _HappyVaultViewState extends State<HappyVaultView> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        elevation: 0,
        centerTitle: true,
        foregroundColor: AppTheme.ink,
        title: Text(
          '기록',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: entriesBox.listenable(),
        builder: (context, Box<DailyEntry> box, _) {
          // 행복 한 줄이나 기분 한마디가 있는 기록만, 최신순으로.
          final all = allEntriesNewestFirst()
              .where((e) => e.happyLine != null || e.dayFeeling != null)
              .toList();

          // 검색어로 거르기 (대소문자 구분 없이, 앞뒤 공백 무시).
          // 행복 한 줄과 하루의 느낌 둘 다에서 찾습니다.
          final q = _query.trim().toLowerCase();
          final lines = q.isEmpty
              ? all
              : all.where((e) {
                  final happy = (e.happyLine ?? '').toLowerCase();
                  final feeling = (e.dayFeeling ?? '').toLowerCase();
                  return happy.contains(q) || feeling.contains(q);
                }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text('🫙', style: TextStyle(fontSize: 44)),
                const SizedBox(height: 8),
                Text(
                  '기록',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '행복 한 줄과 기분 한마디를 모아두었어요.\n힘든 날, 여기를 열어보세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppTheme.sub),
                ),
                const SizedBox(height: 16),

                // 기록이 하나라도 있을 때만 검색창을 보여줍니다.
                if (all.isNotEmpty) _searchBox(),
                if (all.isNotEmpty) const SizedBox(height: 14),

                // 상태별 화면
                if (all.isEmpty)
                  _emptyMessage('아직 비어 있어요.\n오늘의 한마디가 첫 기록이 될 거예요.')
                else if (lines.isEmpty)
                  _emptyMessage('\'$_query\'에 맞는 기록이 없어요.\n다른 단어로 찾아볼까요?')
                else
                  ...lines.map((e) => _lineCard(e)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _searchBox() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value),
      style: TextStyle(fontSize: 14, color: AppTheme.ink),
      decoration: InputDecoration(
        hintText: '기록 검색 (예: 하늘, 커피, 지침)',
        hintStyle: TextStyle(fontSize: 14, color: AppTheme.sub),
        prefixIcon: Icon(Icons.search, size: 20, color: AppTheme.sub),
        // 글자가 있을 때만 X(지우기) 버튼을 보여줍니다.
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                icon: Icon(Icons.close, size: 18, color: AppTheme.sub),
                onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                  FocusScope.of(context).unfocus(); // 키보드 닫기
                },
              ),
        isDense: true,
        filled: true,
        fillColor: AppTheme.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _emptyMessage(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13, color: AppTheme.sub),
      ),
    );
  }

  Widget _lineCard(DailyEntry e) {
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
            '${e.date.month}월 ${e.date.day}일',
            style: TextStyle(fontSize: 10, color: AppTheme.sub),
          ),
          const SizedBox(height: 3),
          if (e.happyLine != null) ...[
            Text(
              e.happyLine!,
              style: TextStyle(fontSize: 13, color: AppTheme.ink),
            ),
          ],
          // 기분 한마디가 있으면 아래에 살짝 옅은 색으로 함께 보여줍니다.
          if (e.dayFeeling != null) ...[
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('💭 ', style: TextStyle(fontSize: 12)),
                Expanded(
                  child: Text(
                    '오늘의 기분 한마디 · ${e.dayFeeling!}',
                    style: TextStyle(fontSize: 12, color: AppTheme.sub),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
