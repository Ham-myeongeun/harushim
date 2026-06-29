//
//  entry_store.dart
//  하루 기록을 저장/조회하는 도우미 함수 모음.
//  Swift에서 @Query / modelContext 가 하던 일을 여기에 모았습니다.
//

import 'package:hive/hive.dart';
import '../models/daily_entry.dart';

/// 'entries' 박스(=저장 서랍)에 접근하는 통로.
/// main.dart에서 Hive.openBox로 한 번 열어두면 어디서든 이걸로 꺼내 씁니다.
Box<DailyEntry> get entriesBox => Hive.box<DailyEntry>('entries');

/// 날짜를 'YYYY-MM-DD' 문자열 열쇠로 바꿉니다 (시/분은 버려요).
/// 이 열쇠로 그날의 기록 하나를 정확히 찾고 덮어쓸 수 있어요.
String dateKey(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

/// 자정 기준 날짜(시/분/초 0)로 잘라줍니다.
DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

/// 오늘 기록을 가져옵니다. 없으면 새로 만들어 저장한 뒤 돌려줍니다.
DailyEntry ensureTodayEntry() {
  final today = startOfDay(DateTime.now());
  final key = dateKey(today);
  var entry = entriesBox.get(key);
  if (entry == null) {
    entry = DailyEntry(date: today);
    entriesBox.put(key, entry);
  }
  return entry;
}

/// 오늘 기록만 조회 (없으면 null). 화면 그리기용.
DailyEntry? todayEntryOrNull() => entriesBox.get(dateKey(DateTime.now()));

/// 모든 기록을 최신순으로 정렬해 돌려줍니다.
List<DailyEntry> allEntriesNewestFirst() {
  final list = entriesBox.values.toList();
  list.sort((a, b) => b.date.compareTo(a.date));
  return list;
}
