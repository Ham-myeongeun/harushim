// 하루쉼 기본 점검 테스트
//
// 화면 테스트는 Hive(저장소) 준비가 필요해서, 여기서는 데이터/문구가
// 올바르게 들어 있는지만 가볍게 확인합니다.

import 'package:flutter_test/flutter_test.dart';

import 'package:harushim/content/copy.dart';
import 'package:harushim/models/daily_entry.dart';
import 'package:harushim/models/plant_book.dart';

void main() {
  test('문구가 비어 있지 않다', () {
    expect(Copy.prompts.length, 30);
    expect(Copy.enoughMessages.length, 20);
    expect(Copy.lockScreenPhrases.length, 20);
    expect(Copy.notifications.length, 10);
  });

  test('식물 도감은 12종이고 첫 식물은 기본 해금이다', () {
    expect(PlantBook.all.length, 12);
    final stats = UserStats([]);
    expect(PlantBook.all.first.unlock(stats), true);
  });

  test('행동 3개를 채우면 완료 상태가 된다', () {
    final entry = DailyEntry(date: DateTime(2026, 1, 1));
    expect(entry.completedCount, 0);
    expect(entry.isComplete, false);

    entry.happyLine = '오늘 하늘이 예뻤다';
    entry.didBreathe = true;
    entry.mood = '☀️';

    expect(entry.completedCount, 3);
    expect(entry.isComplete, true);
  });
}
