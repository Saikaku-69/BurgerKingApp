//
//  ClockMessageView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/26.
//

import SwiftUI

struct ClockMessageView: View {
    var body: some View {
        HStack {
            Image("smiling_demon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:30)
            Text("加速")
                .foregroundColor(.red)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    ClockMessageView()
}
