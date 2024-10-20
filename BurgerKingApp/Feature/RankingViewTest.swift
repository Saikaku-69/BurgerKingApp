////
////  RankingViewTest.swift
////  BurgerKingApp
////
////  Created by cmStudent on 2024/10/20.
////
//
//import SwiftUI
////struct Player: Codable, Identifiable {
////    var id = UUID()
////    var pName: String
////    var pScore: Int
////}
//class PlayerRank:ObservableObject {
//    static let data = PlayerRank()
//    @Published var name:String = ""
//    @Published var score:Int = 0
////    @AppStorage("playerData") var playerData: Data = Data()
////    @Published var players: [Player] = [] {
////            didSet {
////                savePlayers()
////            }
////        }
////        init() {
////            loadPlayers()
////        }
////        // 将 players 数组编码为 JSON 并存储
////        private func savePlayers() {
////            if let encodedData = try? JSONEncoder().encode(players) {
////                playerData = encodedData
////            }
////        }
////        // 从存储的 JSON 数据中解码为 players 数组
////        private func loadPlayers() {
////            if let decodedPlayers = try? JSONDecoder().decode([Player].self, from: playerData) {
////                players = decodedPlayers
////            }
////        }
//}
//
//struct RankingViewTest:View {
//    @ObservedObject var playerRank = PlayerRank.data
////    @State private var playerRanking: [String] = []
//    @AppStorage("playerName") var pName:String = ""
//    @AppStorage("playerScore") var pScore:Int = 0
//    var body: some View {
//        ZStack {
//            Image("bklogotop")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width:200)
//                .offset(y:-110)
//            Image("bklogobottom")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width:200)
//                .offset(y:110)
//            VStack(alignment: .leading) {
//                ForEach(0..<4,id: \.self) { data in
//                    HStack {
//                        Image("trophyGold")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 30)
//                        Text("\(pName)さん")
//                        Spacer()
//                        Image("Burger")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 30)
//                        Text("\(pScore)個")
//                    }
//                    .padding(5)
//                    .background(Color.resultTxtColor)
//                    .cornerRadius(15)
//                }
////                Text("\(playerRank.name) = \(playerRank.score)")
////                    .padding(5)
////                    .background(Color.resultTxtColor)
////                    .cornerRadius(15)
////                ForEach(playerRank.players) { player in
////                    Text("\(player.pName) = \(player.pScore)")
////                        .padding(5)
////                        .background(Color.resultTxtColor)
////                        .cornerRadius(15)
////                }
//            }
//            .frame(width: UIScreen.main.bounds.width/1.4)
//            .padding(10)
//            .background(Color.black)
//            .cornerRadius(20)
//            .onAppear() {
//                pName = playerRank.name
//                pScore = playerRank.score
//            }
//        }
//    }
//}
//
//#Preview {
//    RankingViewTest()
//}
