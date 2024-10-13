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
    @State private var playerFrame:CGFloat = 80
    @State private var playerRotation:Double = 0
    
    //Create burger
    @State private var GetBurger:[Burger] = []
    
    //collision mainObject Size
    @State private var mainObWidth:CGFloat = 30
    @State private var mainObHeight:CGFloat = 5
    
    //
    @State private var saveTimer: Timer?
    @State private var fallingTimer: Timer?
    @State private var createBurgerTimer: Timer?
    @State private var gameTime:Double = 0.003
    @State private var knifeTimer: Timer?
    //ペナルティ階段
    @State private var hStackCount:Int = 0
    @State private var knifeRotation: Double = 0
    @State private var knifeMove: Bool = false
    @State private var knifePosition:CGFloat = -100
    @State private var deadLine:CGFloat = UIScreen.main.bounds.height - 210
    //
    @State private var gameStartButton:Bool = true
    @State private var gameOver:Bool = false
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
//                    Button(knifeMove ? "Stop" : "Start") {
//                        knifeMove.toggle()
//                        if knifeMove {
//                            knifeAnimation()
//                        } else {
//                            stopKinife()
//                        }
//                    }
                }
                .frame(width: gameScreenWidth,height: 30)
                //ゲームスクーリン
                ZStack {
                    //ペナルティ(階段+1)
                    VStack(alignment: .center, spacing: 0) {
                        Image("knife")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:100)
                            .rotationEffect(Angle(degrees: knifeRotation),anchor: .center)
                            .offset(x:knifePosition)
                        Spacer()
                        ForEach(0..<hStackCount,id: \.self) { _ in
                            HStack(spacing: 0) {
                                ForEach(0..<Int(gameScreenWidth/20),id: \.self) { _ in
                                    Image("Burger")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width:Burger.burgerWidth,height:Burger.burgerHeight)
                                }
                            }
                            .frame(width: gameScreenWidth,height:Burger.burgerHeight)
//                            .border(.blue)
                        }
                    }
                    .frame(width: gameScreenWidth,height:gameScreenHeight)
//                    .border(.green)
                    
                    //PlayerImage
                    Image("ManDefault")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:playerFrame)
                        .position(x:playerPositionX.width + dragPositionX.width + 10,
                                  y:playerPositionY - 40)
                        .rotationEffect(Angle(degrees: playerRotation),anchor: .center)
                        .gesture(
                            DragGesture()
                                .updating($dragPositionX) { move, value, _ in
                                    value = move.translation
                                }
                                .onEnded { value in
                                    playerPositionX.width += value.translation.width
                                }
                        )
                    //main
                    Rectangle()
                        .fill(.red)
                        .frame(width:mainObWidth,height:mainObHeight)
                        .position(x:playerPositionX.width + dragPositionX.width,
                                  y:playerPositionY - 60)
                        .opacity(0.0)
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
            if gameStartButton {
                Button(action: {
                    gameStartButton = false
                    startGame()
                    knifeMove = true
                    knifeAnimation()
                }) {
                    Text("ゲーム開始")
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.backgroundColor)
                        .cornerRadius(15)
                }
            }
            if gameOver {
                VStack {
                    Spacer()
                    Button(action: {
                        //リセット
                        initialGame()
                    }) {
                        Text("Homeに戻る")
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.gameBackgroundColor)
                            .cornerRadius(15)
                    }
                }
                .frame(width: gameScreenWidth/2,height: gameScreenHeight/3)
                .padding()
                .background(Color.backgroundColor)
                .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear() {
            //ポジションを真ん中にリセット
            playerPositionX.width = UIScreen.main.bounds.width/2 - 30
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
        fallingTimer = Timer.scheduledTimer(withTimeInterval: gameTime, repeats: true) { _ in
            for index in GetBurger.indices.reversed() {
                if GetBurger[index].burgerPosition.y <= deadLine {
                    withAnimation(.linear) {
                        GetBurger[index].burgerPosition.y += 1
                    }
                } else {
                    GetBurger.remove(at: index)
                    hStackCount += 1
                    playerPositionY -= Burger.burgerHeight
                    deadLine -= Burger.burgerHeight
                }
            }
            collision()
            //gameOver check
            stopGame()
        }
    }
    private func startGame() {
        createBurgerTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
            createBurger()
            falling()
        }
    }
    private func stopGame() {
        if playerPositionY <= 210 {
            createBurgerTimer?.invalidate()
            fallingTimer?.invalidate()
            GetBurger.removeAll()
            hStackCount = 0
            playerDelect()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                gameOver = true
                stopKinife()
            }
        }
    }
    private func initialGame() {
        gameOver = false
        gameStartButton = true
        playerFrame = 80
        playerRotation = 0
        playerPositionX.width = UIScreen.main.bounds.width/2 - 30
        playerPositionY = UIScreen.main.bounds.height-200
    }
    //判定
    private func collision() {
        //main
        let newMainPosition = CGPoint(x:playerPositionX.width + dragPositionX.width,
                                        y:playerPositionY - 50)
        let newMainFrame = CGRect(x:newMainPosition.x - mainObWidth/1.5,
                                  y:newMainPosition.y,
                                  width:mainObWidth,
                                  height:mainObHeight)
        //配列中のBurgerを判定しら削除
        for index in GetBurger.indices.reversed() {
            let newBurgerRect = CGRect(x: GetBurger[index].burgerPosition.x - Burger.burgerWidth / 2,
                                       y: GetBurger[index].burgerPosition.y - Burger.burgerHeight / 2,
                                       width: Burger.burgerWidth,
                                       height: Burger.burgerHeight)
            if newMainFrame.intersects(newBurgerRect) {
                GetBurger.remove(at: index)
            }
        }
    }
    private func knifeAnimation() {
        if knifeMove {
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: false)) {
                knifeRotation += 360
            }
            withAnimation(.linear(duration: 0.5).repeatForever(autoreverses: true)) {
                knifePosition += 200
            }
        }
    }
    private func stopKinife() {
//        knifeTimer?.invalidate()
        knifeMove = false
        knifeRotation = 0
    }
    private func playerDelect() {
        withAnimation(.linear(duration: 1)) {
            playerFrame -= 80
            playerRotation += 360
            playerPositionY -= 100
        }
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
