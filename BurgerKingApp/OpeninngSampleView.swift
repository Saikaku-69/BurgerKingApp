//
//  OpenningView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/17.
//

import SwiftUI

struct OpeningSampleView: View {
    //Openning effects Test
    @State private var createBurgers: [Bool] = Array(repeating: false, count: 5)
    @State private var positions: [CGPoint] = Array(repeating: .zero, count: 5)
    @State private var sizes: [CGFloat] = Array(repeating: .zero, count: 5)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showBurgers()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    MoveToGameView = false
                }
            }
        }
        .fullScreenCover(isPresented:$MoveToGameView) {
            GameView()
        }
    }
    
    private func showBurgers() {
        for index in 0..<createBurgers.count {
            let delay = Double(index) * 0.3
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
        let minX = UIScreen.main.bounds.width/4
        let minY = UIScreen.main.bounds.height/6
        let randomX = CGFloat.random(in:minX...UIScreen.main.bounds.width - minX)
        let randomY = CGFloat.random(in:minY...UIScreen.main.bounds.height - minY)
        
        return CGPoint(x: randomX, y: randomY)
    }
    
}

#Preview {
    OpeningSampleView()
}
