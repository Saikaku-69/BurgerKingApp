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
    Items(img: "clock", imgName: "時計", explanation: "プレイ時間5s追加"),
    Items(img: "hammer", imgName: "ハンマー", explanation: "生成された土台を一階戻す"),
    Items(img: "vagetable", imgName: "野菜", explanation: "邪魔者が出る"),
]

struct RuleView: View {
    var body: some View {
        VStack(spacing:0) {
            ForEach(items) { index in
                HStack {
                    Image(index.img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:30)
                    Text(index.imgName)
                        .font(.caption)
                    Spacer()
                    Text(index.explanation)
                        .font(.caption2)
                }
                .foregroundColor(.blue)
                .padding(5)
                .frame(width:UIScreen.main.bounds.width/1.5)
            }
        }
        .background(.black)
        .border(.blue)
    }
}

#Preview {
    RuleView()
}
