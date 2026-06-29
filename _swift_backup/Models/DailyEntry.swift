//
//  DailyEntry.swift
//  하루의 기록 — 앱의 유일한 사용자 데이터 모델
//

import Foundation
import SwiftData

@Model
final class DailyEntry {
    var date: Date              // 그 날 (자정 기준으로 저장)
    var happyLine: String?      // 행복 한 줄 (nil이면 아직 안 씀)
    var didBreathe: Bool        // 1분 숨 고르기 완료 여부
    var mood: String?           // "☀️" "⛅" "☁️" "🌧️" "⛈️" 중 하나

    /// 오늘 행동을 몇 개 했는지 (0~3)
    var completedCount: Int {
        [happyLine != nil, didBreathe, mood != nil].filter { $0 }.count
    }

    /// 3개 모두 완료했는지
    var isComplete: Bool { completedCount == 3 }

    init(date: Date = .now) {
        self.date = Calendar.current.startOfDay(for: date)
        self.didBreathe = false
    }
}

/// 도감 해금 판단용 통계 — 저장하지 않고 기록에서 매번 계산합니다.
struct UserStats {
    let totalCompleteDays: Int
    let happyLineCount: Int
    let breatheCount: Int

    init(entries: [DailyEntry]) {
        totalCompleteDays = entries.filter { $0.isComplete }.count
        happyLineCount    = entries.filter { $0.happyLine != nil }.count
        breatheCount      = entries.filter { $0.didBreathe }.count
    }
}
