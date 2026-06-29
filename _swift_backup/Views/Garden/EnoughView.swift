//
//  EnoughView.swift
//  "오늘은 충분해요" — 이 앱의 시그니처 화면
//

import SwiftUI

struct EnoughView: View {
    @Environment(\.dismiss) private var dismiss
    private let message = Copy.enoughMessages.randomElement()!

    var body: some View {
        ZStack {
            Theme.bg.ignoresSafeArea()
            VStack(spacing: 18) {
                Text("🌙").font(.system(size: 56))
                Text("오늘은 충분해요")
                    .font(.title2.bold()).foregroundStyle(Theme.ink)
                Text(message)
                    .font(.subheadline).foregroundStyle(Theme.sub)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal, 36)
                Button("정원 한 번 더 보기") { dismiss() }
                    .font(.caption).foregroundStyle(Theme.sub)
                    .padding(.horizontal, 22).padding(.vertical, 10)
                    .overlay(Capsule().stroke(Theme.sub.opacity(0.3)))
                    .padding(.top, 16)
            }
        }
    }
}

#Preview { EnoughView() }
