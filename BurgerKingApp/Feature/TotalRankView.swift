//
//  TotalRankView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/20.
//

import SwiftUI

struct TotalRankView: View {
    @State private var backToGameView:Bool = false
    var body: some View {
        Button(action: {
            backToGameView = true
        }, label: {
            Text("Total_Rank")
            Image(systemName: "arrow.backward")
        })
        .fullScreenCover(isPresented: $backToGameView) {
            GameView()
        }
    }
}

#Preview {
    TotalRankView()
}
