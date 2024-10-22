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
    @AppStorage("nameArray") var nameArrayData: String = "" // 用于存储名字的字符串
    @AppStorage("rankArray") var rankArrayData: String = "" // 用于存储分数的字符串
    @State private var nameArray: [String] = []
    @State private var rankArray: [Int] = []
    let trophies = ["trophyGold","trophySilver","trophyBronze","medal"]
    
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
                ForEach(0..<min(rankArray.count, 4),id: \.self) { index in
                    HStack {
                        Image(trophies[index])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                        Text("\(nameArray[index])")
                            .font(.caption)
                            .foregroundColor(.white)
                        Spacer()
                        HStack {
                            Image("Burger")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15)
                            Spacer()
                            Text("\(rankArray[index])個")
                                .font(.body)
                        }
                        .frame(width:90)
                    }
                    .padding(5)
                    .background(Color.coolColor)
                    .cornerRadius(15)
                }
            }
            .frame(width: UIScreen.main.bounds.width/1.4)
            .padding(10)
            .background(Color.black)
            .cornerRadius(20)
            .onAppear() {
                loadStoredData() // 加载存储的数据
                updateScores(playerName: playerRank.name, newScore: playerRank.score) // 更新分数
            }
        }
    }
    private func updateScores(playerName: String, newScore: Int) {
        // 检查是否已存在该玩家的记录
        if let index = nameArray.firstIndex(of: playerName) {
            // 如果存在并且新分数更高，则更新分数
            if newScore > rankArray[index] {
                rankArray[index] = newScore
            }
        } else {
            // 如果不存在，则添加新的记录
            nameArray.append(playerName)
            rankArray.append(newScore)
        }
        // 对数组进行排序，创建一个分数和名字的元组数组
        let rankedScores = zip(rankArray, nameArray).sorted { $0.0 > $1.0 }
        rankArray = rankedScores.map { $0.0 }
        nameArray = rankedScores.map { $0.1 }
        // 确保数组最多只有四个元素
        if rankArray.count > 4 {
            nameArray.removeLast() // 删除对应的名字
            rankArray.removeLast() // 删除最小的分数
        }
        // 更新存储的数据
        saveStoredData()
    }
    private func saveStoredData() {
        nameArrayData = nameArray.joined(separator: ",") // 将名字数组转换为字符串
        rankArrayData = rankArray.map { String($0) }.joined(separator: ",") // 将分数数组转换为字符串
    }
    private func loadStoredData() {
        // 从存储的字符串中加载数据
        nameArray = nameArrayData.split(separator: ",").map { String($0) } // 转换为 String 数组
        rankArray = rankArrayData.split(separator: ",").compactMap { Int($0) } // 转换为 Int 数组
    }
}
extension Color {
    static var coolColor:Color {
        return Color(
            hue: Double.random(in: 0.5...0.75),
            saturation: Double.random(in: 0.5...1),
            brightness: Double.random(in: 0.5...1)
        )
    }
}
#Preview {
    RankingView()
}
