//
//  RankingView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/20.
//

import SwiftUI

class PlayerRank:ObservableObject {
    static let data = PlayerRank()
    @Published var name:String = ""
    @Published var score:Int = 0
}

struct RankingView:View {
    @ObservedObject var playerRank = PlayerRank.data
    @AppStorage("playerName") var pName:String = ""
    @AppStorage("playerScore") var pScore:Int = 0
    var body: some View {
        ZStack {
            Image("bklogotop")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:200)
                .offset(y:-110)
            Image("bklogobottom")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:200)
                .offset(y:110)
            VStack(alignment: .leading) {
                ForEach(0..<4,id: \.self) { data in
                    HStack {
                        Image("trophyGold")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                        Text("\(pName)さん")
                        Spacer()
                        Image("Burger")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                        Text("\(pScore)個")
                    }
                    .padding(5)
                    .background(Color.resultTxtColor)
                    .cornerRadius(15)
                }
            }
            .frame(width: UIScreen.main.bounds.width/1.4)
            .padding(10)
            .background(Color.black)
            .cornerRadius(20)
            .onAppear() {
                if playerRank.score > pScore {
                    pName = playerRank.name
                    pScore = playerRank.score
                }
            }
        }
    }
}
#Preview {
    RankingView()
}
