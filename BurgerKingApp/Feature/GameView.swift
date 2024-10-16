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
    @State private var score:Int = 0
    @State private var gameTimeCount: Double = 60
    @State private var getScore:Int = 1
    @State private var grafUpProbability:Int = 5
    @State private var goldBurgerProbability:Int = 10
    @State private var compassProbability:Int = 15
    @State private var vagetableProbability:Int = 20
    
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
    @State private var pooTimer: Timer?
    @State private var fallingSpeed:Double = 0.005
    @State private var createSpeed:Double = 0.3
    //ペナルティ階段
    @State private var hStackCount:CGFloat = 0
    @State private var showPoo: Bool = false
    @State private var deadLine:CGFloat = UIScreen.main.bounds.height - 210
    //
    @State private var gameStartButton:Bool = true
    @State private var gameOver:Bool = false
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                //ゲーム時間を表す
                HStack {
                    Image("compass")
                        .resizable()
                        .frame(width: 30,height: 30)
                    Text("GAME TIME:\(Int(gameTimeCount))")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .fontWeight(.bold)
                .frame(width: gameScreenWidth,height: 30)
                
                ZStack {
                    //Play画面
                    VStack {
                        Text("BEST SCORE:\(Int(bestScore))")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .opacity(0.5)
                        HStack {
                            Image("Burger")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:30)
                            Text("X \(Int(score))")
                        }
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .opacity(0.9)
                        Spacer()
                        //Play画面の高さ
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
                        .opacity(playerOpacity)
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
                    
                    //当たる判定用mainObject
                    Rectangle()
                        .fill(.red)
                        .frame(width:mainObWidth,height:mainObHeight)
                        .position(x:playerPositionX.width + dragPositionX.width,
                                  y:playerPositionY - 60)
                        .opacity(0.0)
                    
                    ForEach(GetBurger) { item in
                        Image(item.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:Burger.burgerWidth)
                        .position(item.burgerPosition)
                    }
                    
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
                
                ZStack {
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(15)
                        .opacity(0.2)
                        .frame(width: gameScreenWidth,height: 25)
                    Image("Burger")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:50,height: 50)
                        .position(x:playerPositionX.width + dragPositionX.width + 5,y: 25)
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
                }
                .frame(width: gameScreenWidth,height: 50)
            }
            if gameStartButton {
                Button(action: {
                    gameStartButton = false
                    startGame()
                    bestScoreCalculate()
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
            if showPoo {
                PooView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear() {
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
        //regular = 80 ,score = 5,time = 5,penalty = 5, double
        if randomNumber <= grafUpProbability  {
            randomImage = "grafup"
        } else if randomNumber <= goldBurgerProbability {
            randomImage = "BurgerBreak"
        } else if randomNumber <= compassProbability {
            randomImage = "compass"
        } else if randomNumber <= vagetableProbability {
            randomImage = "vagetable"
        } else {
            randomImage = "Burger"
        }
        
        let randomX = CGFloat.random(in: Burger.burgerWidth/2 + 30...(gameScreenWidth-40))
        let newItem = Burger(imageName: randomImage, burgerPosition:CGPoint(x:randomX,y:10))
        GetBurger.append(newItem)
    }
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
                    if hStackCount <= 7 {
                        hStackCount += 1
                        playerPositionY -= Burger.burgerHeight
                        deadLine -= Burger.burgerHeight
                    }
                } else {
                    GetBurger.remove(at: index)
                }
            }
            collision()
            stopGame()
        }
    }
    private func startGame() {
        playerAction = false
        saveTimer?.invalidate()
        countSaveTime()
        createBurgerTimer = Timer.scheduledTimer(withTimeInterval: createSpeed, repeats: true) { _ in
            createBurger()
            falling()
        }
    }
    private func stopGame() {
        if gameTimeCount <= 0 {
            saveTimer?.invalidate()
            createBurgerTimer?.invalidate()
            fallingTimer?.invalidate()
            gameTimeCount = 0.005
            playerAction = true
            playerOpacity = 0.0
            bestScoreCalculate()
            GetBurger.removeAll()
            GetPoo.removeAll()
            hStackCount = 0
            deadLine = UIScreen.main.bounds.height-200
            gameOver = true
        }
    }
    private func initialGame() {
        gameOver = false
        gameStartButton = true
        score = 0
        gameTimeCount = 60
        playerFrame = 80
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
                    score += getScore
                    GetBurger.remove(at: index)
                    createPoo()
                    pooAction()
                } else if itemName.imageName == "compass" {
                    gameTimeCount += 5
                    GetBurger.remove(at: index)
                } else if itemName.imageName == "BurgerBreak" {
                    grafUpProbability = 0
                    goldBurgerProbability = 0
                    compassProbability = 0
                    vagetableProbability = 0
                    GetBurger.remove(at: index)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        grafUpProbability = 5
                        goldBurgerProbability = 10
                        compassProbability = 15
                        vagetableProbability = 20
                    }
                } else if itemName.imageName == "grafup" {
                    getScore = 5
                    compassProbability = 0
                    GetBurger.remove(at: index)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        getScore = 1
                        compassProbability = 5
                    }
                } else if itemName.imageName == "vagetable" {
                    generateImpactFeedback(for: .heavy)
                    showPoo = true
                    GetBurger.remove(at: index)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showPoo = false
                    }
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
    private func countSaveTime() {
        saveTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            gameTimeCount -= 1
            speedChange()
        }
    }
    private func speedChange() {
        if fallingSpeed >= 0.001 {
            fallingSpeed -= 0.004 / 60
        } else  {
            fallingSpeed = 0.001
        }
    }
    private func bestScoreCalculate() {
        if score > bestScore {
            bestScore = score
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
