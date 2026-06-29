//
//  daily_entry.dart
//  하루의 기록 — 앱의 유일한 사용자 데이터 모델 (Swift의 DailyEntry)
//
//  Hive(로컬 저장소)에 저장하기 위해 HiveObject를 상속합니다.
//  HiveObject를 상속하면, 값을 바꾼 뒤 entry.save() 한 줄로 저장됩니다.
//

import 'package:hive/hive.dart';

class DailyEntry extends HiveObject {
  DateTime date; // 그 날 (자정 기준으로 저장)
  String? happyLine; // 행복 한 줄 — 오늘 행복했던 일 (null이면 아직 안 씀)
  String? dayFeeling; // 오늘의 기분 한마디 (선택 입력, null이면 안 씀)
  bool didBreathe; // 1분 숨 고르기 완료 여부
  String? mood; // "☀️" "⛅" "☁️" "🌧️" "⛈️" 중 하나

  DailyEntry({
    required this.date,
    this.happyLine,
    this.dayFeeling,
    this.didBreathe = false,
    this.mood,
  });

  /// 오늘 행동을 몇 개 했는지 (0~3)
  int get completedCount => [
    happyLine != null,
    didBreathe,
    mood != null,
  ].where((done) => done).length;

  /// 3개 모두 완료했는지
  bool get isComplete => completedCount == 3;
}

/// Hive에게 "DailyEntry를 어떻게 저장하고 불러오는지" 알려주는 번역기.
/// (Swift에는 없던 부분 — Hive를 코드 생성 없이 쓰기 위해 직접 작성했어요.)
class DailyEntryAdapter extends TypeAdapter<DailyEntry> {
  @override
  final int typeId = 0;

  @override
  DailyEntry read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return DailyEntry(
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      happyLine: map['happyLine'] as String?,
      // 예전에 저장된 기록에는 'dayFeeling' 열쇠가 없어요 → 자동으로 null이 됩니다.
      dayFeeling: map['dayFeeling'] as String?,
      didBreathe: map['didBreathe'] as bool? ?? false,
      mood: map['mood'] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyEntry obj) {
    writer.writeMap({
      'date': obj.date.millisecondsSinceEpoch,
      'happyLine': obj.happyLine,
      'dayFeeling': obj.dayFeeling,
      'didBreathe': obj.didBreathe,
      'mood': obj.mood,
    });
  }
}

/// 도감 해금 판단용 통계 — 저장하지 않고 기록에서 매번 계산합니다.
class UserStats {
  final int totalCompleteDays;
  final int happyLineCount;
  final int breatheCount;

  UserStats(List<DailyEntry> entries)
    : totalCompleteDays = entries.where((e) => e.isComplete).length,
      happyLineCount = entries.where((e) => e.happyLine != null).length,
      breatheCount = entries.where((e) => e.didBreathe).length;
}
