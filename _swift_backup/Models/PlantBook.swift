//
//  PlantBook.swift
//  식물 도감 — 사용자 데이터가 아닌, 앱에 박아두는 정적 데이터
//

import Foundation

struct Plant: Identifiable {
    let id: Int
    let emoji: String
    let name: String
    let unlockHint: String
    let philosophy: String
    let isPremium: Bool
    let unlock: (UserStats) -> Bool
}

enum PlantBook {
    static let all: [Plant] = [
        Plant(id: 1,  emoji: "🌱", name: "새싹이",     unlockHint: "기본 제공",
              philosophy: "모든 시작은 작아요. 그래서 소중해요.",
              isPremium: false, unlock: { _ in true }),
        Plant(id: 2,  emoji: "🌼", name: "데이지",     unlockHint: "3일 완료",
              philosophy: "평범한 날들이 모여 꽃이 돼요.",
              isPremium: false, unlock: { $0.totalCompleteDays >= 3 }),
        Plant(id: 3,  emoji: "🌷", name: "튤립",       unlockHint: "7일 완료",
              philosophy: "봄은 기다린 사람에게 와요.",
              isPremium: false, unlock: { $0.totalCompleteDays >= 7 }),
        Plant(id: 4,  emoji: "🍀", name: "네잎클로버", unlockHint: "행복 10줄",
              philosophy: "행운은 기록하는 사람 눈에 띄어요.",
              isPremium: false, unlock: { $0.happyLineCount >= 10 }),
        Plant(id: 5,  emoji: "🌻", name: "해바라기",   unlockHint: "14일 완료",
              philosophy: "해를 보는 습관이 키를 키워요.",
              isPremium: true,  unlock: { $0.totalCompleteDays >= 14 }),
        Plant(id: 6,  emoji: "🌵", name: "선인장",     unlockHint: "숨 고르기 10회",
              philosophy: "물을 자주 안 줘도 살아요. 당신의 속도면 충분해요.",
              isPremium: true,  unlock: { $0.breatheCount >= 10 }),
        Plant(id: 7,  emoji: "🍁", name: "단풍나무",   unlockHint: "21일 완료",
              philosophy: "물드는 데는 시간이 필요해요.",
              isPremium: true,  unlock: { $0.totalCompleteDays >= 21 }),
        Plant(id: 8,  emoji: "🌹", name: "장미",       unlockHint: "30일 완료",
              philosophy: "가시가 있어도 꽃은 꽃이에요.",
              isPremium: true,  unlock: { $0.totalCompleteDays >= 30 }),
        Plant(id: 9,  emoji: "🪴", name: "몬스테라",   unlockHint: "40일 완료",
              philosophy: "구멍이 나도 괜찮아요. 그게 자란 흔적이에요.",
              isPremium: true,  unlock: { $0.totalCompleteDays >= 40 }),
        Plant(id: 10, emoji: "🎍", name: "대나무",     unlockHint: "50일 완료",
              philosophy: "곧게 자라는 마음.",
              isPremium: true,  unlock: { $0.totalCompleteDays >= 50 }),
        Plant(id: 11, emoji: "❄️", name: "눈꽃나무",   unlockHint: "겨울 한정",
              philosophy: "추운 계절에도 자라는 게 있어요.",
              isPremium: true,  unlock: { _ in [12,1,2].contains(Calendar.current.component(.month, from: .now)) }),
        Plant(id: 12, emoji: "🌸", name: "벚꽃",       unlockHint: "봄 한정",
              philosophy: "잠깐이라서 더 아름다워요.",
              isPremium: true,  unlock: { _ in [3,4,5].contains(Calendar.current.component(.month, from: .now)) })
    ]
}
