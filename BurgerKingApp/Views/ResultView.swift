//
//  GameResaultView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/16.
//

import SwiftUI

class CountData:ObservableObject {
    static let shared = CountData()
    @Published var getBurgerCount:Int = 0
    @Published var totalGameTime:Double = 10
    @Published var getGoldBurgerCount:Int = 0
    @Published var bonusTime:Double = 0
}

struct CountStr:Identifiable {
    let id = UUID()
    var imgName: String
    var Txt: String
    var data: String
}

struct ResultView: View {
    @ObservedObject var countdata = CountData.shared
    
    var body: some View {
        
        let countstr = [
            CountStr(imgName:"Burger", Txt:"消化したバーガー:",data:"\(countdata.getBurgerCount)個"),
            CountStr(imgName: "GoldBurger",Txt:"ゴールドバーガー:",data:"\(countdata.getGoldBurgerCount)個"),
            CountStr(imgName: "graphup", Txt:"スコア増加持続時間:",data:"\(Int(countdata.bonusTime))秒"),
            CountStr(imgName: "clock", Txt:"トータルゲーム時間:",data:"\(Int(countdata.totalGameTime))秒")
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
                HStack {
                    Spacer()
                    Text("タップして")
                    Text("ランキング")
                        .underline()
                        .foregroundColor(.blue)
                    Text("を見る")
                    Spacer()
                }
                .foregroundColor(.white)
                .font(.caption)
                ForEach(countstr) { item in
                    HStack {
                        Image(item.imgName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:30)
                        Text(item.Txt)
                            .font(.caption)
                            .foregroundColor(.white)
                        Spacer()
                        Text(item.data)
                            .foregroundColor(.white)
                    }
                    .padding(5)
                    .padding(.horizontal,5)
                    .background(Color.black)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white, lineWidth: 1)
                    )
                }
            }
            .frame(width: UIScreen.main.bounds.width/1.4)
            .padding(10)
            .background(Color.black)
            .cornerRadius(20)
        }
    }
}

#Preview {
    ResultView()
}
