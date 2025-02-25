//
//  OpenningView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/29.
//

import SwiftUI

struct OpeningView: View {
    @State private var titleOpacity:Double = 0
    @State private var moveToGameView:Bool = false
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("King of Burger")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .font(.system(size:40))
                .opacity(titleOpacity)
        }
        .fullScreenCover(isPresented: $moveToGameView) {
            GameView()
        }
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.linear(duration:2)) {
                    titleOpacity += 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation(.linear(duration:2)) {
                            titleOpacity -= 1.0
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    moveToGameView = true
                }
            }
        }
    }
}

#Preview {
    OpeningView()
}
