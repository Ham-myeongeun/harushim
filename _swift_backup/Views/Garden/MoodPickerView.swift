//
//  MoodPickerView.swift
//  마음 날씨 — 탭 한 번이면 끝
//

import SwiftUI

struct MoodPickerView: View {
    @Bindable var entry: DailyEntry
    var onPicked: () -> Void

    @Environment(\.dismiss) private var dismiss
    private let moods = ["☀️", "⛅", "☁️", "🌧️", "⛈️"]

    var body: some View {
        VStack(spacing: 20) {
            Capsule().fill(Theme.sub.opacity(0.3)).frame(width: 40, height: 5).padding(.top, 10)
            Text("🌤️ 마음 날씨").font(.headline).foregroundStyle(Theme.ink)
            Text("지금 마음은 어떤 날씨인가요?")
                .font(.subheadline).foregroundStyle(Theme.sub)

            HStack(spacing: 14) {
                ForEach(moods, id: \.self) { m in
                    Button {
                        entry.mood = m
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        dismiss()
                        onPicked()
                    } label: {
                        Text(m).font(.system(size: 34))
                            .padding(8)
                            .background(Theme.card, in: RoundedRectangle(cornerRadius: 14))
                    }
                }
            }
            Spacer()
        }
        .presentationDetents([.height(240)])
        .presentationBackground(Theme.bg)
    }
}
