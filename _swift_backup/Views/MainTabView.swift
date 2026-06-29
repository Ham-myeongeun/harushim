//
//  MainTabView.swift
//  하단 탭 3개: 정원 · 도감 · 회고
//

import SwiftUI

/// 앱 전체에서 쓰는 색 (Assets에 색을 등록하지 않아도 되도록 코드로 정의)
enum Theme {
    static let bg        = Color(red: 0.953, green: 0.937, blue: 0.906)  // #F3EFE7
    static let card      = Color(red: 1.0,   green: 0.992, blue: 0.973)  // #FFFDF8
    static let ink       = Color(red: 0.290, green: 0.271, blue: 0.251)  // #4A4540
    static let sub       = Color(red: 0.553, green: 0.522, blue: 0.482)  // #8D857B
    static let green     = Color(red: 0.478, green: 0.616, blue: 0.435)  // #7A9D6F
    static let greenSoft = Color(red: 0.890, green: 0.925, blue: 0.867)  // #E3ECDD
}

struct MainTabView: View {
    var body: some View {
        TabView {
            GardenView()
                .tabItem { Label("정원", systemImage: "leaf.fill") }
            PlantDexView()
                .tabItem { Label("도감", systemImage: "book.fill") }
            WeeklyReviewView()
                .tabItem { Label("회고", systemImage: "cloud.sun.fill") }
        }
        .tint(Theme.green)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: DailyEntry.self, inMemory: true)
}
