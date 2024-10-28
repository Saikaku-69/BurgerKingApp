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
    var explanation: String
}

let items = [
    Items(img: "Burger", explanation: "スコア+1"),
    Items(img: "GoldBurger", explanation: "スコア+10"),
    Items(img: "grafup", explanation: "時間内スコア2倍"),
    Items(img: "clock", explanation: "ゲーム時間+3秒"),
    Items(img: "hammer", explanation: "土台1階段破壊"),
    Items(img: "hatena", explanation: "ランダム"),
    Items(img: "vagetable", explanation: "障害物")
]

struct RuleView: View {
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("アイテム紹介")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.bottom, 10)
            
            ForEach(items) { item in
                HStack(spacing: 12) {
                    Image(item.img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .padding(.trailing, 6)
                    
                    Text(item.explanation)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .foregroundColor(.white)
        .background(Color.black)
        .cornerRadius(15)
        .frame(width: UIScreen.main.bounds.width * 0.85) // 调整宽度占比以适应 iPhone 屏幕
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}

#Preview {
//    RuleView()
    GameView()
}
