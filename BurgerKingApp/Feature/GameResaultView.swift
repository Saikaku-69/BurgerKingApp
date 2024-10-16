//
//  GameResaultView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/16.
//

import SwiftUI

struct GameResaultView: View {
    var body: some View {
        VStack {
//                    Image("french")
            //ranking
//            Text(playerName)
            Text("")
            Text("")
            Button(action: {
//                initialGame()
            }) {
                Text("Homeに戻る")
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                    .padding()
                    .background(Color.gameBackgroundColor)
                    .cornerRadius(15)
            }
        }
    }
}

#Preview {
    GameResaultView()
}
