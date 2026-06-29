//
//  HaruShimApp.swift
//  하루쉼 — 앱 진입점
//
//  앱이 시작되면 MainTabView를 띄우고,
//  SwiftData 저장소(DailyEntry)를 앱 전체에서 쓸 수 있게 연결합니다.
//

import SwiftUI
import SwiftData

@main
struct HaruShimApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        // 이 한 줄이 "로컬 데이터베이스 준비"의 전부입니다.
        .modelContainer(for: DailyEntry.self)
    }
}
