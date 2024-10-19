//
//  PointPlusTimeView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/18.
//

import SwiftUI

struct PointPlusTimeView: View {
    @Binding var pointUpTimeCount: Double
    @State private var pointUpTimer: Timer?
    var body: some View {
        HStack {
            Text("スコア増加中")
                .opacity(0.5)
            Text("残り時間:")
            Text("\(Int(pointUpTimeCount))")
                .font(.system(size:20))
                .foregroundColor(.red)
            Text("s")
        }
        .font(.system(size:15))
        .foregroundColor(.white)
    }
}

#Preview {
    PointPlusTimeView(pointUpTimeCount:.constant(5))
}
