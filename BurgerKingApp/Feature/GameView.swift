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
    
    static var burgerWidth: CGFloat = 30
    static var burgerHeight: CGFloat = 30
}
struct Poo:Identifiable {
    var id = UUID()
    var pooPosition: CGPoint
}
struct GameView: View {
    @AppStorage("bestScoreKey") private var bestScore: Int = 0
    @AppStorage("bestSaveTimeKey") private var bestSaveTime: Double = 0
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
    @State private var playerOpacity:Double = 1.0
    @State private var playerAction:Bool = true
    //Create burger
    @State private var GetBurger:[Burger] = []
    @State private var GetPoo:[Poo] = []
    //collision mainObject Size
    @State private var mainObWidth:CGFloat = 30
    @State private var mainObHeight:CGFloat = 5
    
    //
    @State private var saveTimer: Timer?
    @State private var fallingTimer: Timer?
    @State private var createBurgerTimer: Timer?
    @State private var knifeTimer: Timer?
    @State private var pooTimer: Timer?
    @State private var fallingSpeed:Double = 0.005
//    @State private var knifeTimer: Timer?
    //ペナルティ階段
    @State private var hStackCount:CGFloat = 0
    @State private var knifeRotation: Double = 0
    @State private var knifeMove: Bool = false
    @State private var deadLine:CGFloat = UIScreen.main.bounds.height - 210
    //
    @State private var gameStartButton:Bool = true
    @State private var gameOver:Bool = false
    //Ambulance
    @State private var ambulancePositionX: CGSize = .zero
    @State private var ambulanceMove:Bool = false
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
                    Image("Burger")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:Burger.burgerWidth)
                    Text("X\(score)")
                }
                .fontWeight(.bold)
                .frame(width: gameScreenWidth,height: 30)
                //ゲームスクーリン
                ZStack {
                    //ペナルティ(階段+1)
                    VStack(alignment: .center, spacing: 0) {
//                        Image("knife")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width:100)
//                            .rotationEffect(Angle(degrees: knifeRotation),anchor: .center)
//                            .offset(x:knifePosition)
                        HStack(spacing:0) {
                            ForEach(0..<7,id: \.self) { _ in
                                Image("JuziDeadLine")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:50)
                                    .rotationEffect(Angle(degrees: knifeRotation),anchor: .center)
                            }
                        }
                        Text("SAVE TIME:\(Int(gameSaveTime))")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        HStack {
                            Text("BEST SCORE:\(Int(bestScore))")
                            Spacer()
                            Text("BEST TIME:\(Int(bestSaveTime))")
                        }
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .opacity(0.5)
                        Spacer()
//                        ForEach(0..<hStackCount,id: \.self) { _ in
//                            HStack(spacing: 0) {
//                                ForEach(0..<Int(gameScreenWidth/28),id: \.self) { _ in
//                                    Image("Burger")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .frame(width:Burger.burgerWidth,height:Burger.burgerHeight)
//                                }
//                            }
//                            .frame(width: gameScreenWidth,height:Burger.burgerHeight)
//                        }
                        Rectangle()
                            .fill(Color.backgroundColor)
                            .frame(width: gameScreenWidth,
                                   height:Burger.burgerHeight * hStackCount)
                    }
                    .frame(width: gameScreenWidth,height:gameScreenHeight)
                    
                    //PlayerImage
                    Image("ManDefault")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height:playerFrame)
                        .position(x:playerPositionX.width + dragPositionX.width + 10,
                                  y:playerPositionY - 40)
                        .rotationEffect(Angle(degrees: playerRotation),anchor: .center)
                        .opacity(playerOpacity)
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(15)
                        .opacity(0.2)
                        .frame(width: 60,height: 50)
                        .position(x:playerPositionX.width + dragPositionX.width + 5,
                                  y:UIScreen.main.bounds.height-240)
                        .offset(y:80)
                        .gesture(
                            DragGesture()
                                .updating($dragPositionX) { move, value, _ in
                                    value = move.translation
                                }
                                .onEnded { value in
                                    playerPositionX.width += value.translation.width
                                }
                        )
                        .disabled(playerAction)
                    //main
                    Rectangle()
                        .fill(.red)
                        .frame(width:mainObWidth,height:mainObHeight)
                        .position(x:playerPositionX.width + dragPositionX.width,
                                  y:playerPositionY - 60)
                        .opacity(0.0)
                    //BurgerImage
                    ForEach(GetBurger) { item in
                        Image(item.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:Burger.burgerWidth)
                        .position(item.burgerPosition)
                    }
                    //poo
                    ForEach(GetPoo) { poo in
                        Image("poo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:Burger.burgerWidth)
                        .position(poo.pooPosition)
                    }
                }
                .frame(width: gameScreenWidth,
                       height: gameScreenHeight)
                .background(Color.gameBackgroundColor)
                
                HStack {
                    
                }
                .frame(width: 60,height: 50)
            }
            if gameStartButton {
                Button(action: {
                    gameStartButton = false
                    startGame()
                    bestScoreCalculate()
                    knifeMove = true
                    juziMove()
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
                    Image("french")
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
            if ambulanceMove {
                Image("Ambulance")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:150)
                    .offset(x:ambulancePositionX.width-250,y:-250)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear() {
            //ポジションを真ん中にリセット
            playerPositionX.width = UIScreen.main.bounds.width/2 - 30
            bestScoreCalculate()
        }
        .onDisappear() {
            saveTimer?.invalidate()
            createBurgerTimer?.invalidate()
            fallingTimer?.invalidate()
        }
    }
    //Burger構造体
    private func createBurger() {
        let randomNumber = Int.random(in: 1...100)
        let randomImage: String
        
        if randomNumber <= 90 {
            randomImage = "Burger"
        } else {
            randomImage = "vagetable"
        }
//        let images = ["Burger","poo"]
//        let randomImage = images.randomElement() ?? "Burger"
        let randomX = CGFloat.random(in: Burger.burgerWidth/2 + 30...(gameScreenWidth-40))
        let newItem = Burger(imageName: randomImage, burgerPosition:CGPoint(x:randomX,y:10))
        GetBurger.append(newItem)
    }
    //poo
    private func createPoo() {
        let newPoo = Poo(pooPosition:CGPoint(x:playerPositionX.width + dragPositionX.width + 10,
                                             y:playerPositionY))
        GetPoo.append(newPoo)
    }
    private func pooAction() {
        pooTimer?.invalidate()
        pooTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            for index in GetPoo.indices.reversed() {
                if GetPoo[index].pooPosition.y <= UIScreen.main.bounds.height {
                    GetPoo[index].pooPosition.y += 2
                } else {
                    GetPoo.remove(at: index)
                }
            }
        }
    }
    //Falling
    private func falling() {
        fallingTimer?.invalidate()
        fallingTimer = Timer.scheduledTimer(withTimeInterval: fallingSpeed, repeats: true) { _ in
            for index in GetBurger.indices.reversed() {
                let itemName = GetBurger[index]
                if GetBurger[index].burgerPosition.y <= deadLine {
                    withAnimation(.linear) {
                        GetBurger[index].burgerPosition.y += 1
                    }
                } else if itemName.imageName == "Burger" {
                    GetBurger.remove(at: index)
                    hStackCount += 1
                    playerPositionY -= Burger.burgerHeight
                    deadLine -= Burger.burgerHeight
                } else {
                    GetBurger.remove(at: index)
                }
            }
            collision()
            //gameOver check
            stopGame()
        }
    }
    private func startGame() {
        playerAction = false
        saveTimer?.invalidate()
        countSaveTime()
        createBurgerTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            createBurger()
            falling()
        }
    }
    private func stopGame() {
        if playerPositionY <= 130 {
            saveTimer?.invalidate()
            createBurgerTimer?.invalidate()
            fallingTimer?.invalidate()
            playerAction = true
            bestScoreCalculate()
            GetBurger.removeAll()
            GetPoo.removeAll()
            hStackCount = 0
            ambulanceMove = true
            ambulanceAction()
            gameSaveTime = 0.005
            deadLine = UIScreen.main.bounds.height-200
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                knifeTimer?.invalidate()
                gameOver = true
            }
        }
    }
    private func initialGame() {
        gameOver = false
        gameStartButton = true
        score = 0
        gameSaveTime = 0
        ambulancePositionX.width = .zero - 250
        playerFrame = 80
        playerRotation = 0
        playerOpacity = 1.0
        playerPositionY = UIScreen.main.bounds.height-200
        playerPositionX.width = UIScreen.main.bounds.width/2 - 30
        deadLine = UIScreen.main.bounds.height-200
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
                let itemName = GetBurger[index]
                if itemName.imageName == "Burger" {
                    generateImpactFeedback(for: .medium)
                    score += 1
                    GetBurger.remove(at: index)
                    createPoo()
                    pooAction()
                } else if itemName.imageName == "vagetable" {
                    generateImpactFeedback(for: .heavy)
                    fallingSpeed = fallingSpeed/2
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        fallingSpeed = fallingSpeed * 2
                    }
                    GetBurger.remove(at: index)
                }
            }
        }
    }
    //振動処理
    func generateImpactFeedback(for style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    //振動処理
    func generateErrorFeedback() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        // 类型有 .success .error 和 .warning
        //分别对应通知,错误和警告
        feedbackGenerator.notificationOccurred(.error)
    }
    private func juziMove() {
        if knifeMove {
            knifeTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                withAnimation(.linear(duration:0.5)) {
                    knifeRotation += 720
                }
            }
        } else {
            withAnimation {
                knifeRotation = 0
            }
        }
    }
    private func ambulanceAction() {
        withAnimation(.linear(duration: 1)) {
            ambulancePositionX.width = playerPositionX.width + dragPositionX.width + 110
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            playerOpacity = 0.0
            withAnimation(.linear(duration: 1)) {
                ambulancePositionX.width += 360
            }
        }
    }
    private func countSaveTime() {
        saveTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            gameSaveTime += 1
            if gameSaveTime >= 100 {
                fallingSpeed = 0.001
            } else if gameSaveTime >= 80 {
                fallingSpeed = 0.002
            } else if gameSaveTime >= 60 {
                fallingSpeed = 0.003
            } else if gameSaveTime >= 40 {
                fallingSpeed = 0.004
            } else {
                fallingSpeed += 0
            }
        }
    }
    private func bestScoreCalculate() {
        if score > bestScore {
            bestScore = score
        }
        if gameSaveTime > bestSaveTime {
            bestSaveTime = gameSaveTime
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
