//
//  TitleRankView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/30.
//

import SwiftUI

struct TitleRankView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ランキング")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.bottom, 10)
            
                HStack(spacing: 12) {
                    Text("準備中です..")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
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
    TitleRankView()
}
