//
//  WeeklyReviewView.swift
//  주간 회고 — 이번 주 마음 날씨와 행복 한 줄 모음
//

import SwiftUI
import SwiftData

struct WeeklyReviewView: View {
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]

    /// 최근 7일의 기록 (오늘 포함)
    private var lastWeek: [DailyEntry] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -6,
                                           to: Calendar.current.startOfDay(for: .now))!
        return entries.filter { $0.date >= cutoff }.sorted { $0.date < $1.date }
    }

    private var happyLines: [DailyEntry] {
        lastWeek.filter { $0.happyLine != nil }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        Text("이번 주 마음 날씨")
                            .font(.subheadline.bold()).foregroundStyle(Theme.ink)

                        HStack(spacing: 6) {
                            ForEach(weekDays(), id: \.0) { day, mood in
                                VStack(spacing: 6) {
                                    Text(day).font(.caption2).foregroundStyle(Theme.sub)
                                    Text(mood).font(.title3)
                                        .frame(maxWidth: .infinity).padding(.vertical, 8)
                                        .background(Theme.card, in: RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }

                        Text(summaryText())
                            .font(.footnote).foregroundStyle(Theme.ink)
                            .lineSpacing(5)
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Theme.greenSoft, in: RoundedRectangle(cornerRadius: 16))

                        if !happyLines.isEmpty {
                            Text("이번 주의 행복 한 줄")
                                .font(.subheadline.bold()).foregroundStyle(Theme.ink)
                                .padding(.top, 4)
                            ForEach(happyLines) { e in
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(e.date.formatted(.dateTime.weekday(.wide).locale(Locale(identifier: "ko_KR"))))
                                        .font(.system(size: 10)).foregroundStyle(Theme.sub)
                                    Text(e.happyLine ?? "")
                                        .font(.footnote).foregroundStyle(Theme.ink)
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Theme.card, in: RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .navigationTitle("주간 회고 🌤️")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    /// 요일 라벨 + 기록된 마음 날씨 (없는 날은 ·)
    private func weekDays() -> [(String, String)] {
        let cal = Calendar.current
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "ko_KR")
        fmt.dateFormat = "E"
        return (0..<7).reversed().map { offset in
            let day = cal.date(byAdding: .day, value: -offset,
                               to: cal.startOfDay(for: .now))!
            let entry = lastWeek.first { $0.date == day }
            return (fmt.string(from: day), entry?.mood ?? "·")
        }
    }

    private func summaryText() -> String {
        let moods = lastWeek.compactMap(\.mood)
        if moods.isEmpty {
            return "기록이 적은 주도 당신의 한 주예요. 🌱"
        }
        let sunny = moods.filter { $0 == "☀️" || $0 == "⛅" }.count
        if sunny >= moods.count / 2 + 1 {
            return "이번 주는 맑은 날이 많았어요. 그 좋은 기운, 기억해두세요. 🌱"
        } else {
            return "흐린 날에도 기록하러 와준 것 — 그게 내면의 힘이에요. 🌱"
        }
    }
}
