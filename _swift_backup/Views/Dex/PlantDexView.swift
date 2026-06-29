//
//  PlantDexView.swift
//  식물 도감 — 해금 조건과 식물의 작은 철학
//

import SwiftUI
import SwiftData

struct PlantDexView: View {
    @Query private var entries: [DailyEntry]
    @State private var selected: Plant?

    private var stats: UserStats { UserStats(entries: entries) }
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.bg.ignoresSafeArea()
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(PlantBook.all) { plant in
                            let unlocked = plant.unlock(stats)
                            Button { selected = plant } label: {
                                VStack(spacing: 5) {
                                    Text(plant.emoji).font(.system(size: 30))
                                        .grayscale(unlocked ? 0 : 1)
                                    Text(plant.name).font(.caption.bold())
                                        .foregroundStyle(Theme.ink)
                                    Text(plant.unlockHint).font(.system(size: 10))
                                        .foregroundStyle(Theme.sub)
                                }
                                .frame(maxWidth: .infinity).padding(.vertical, 14)
                                .background(Theme.card, in: RoundedRectangle(cornerRadius: 16))
                                .opacity(unlocked ? 1 : 0.45)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)

                    Text("식물마다 작은 철학이 있어요. 탭해서 읽어보세요.\n잠긴 식물은 꾸준함이 열쇠예요 — 조급할 필요는 없어요.")
                        .font(.caption2).foregroundStyle(Theme.sub)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 14)
                }
            }
            .navigationTitle("식물 도감 📖")
            .navigationBarTitleDisplayMode(.inline)
            .alert(item: $selected) { plant in
                let unlocked = plant.unlock(stats)
                return Alert(
                    title: Text("\(plant.emoji) \(plant.name)"),
                    message: Text(unlocked ? "\"\(plant.philosophy)\""
                                           : "🔒 \(plant.unlockHint)이면 만날 수 있어요"),
                    dismissButton: .default(Text("닫기"))
                )
            }
        }
    }
}

// Alert(item:)에 쓰기 위한 확장
extension Plant: Equatable {
    static func == (lhs: Plant, rhs: Plant) -> Bool { lhs.id == rhs.id }
}
