//
//  OpenningView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/29.
//

import SwiftUI

struct OpenningView: View {
    @State private var fontOpacity:Double = 0
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("King of Burger")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    OpenningView()
}
