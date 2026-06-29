//
//  BreathingView.swift
//  1분 숨 고르기 — 4초 들이쉬고 4초 내쉬기 × 7회 ≈ 1분
//

import SwiftUI

struct BreathingView: View {
    @Bindable var entry: DailyEntry
    var onFinished: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var inhale = false
    @State private var running = false
    @State private var secondsLeft = 56          // 8초 × 7회
    @State private var label = "준비되면 시작을 눌러요"

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 28) {
            Capsule().fill(Theme.sub.opacity(0.3)).frame(width: 40, height: 5).padding(.top, 10)
            Text("🫧 1분 숨 고르기").font(.headline).foregroundStyle(Theme.ink)

            ZStack {
                Circle().fill(Theme.greenSoft)
                    .frame(width: 110, height: 110)
                    .scaleEffect(inhale ? 1.7 : 1.0)
                    .animation(.easeInOut(duration: 4), value: inhale)
                Text(label).font(.caption).foregroundStyle(Theme.green)
                    .frame(width: 90)
                    .multilineTextAlignment(.center)
            }
            .frame(height: 210)

            if running {
                Text("\(secondsLeft)초").font(.caption).foregroundStyle(Theme.sub)
            } else {
                Button {
                    running = true
                    breatheLoop()
                } label: {
                    Text("시작하기")
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(Theme.green, in: RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 24)
            }
            Spacer()
        }
        .presentationDetents([.height(420)])
        .presentationBackground(Theme.bg)
        .onReceive(timer) { _ in
            guard running, secondsLeft > 0 else { return }
            secondsLeft -= 1
            if secondsLeft == 0 { finish() }
        }
    }

    /// 4초 간격으로 들숨/날숨을 반복합니다.
    private func breatheLoop() {
        label = "들이쉬기"
        inhale = true
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { t in
            if !running || secondsLeft <= 0 { t.invalidate(); return }
            inhale.toggle()
            label = inhale ? "들이쉬기" : "내쉬기"
        }
    }

    private func finish() {
        running = false
        label = "완료 ✨"
        entry.didBreathe = true
        // 진동 한 번 — 0.5초짜리 감정 디테일
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            dismiss()
            onFinished()
        }
    }
}
