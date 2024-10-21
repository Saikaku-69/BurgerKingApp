//
//  PlayerInfoView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/17.
//

import SwiftUI

struct PlayerInfoView: View {
    @ObservedObject var playerRank = PlayerRank.data
    @State private var playerName: String = ""
    @State private var MoveToPlay: Bool = false
    @State private var logoSize: CGFloat = 150
    @FocusState private var isFocused: Bool
    @State private var logoOffset:CGFloat = -80
    @State private var waitTime:Double = 0.5
    @State private var showBurgers:Bool = false
    let maxNameLength = 10
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isFocused = false
                }
            VStack {
                Section(header: Text("プレーヤーネーム")
                    .foregroundColor(.white)
                    .fontWeight(.bold)) {
                        TextField("名前", text: $playerName)
                            .accentColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(15)
                            .focused($isFocused)
                            .onChange(of: playerName) {
                                if playerName.count > maxNameLength {
                                    playerName = String(playerName.prefix(maxNameLength))
                                }
                            }
                    }
                    .frame(width:UIScreen.main.bounds.width/2)
                Button(action: {
                    isFocused = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
                        logoMove()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showBurgers = true
                        }
                    }
                    //player name 処理
                    playerRank.name = playerName
                }) {
                    Text("遊びに行く")
                }
                .padding(.top)
                .disabled(playerName.isEmpty)
            }
            VStack {
                Image("bklogotop")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:logoSize)
                    .padding(.horizontal,30)
                    .background(Color.black)
                    .offset(y:logoOffset)
                Image("bklogobottom")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:logoSize)
                    .padding(.horizontal,30)
                    .background(Color.black)
                    .offset(y:-logoOffset)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDisappear() {
            isFocused = false
        }
        .fullScreenCover(isPresented:$showBurgers) {
            GameView()
        }
    }
    private func logoMove() {
        withAnimation(.linear(duration:waitTime)) {
            logoOffset += 85
        }
    }
}

#Preview {
    PlayerInfoView()
}
