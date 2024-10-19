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
            Text("(")
            Text("\(Int(pointUpTimeCount))")
                .font(.system(size:20))
                .foregroundColor(.red)
            Text(")")
        }
        .foregroundColor(.white)
    }
}

#Preview {
    PointPlusTimeView(pointUpTimeCount:.constant(5))
}
