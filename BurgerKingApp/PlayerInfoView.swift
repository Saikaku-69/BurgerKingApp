//
//  PlayerInfoView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/17.
//

import SwiftUI

struct PlayerInfoView: View {
    
    //ネームをクラスに保存
    @ObservedObject var playerRank = PlayerRank.data
    @State private var playerName: String = ""
    @State private var moveToPlay: Bool = false
    @State private var logoSize: CGFloat = 200
    @FocusState private var isFocused: Bool
    @State private var logoOffset:CGFloat = 70
    @State private var waitTime:Double = 0.5
    let maxNameLength = 10
    //Test 3DRotation
    @State private var isFlipped = false
    
    var body: some View {
        
        ZStack {
            Color.black.ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                }
            
            VStack {
                Section(header: Text("プレイヤー名")
                    .foregroundColor(.white)
                    .fontWeight(.bold)) {
                        //文化祭実機のバージョンがiOS 16のため
                        if #available(iOS 17.0, *) {
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
                        } else {
                            // Fallback on earlier versions
                            TextField("名前", text: $playerName)
                                .accentColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(15)
                                .focused($isFocused)
                        }
                    }
                    .frame(width:UIScreen.main.bounds.width/2)
                
                Button(action: {
                    isFocused = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) {
                        logoMove()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            moveToPlay = true
                        }
                    }
                    playerRank.name = playerName
                }) {
                    Text("遊びに行く")
                }
                .padding(.top)
                .disabled(playerName.isEmpty)
            }
            
            VStack {
                Image("KOBtop")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:logoSize)
                    .padding(.horizontal,30)
                    .background(Color.black)
                    .offset(x:-5,y:-logoOffset)
                
                Image("KOBbuttom")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: logoSize)
                    .padding(.horizontal, 30)
                    .background(Color.black)
                    .offset(x:10,y: logoOffset)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onDisappear() {
            isFocused = false
        }
        .fullScreenCover(isPresented:$moveToPlay) {
            GameView()
        }
    }
    
    private func logoMove() {
        withAnimation(.linear(duration:waitTime)) {
            logoOffset -= 80
        }
    }
    
}

#Preview {
    PlayerInfoView()
}
