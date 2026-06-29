//
//  GardenView.swift
//  메인 정원 — 씨앗과 오늘의 작은 행동 3가지
//

import SwiftUI
import SwiftData

struct GardenView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \DailyEntry.date, order: .reverse) private var entries: [DailyEntry]

    @State private var activeSheet: GardenSheet?
    @State private var showEnough = false

    enum GardenSheet: String, Identifiable {
        case happy, breathe, mood
        var id: String { rawValue }
    }

    /// 오늘 기록 찾기 (생성은 .task에서 한 번만)
    private var today: DailyEntry? {
        let start = Calendar.current.startOfDay(for: .now)
        return entries.first { $0.date == start }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()
                if let today {
                    content(for: today)
                }
            }
            .navigationTitle("하루쉼 🌱")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        HappyVaultView()
                    } label: {
                        Label("기록", systemImage: "archivebox")
                            .font(.caption).foregroundStyle(Theme.sub)
                    }
                }
            }
        }
        // 화면이 처음 뜰 때 오늘 기록이 없으면 하나 만들어 둡니다.
        .task {
            if today == nil { context.insert(DailyEntry()) }
        }
        .sheet(item: $activeSheet) { sheet in
            if let today {
                switch sheet {
                case .happy:   HappyLineSheet(entry: today, onSaved: checkComplete)
                case .breathe: BreathingView(entry: today, onFinished: checkComplete)
                case .mood:    MoodPickerView(entry: today, onPicked: checkComplete)
                }
            }
        }
        .fullScreenCover(isPresented: $showEnough) { EnoughView() }
    }

    private func content(for today: DailyEntry) -> some View {
        let stageEmoji = ["🌰", "🌱", "🌿", "🌸"][today.completedCount]
        let stageName  = ["씨앗", "새싹", "줄기", "꽃"][today.completedCount]

        return ScrollView {
            VStack(spacing: 14) {
                VStack(spacing: 8) {
                    Text(stageEmoji)
                        .font(.system(size: 64))
                        .animation(.bouncy(duration: 0.6), value: today.completedCount)
                    Text("\(stageName) · 오늘의 행동 \(today.completedCount)/3")
                        .font(.caption).foregroundStyle(Theme.green)
                        .padding(.horizontal, 12).padding(.vertical, 5)
                        .background(Theme.greenSoft, in: Capsule())
                }
                .padding(.top, 8)

                questCard(title: "🌼 행복 한 줄",
                          hint: Copy.todays(Copy.prompts),
                          done: today.happyLine != nil) { activeSheet = .happy }
                questCard(title: "🫧 1분 숨 고르기",
                          hint: "원을 따라 천천히 숨을 골라보세요",
                          done: today.didBreathe) { activeSheet = .breathe }
                questCard(title: "🌤️ 마음 날씨",
                          hint: "지금 마음은 어떤 날씨인가요? 탭 한 번이면 끝",
                          done: today.mood != nil) { activeSheet = .mood }

                Text("알림은 하루 한 번 · 광고 없음 · 시들지 않아요")
                    .font(.caption2).foregroundStyle(Theme.sub)
                    .padding(.top, 6)
            }
            .padding(.horizontal, 20)
        }
    }

    /// 3개를 모두 마쳤으면 잠시 뒤 "오늘은 충분해요" 화면을 띄웁니다.
    private func checkComplete() {
        guard today?.isComplete == true else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) { showEnough = true }
    }

    private func questCard(title: String, hint: String, done: Bool,
                           action: @escaping () -> Void) -> some View {
        Button(action: { if !done { action() } }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.subheadline.bold()).foregroundStyle(Theme.ink)
                    Text(hint).font(.caption).foregroundStyle(Theme.sub)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: done ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(done ? Theme.green : Theme.sub.opacity(0.4))
            }
            .padding(16)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 18))
            .opacity(done ? 0.55 : 1)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView().modelContainer(for: DailyEntry.self, inMemory: true)
}
