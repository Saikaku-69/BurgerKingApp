//
//  GameResaultView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/16.
//

import SwiftUI
class countData:ObservableObject {
    static let shared = countData()
    @Published var getBurgerCount:Int = 0
    @Published var totalGameTime:Double = 60
    @Published var getGoldBurgerCount:Int = 0
    @Published var bonusTime:Double = 0
}
struct countStr:Identifiable {
    let id = UUID()
    var imgName: String
    var Txt: String
    var data: String
}
struct GameResultView: View {
    @ObservedObject var countdata = countData.shared
    
    var body: some View {
        let countstr = [countStr(imgName:"Burger", Txt:"消化したバーガーの数:",data:"\(countdata.getBurgerCount)"),
                        countStr(imgName: "GoldBurger", Txt:"ゴールドバーガー:",data:"\(countdata.getGoldBurgerCount)"),
                        countStr(imgName: "grafup", Txt:"消化量増加持続時間:",data:"\(Int(countdata.bonusTime))s"),
                        countStr(imgName: "clock", Txt:"トータルゲーム時間:",data:"\(Int(countdata.totalGameTime))s")
        ]
        VStack(alignment: .leading) {
                ForEach(countstr) { item in
                    HStack {
                        Image(item.imgName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:30)
                        Text(item.Txt)
                            Spacer()
                            Text(item.data)
                }
            }
        }
    }
}

#Preview {
    GameResultView()
}
