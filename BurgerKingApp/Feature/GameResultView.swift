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
    @Published var totalGameTime:Double = 30
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
        let countstr = [countStr(imgName:"Burger", Txt:"消化したバーガー:",data:"\(countdata.getBurgerCount)"),
                        countStr(imgName: "GoldBurger", Txt:"ゴールドバーガー:",data:"\(countdata.getGoldBurgerCount)"),
                        countStr(imgName: "grafup", Txt:"消化量増加持続時間:",data:"\(Int(countdata.bonusTime))s"),
                        countStr(imgName: "clock", Txt:"トータルゲーム時間:",data:"\(Int(countdata.totalGameTime))s")
        ]
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
                ForEach(countstr) { item in
                    HStack {
                        Image(item.imgName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:30)
                        Text(item.Txt)
                            .font(.caption)
                        Spacer()
                        Text(item.data)
                            .foregroundColor(.white)
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
        }
    }
}
extension Color {
    static var resultTxtColor:Color {
        return Color(
            hue: Double.random(in: 0...1),
            saturation: Double.random(in: 0.5...1),
            brightness: Double.random(in: 0.5...1)
        )
    }
}
#Preview {
    GameResultView()
}
