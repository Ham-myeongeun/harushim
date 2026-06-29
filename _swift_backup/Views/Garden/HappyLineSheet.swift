//
//  HappyLineSheet.swift
//  행복 한 줄 입력 시트
//

import SwiftUI

struct HappyLineSheet: View {
    @Bindable var entry: DailyEntry
    var onSaved: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    @State private var placeholder = "한 줄이면 충분해요"

    var body: some View {
        VStack(spacing: 16) {
            Capsule().fill(Theme.sub.opacity(0.3)).frame(width: 40, height: 5).padding(.top, 10)
            Text("🌼 행복 한 줄").font(.headline).foregroundStyle(Theme.ink)
            Text(Copy.todays(Copy.prompts))
                .font(.subheadline).foregroundStyle(Theme.sub)
                .multilineTextAlignment(.center)

            TextField(placeholder, text: $text, axis: .vertical)
                .lineLimit(3, reservesSpace: true)
                .padding(12)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: 12))

            Button {
                let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else {
                    placeholder = "한 글자라도 괜찮아요 :)"
                    return
                }
                entry.happyLine = trimmed
                dismiss()
                onSaved()
            } label: {
                Text("저장하기")
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity).padding(.vertical, 12)
                    .background(Theme.green, in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.white)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .presentationDetents([.height(320)])
        .presentationBackground(Theme.bg)
    }
}
