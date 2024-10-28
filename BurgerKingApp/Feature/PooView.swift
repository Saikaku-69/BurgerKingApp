//
//  PooView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/16.
//

import SwiftUI

struct PooView: View {
    var body: some View {
        
        ZStack {
            ForEach(0..<1,id: \.self) { _ in
                Image("ghost")
//                Image(pooImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
//                    .frame(width:pooSize())
                    .frame(width:400)
//                    .position(pooPosition())
                    .position(x:UIScreen.main.bounds.width/2,
                              y:UIScreen.main.bounds.height/2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func pooSize() -> CGFloat {
        let pooSizeWidth = CGFloat(Int.random(in: 300...400))
        return pooSizeWidth
    }
    
    private func pooImage() -> String {
        let randomNumber = Int.random(in:1...100)
        if randomNumber > 30 {
            return "poo"
        } else if randomNumber > 70 {
            return "ghost"
        } else {
            return "joker_face"
        }
    }
    
    private func pooPosition() -> CGPoint {
        let maxX = UIScreen.main.bounds.width
        let maxY = UIScreen.main.bounds.height
        let randomX = CGFloat.random(in: 0...maxX)
        let randomY = CGFloat.random(in: 0...maxY)
        
        return CGPoint(x: randomX, y: randomY)
    }
}

#Preview {
    PooView()
}
