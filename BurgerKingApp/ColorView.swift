//
//  ColorView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/20.
//

import SwiftUI

extension Color {
    static var backgroundColor:Color {
        if #available(iOS 17.0, *) {
            return Color (
                Color(hue: 0.7, saturation: 0.5, brightness: 0.7)
            )
        } else {
            // Fallback on earlier versions
            let hue: CGFloat = 0.7
            let saturation: CGFloat = 0.5
            let brightness: CGFloat = 0.7
            
            let rgb = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
            
            return Color(rgb)
        }
    }
}
extension Color {
    static var gameBackgroundColor:Color {
        return Color.black
    }
}
