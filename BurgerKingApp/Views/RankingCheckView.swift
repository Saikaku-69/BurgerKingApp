//
//  TitleRankView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/30.
//

import SwiftUI

struct RankingCheckView: View {
    @EnvironmentObject var playerRank: PlayerRank
    @AppStorage("nameArray") var nameArrayData: String = ""
    @AppStorage("rankArray") var rankArrayData: String = ""
    @State private var nameArray: [String] = []
    @State private var rankArray: [Int] = []
    let trophies = ["trophyGold","trophySilver","trophyBronze","medal"]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            Text("ランキング")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(8)
                .padding(.bottom, 10)
            ForEach(0..<min(rankArray.count, 4), id: \.self) { index in
                HStack(spacing: 12) {
                    Image(trophies[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                    Text("\(nameArray[index])")
                        .foregroundColor(.white)
                        .font(.subheadline)
                    Spacer()
                    Text("\(rankArray[index]) 個")
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .foregroundColor(.white)
        .background(Color.black)
        .cornerRadius(15)
        .frame(width: UIScreen.main.bounds.width * 0.85)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white, lineWidth: 1)
        )
        .onAppear {
            loadStoredData()
        }
    }
    private func loadStoredData() {
        nameArray = nameArrayData.split(separator: ",").map { String($0) }
        rankArray = rankArrayData.split(separator: ",").compactMap { Int($0) }
    }
}

struct RankingCheckView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyNameArray = ["Alice", "Bob", "Charlie", "David"]
        let dummyRankArray = [100, 85, 75, 60]
        RankingCheckView()
            .environmentObject(PlayerRank.data) // ダミーの環境オブジェクト
            .onAppear {
                RankingCheckView_Previews.loadDummyData(nameArray: dummyNameArray, rankArray: dummyRankArray)
            }
    }
    
    // プレビュー用のダミーデータロードメソッド
    static func loadDummyData(nameArray: [String], rankArray: [Int]) {
        let encodedNames = nameArray.joined(separator: ",")
        let encodedRanks = rankArray.map { String($0) }.joined(separator: ",")
        
        UserDefaults.standard.set(encodedNames, forKey: "nameArray")
        UserDefaults.standard.set(encodedRanks, forKey: "rankArray")
    }
}
