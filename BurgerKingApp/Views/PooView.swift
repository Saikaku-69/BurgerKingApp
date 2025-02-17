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
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:400)
                    .position(x:UIScreen.main.bounds.width/2,
                              y:UIScreen.main.bounds.height/2)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PooView()
}
