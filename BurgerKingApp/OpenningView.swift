//
//  OpenningView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/17.
//

import SwiftUI

struct OpenningView: View {
    @State private var createBurgers: [Bool] = Array(repeating: false, count: 15)
    @State private var positions: [CGPoint] = Array(repeating: .zero, count: 15)
    @State private var sizes: [CGFloat] = Array(repeating: .zero, count: 15)
    @State private var MoveToGameView = false
    var body: some View {
        ZStack {
            ForEach(0..<createBurgers.count,id: \.self) { index in
                if createBurgers[index] {
                    Image("Burger")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:sizes[index])
                        .position(positions[index])
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear() {
            showBurgers()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                MoveToGameView = true
            }
        }
        .fullScreenCover(isPresented:$MoveToGameView) {
            GameView()
        }
    }
    private func showBurgers() {
        for index in 0..<createBurgers.count {
            let delay = Double(index) * 0.2
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                createBurgers[index] = true
                positions[index] = randomPosition()
                sizes[index] = randomSize()
            }
        }
    }
    private func randomSize() -> CGFloat{
        let randomSize = CGFloat.random(in: 200...500)
        return randomSize
    }
    private func randomPosition() -> CGPoint{
        let randomX = CGFloat.random(in:0...UIScreen.main.bounds.width)
        let randomY = CGFloat.random(in:0...UIScreen.main.bounds.height)
        
        return CGPoint(x: randomX, y: randomY)
    }
}

#Preview {
    OpenningView()
}
