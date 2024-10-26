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

extension Color {
    static var deepGray:Color {
        return Color(red: 0.1, green: 0.1, blue: 0.1)
    }
}

extension Color {
    static var coolColor:Color {
        return Color(
            hue: Double.random(in: 0.5...0.75),
            saturation: Double.random(in: 0.5...1),
            brightness: Double.random(in: 0.5...1)
        )
    }
}

extension Color {
    static var warmColor:Color {
        return Color(
            hue: Double.random(in: 0...0.15),
            saturation: Double.random(in: 0.5...1),
            brightness: Double.random(in: 0.5...1)
        )
    }
}
