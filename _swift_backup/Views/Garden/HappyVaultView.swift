//
//  HappyVaultView.swift
//  행복 저금통 🫙 — 힘든 날 꺼내 보는 행복 한 줄 보관함
//

import SwiftUI
import SwiftData

struct HappyVaultView: View {
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]

    private var lines: [DailyEntry] { entries.filter { $0.happyLine != nil } }

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 10) {
                    Text("🫙").font(.system(size: 44)).padding(.top, 10)
                    Text("행복 저금통").font(.headline).foregroundStyle(Theme.ink)
                    Text("그동안 모은 행복 한 줄이에요.\n힘든 날, 여기를 열어보세요.")
                        .font(.caption).foregroundStyle(Theme.sub)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)

                    if lines.isEmpty {
                        Text("아직 비어 있어요.\n오늘의 행복 한 줄이 첫 동전이 될 거예요.")
                            .font(.footnote).foregroundStyle(Theme.sub)
                            .multilineTextAlignment(.center)
                            .padding(.top, 30)
                    } else {
                        ForEach(lines) { e in
                            VStack(alignment: .leading, spacing: 3) {
                                Text(e.date.formatted(.dateTime.month().day()
                                        .locale(Locale(identifier: "ko_KR"))))
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
        .navigationTitle("기록")
        .navigationBarTitleDisplayMode(.inline)
    }
}
