//
//  RuleView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/22.
//

import SwiftUI

struct Items: Identifiable {
    let id = UUID()
    var img: String
    var imgName: String
    var explanation: String
}

let items = [
    Items(img: "Burger", imgName: "バーガー", explanation: "消化量+1"),
    Items(img: "GoldBurger", imgName: "ゴールドバーガー", explanation: "消化量+20"),
    Items(img: "grafup", imgName: "UP", explanation: "消化量2倍"),
    Items(img: "clock", imgName: "時計", explanation: "プレイ時間5秒追加"),
    Items(img: "hammer", imgName: "ハンマー", explanation: "土台を一階壊す"),
    Items(img: "vagetable", imgName: "野菜", explanation: "邪魔者が出る"),
]

struct RuleView: View {
    var body: some View {
        VStack(alignment:.center,spacing:0) {
            Text("たくさんのバーガーをGETしよう！")
            .font(.caption)
            .padding(.bottom,15)
            ForEach(items) { index in
                HStack {
                    Image(index.img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:20)
                    Text(index.imgName)
                        .font(.caption)
                    Spacer()
                    Text(index.explanation)
                        .font(.caption2)
                }
                .padding(5)
            }
        }
        .foregroundColor(.blue)
        .padding(5)
        .background(.black)
        .frame(width:UIScreen.main.bounds.width/1.5)
        .border(.blue)
    }
}

#Preview {
    RuleView()
}
