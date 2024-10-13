//
//  GameView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/13.
//

import SwiftUI

//Burger構造体
struct Burger:Identifiable {
    var id = UUID()
    var imageName: String
    var burgerPosition: CGPoint
    
    static var burgerWidth: CGFloat = 20
    static var burgerHeight: CGFloat = 20
}

struct GameView: View {
    
    @State private var score:Int = 0
    @State private var gameSaveTime: Double = 0
    
    @State private var gameScreenWidth:CGFloat = UIScreen.main.bounds.width-50
    @State private var gameScreenHeight:CGFloat = UIScreen.main.bounds.height-200
    
    //Player Position
    @State private var playerPositionX:CGSize = .zero
    @GestureState private var dragPositionX:CGSize = .zero
    @State private var playerPositionY:CGFloat = UIScreen.main.bounds.height-200
    
    //Create burger
    @State private var GetBurger:[Burger] = []
    
    //collision mainObject Size
    @State private var mainObWidth:CGFloat = 30
    @State private var mainObHeight:CGFloat = 5
    
    //
    @State private var saveTimer: Timer?
    @State private var fallingTimer: Timer?
    @State private var createBurgerTimer: Timer?
    
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Image("Burger")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:20)
                    Text("Save Time: \(gameSaveTime,specifier: "%.1f")")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: gameScreenWidth,height: 30)
                .border(.red)
                //ゲームスクーリン
                ZStack {
                    Image("ManDefault")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:80)
                        .position(x:playerPositionX.width + dragPositionX.width + 10,
                                  y:playerPositionY - 40)
                        .gesture(
                            DragGesture()
                                .updating($dragPositionX) { move, value, _ in
                                    value = move.translation
                                }
                                .onEnded { value in
                                    playerPositionX.width += value.translation.width
                                }
                        )
                    Rectangle()
                        .fill(.red)
                        .frame(width:mainObWidth,height:mainObHeight)
                        .position(x:playerPositionX.width + dragPositionX.width,
                                  y:playerPositionY - 60)
                        .opacity(1.0)
                    //BurgerImage
                    ForEach(GetBurger) { item in
                    Image("Burger")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:Burger.burgerWidth)
                        .position(item.burgerPosition)
                    }
                }
                .frame(width: gameScreenWidth,
                       height: gameScreenHeight)
                .background(Color.gameBackgroundColor)
                
                HStack {
                    
                }
                .frame(width: gameScreenWidth,height: 30)
                .border(.red)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear() {
            //ポジションを真ん中にリセット
            playerPositionX.width = UIScreen.main.bounds.width/2 - 30
//            startGame()
        }
    }
    //Burger構造体
    private func createBurger() {
        let image = "Burger"
        let randomX = CGFloat.random(in: Burger.burgerWidth/2...(gameScreenWidth-10))
        
        let newItem = Burger(imageName: image, burgerPosition:CGPoint(x:randomX,y:10))
        GetBurger.append(newItem)
    }
    //Falling
    private func falling() {
        fallingTimer?.invalidate()
        fallingTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            for index in GetBurger.indices.reversed() {
                if GetBurger[index].burgerPosition.y <= UIScreen.main.bounds.height - 210 {
                    withAnimation(.linear) {
                        GetBurger[index].burgerPosition.y += 1
                    }
                } else {
                    GetBurger.remove(at: index)
                }
            }
        }
    }
    private func startGame() {
        createBurgerTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            createBurger()
            falling()
        }
    }
    //判定
    private func collision() {
        
    }
}
extension Color {
    static var backgroundColor:Color {
        return Color (
            Color(hue: 0.7, saturation: 0.5, brightness: 0.7)
        )
    }
}
extension Color {
    static var gameBackgroundColor:Color {
        return Color (
            Color(hue: 0.7, saturation: 0.6, brightness: 0.3)
        )
    }
}

#Preview {
    GameView()
}
