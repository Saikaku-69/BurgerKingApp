//
//  PlayerInfoView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/17.
//

import SwiftUI

struct PlayerInfoView: View {
    @State private var playerName: String = ""
    @State private var MoveToPlay: Bool = false
    @State private var showBugers: Bool = false
    @State private var logoSize: CGFloat = 150
    @FocusState private var isFocused: Bool
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack {
                Image("bklogotop")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:logoSize)
                    .padding(.bottom,40)
                Section(header: Text("基本情報")
                    .foregroundColor(.white)
                    .fontWeight(.bold)) {
                        TextField("名前", text: $playerName)
                            .accentColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(15)
                            .focused($isFocused)
                    }
                    .frame(width:UIScreen.main.bounds.width/2)
                Button(action: {
                    MoveToPlay = true
                    showBugers = true
                }) {
                    Text("遊びに行く")
                }
                .padding(.top)
                .disabled(playerName.isEmpty)
                Image("bklogobottom")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:logoSize)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $showBugers) {
            GameView()
        }
        .onDisappear() {
            isFocused = false
        }
    }
}

#Preview {
    PlayerInfoView()
}
