//
//  GameView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/13.
//

import SwiftUI
import UIKit

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
    @ObservedObject private var countdata = countData.shared
    @ObservedObject var playerRank = PlayerRank.data
    @State private var backgroundColor: Color = .backgroundColor
    @State private var backgroundOpacity:Double = 0.0
    @State private var bonusTimeTxt:Bool = false
    @State private var charChange:Bool = true
    @State private var closePopover:Bool = false
    @State private var checkPopover:Bool = false
    @State private var scoreMessage:Double = 0.0
    @State private var goldBurgerMSG:Bool = false
    @State private var goodMessage:Bool = false
    @State private var resultTextToggle:Bool = true
    //スコアup中のTimer
    @State private var grafUpTime: Double = 0
    @State private var grafTimeOpacity: Double = 0.0
    @AppStorage("lastScoreKey") private var lastScore: Int = 0
    @State private var score:Int = 0
    @State private var gameTimeCount: Double = 10
    @State private var getScore:Int = 1
    @State private var getTime:Double = 3
    
    @State private var grafUpProbability:Int = 8
    @State private var goldBurgerProbability:Int = 12
    @State private var clockProbability:Int = 20
    @State private var vagetableProbability:Int = 12
    @State private var hammerProbability:Int = 0
    @State private var misteryProbability:Int = 10
    //プレイ画面
    @State private var gameScreenWidth:CGFloat = UIScreen.main.bounds.width-50
    @State private var gameScreenHeight:CGFloat = UIScreen.main.bounds.height-200
    //Playerデータ
    @State private var playerPositionX:CGSize = .zero
    @GestureState private var dragPositionX:CGSize = .zero
    @State private var playerPositionY:CGFloat = UIScreen.main.bounds.height-200
    @State private var playerFrame:CGFloat = 80
    @State private var playerOpacity:Double = 1.0
    @State private var playerDisable:Bool = true
    //当たる判定のSize
    @State private var mainObWidth:CGFloat = 30
    @State private var mainObHeight:CGFloat = 5
    //生成する構造体
    @State private var GetBurger:[Burger] = []
    @State private var GetPoo:[Poo] = []
    //タイマー
    @State private var countTimer: Timer?
    @State private var fallingTimer: Timer?
    @State private var createBurgerTimer: Timer?
    @State private var pooTimer: Timer?
    @State private var pointUpTimer: Timer?
    @State private var randomColorTimer: Timer?
    //落ちるスピード&生成スピード
    @State private var fallingSpeed: Double = 0.004
    @State private var baseSpeed: Double = 0.004
    @State private var penaltySpeed: Double = 0.001
    @State private var createSpeed: Double = 0.5
    @State private var isPenaltyActive = false
    //ペナルティ階段
    @State private var hStackCount:CGFloat = 0
    @State private var showPoo: Bool = false
    @State private var deadLine:CGFloat = UIScreen.main.bounds.height - 210
    //ゲーム開始&終了ボタン
    @State private var gameStartButton:Bool = true
    @State private var gameOver:Bool = false
    @State private var scoreColor:Bool = false
    @State private var resultChanged:Bool = true
    @State private var showMusicSheet:Bool = false
    @State private var resetDisable:Bool = false
    @State private var showRuleView:Bool = false
    @State private var showRankView:Bool = false
    //v2.1.0
    @State private var enterName:Bool = false
    
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    backgroundColor = Color(
                        hue: Double.random(in: 0...1),
                        saturation: Double.random(in: 0.5...1),
                        brightness: Double.random(in: 0.5...1)
                    )
                }
            
            VStack {
                HStack {
                    HStack {
                        if !resetDisable {
                            Button(action: {
                                showRuleView = false
                                showRankView.toggle()
                            }, label: {
                                VStack(alignment:.leading, spacing: 0) {
                                    Image(systemName: "medal.star.fill")
                                }
                                .opacity(0.7)
                                .font(.system(size:30))
                            })
                        }
                        Spacer()
                    }
                    .frame(width:50)
                    Spacer()
                    HStack {
                        Image("clock")
                            .resizable()
                            .frame(width: 30,height: 30)
                        Text("GAME TIME: ")
                            .font(.body)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        Text("\(Int(gameTimeCount))")
                            .font(.system(size: 30))
                            .foregroundColor(getTimeColor(value:gameTimeCount))
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showMusicSheet = true
                        }, label: {
                            Image(systemName: "music.note.list")
                                .opacity(0.7)
                                .font(.system(size:30))
                        })
                    }
                    .frame(width:50)
                }
                .foregroundColor(.white)
                .fontWeight(.bold)
                .frame(width: gameScreenWidth,height: 30)
                
                ZStack {
                    VStack { //GameScreen
                        
                        if !enterName {
                            withAnimation(.linear(duration:1)) {
                                HStack(spacing:0) {
                                    Text("LAST GAME SCORE: \(lastScore)")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .opacity(0.5)
                                }
                            }
                        } else {
                            withAnimation(.linear(duration:1)) {
                                HStack(spacing:0) {
                                    Text("YOUR GAME SCORE: \(score)")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                        .opacity(0.5)
                                }
                            }
                        }
                        
                        HStack {
                            Image("Burger")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:30)
                            Text("X \(Int(score))")
                        }
                        .foregroundColor(scoreColor ? Color.white : Color.white)
                        .fontWeight(.bold)
                        .opacity(0.9)
                        //Item Message
                        VStack {
                            if bonusTimeTxt {
                                PointPlusTimeView(pointUpTimeCount: $grafUpTime)
                                    .opacity(grafTimeOpacity)
                            }
                        }.frame(height:30)
                        Spacer()
                        //土台の高さ
                        VStack(spacing:0) {
                            ForEach(0..<Int(hStackCount),id: \.self) { _ in
                                HStack(spacing:0) {
                                    ForEach(0..<4,id: \.self) { _ in
                                        Image("mapGround")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: gameScreenWidth / 4, height: 30)
                                            .clipped()
                                    }
                                }
                            }
                        }
                        .frame(width:gameScreenWidth)
                    }
                    .frame(width: gameScreenWidth,height:gameScreenHeight)
                    
                    //PlayerImage
                    if charChange {
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
                            .disabled(playerDisable)
                    } else {
                        Image("ManLight")
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
                            .disabled(playerDisable)
                    }
                    
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
                            .frame(width:item.imageName == "GoldBurger" ? 40 : Burger.burgerWidth)
                            .position(item.burgerPosition)
                            .shadow(color: item.imageName == "GoldBurger" ? .yellow : .clear, radius: 5)
                    }
                    ForEach(GetPoo) { poo in
                        Image("poo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:Burger.burgerWidth)
                            .position(poo.pooPosition)
                    }
                    
                    //スコア増加Message
                    if goldBurgerMSG {
                        Text("+10")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .opacity(scoreMessage)
                            .offset(x:10)
                    } else {
                        if goodMessage {
                            Text("+20")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .opacity(scoreMessage)
                                .offset(x:10)
                        } else {
                            Text("注意！")
                                .font(.title)
                                .foregroundColor(.red)
                                .opacity(scoreMessage)
                                .offset(x:10)
                        }
                    }
                    
                }
                .frame(width: gameScreenWidth,height: gameScreenHeight)
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
                        .disabled(playerDisable)
                }
                .frame(width: gameScreenWidth,height: 50)
                
            }
            //ゲームが終了の時表示するtxt
            ZStack {
                Rectangle()
                    .fill(.black)
                    .frame(width:gameScreenWidth,height:gameScreenHeight)
                    .offset(y:-10)
                Text("Game Over!!")
                    .foregroundColor(.white)
            }
            .opacity(backgroundOpacity)
            
            if gameStartButton {
                VStack {
                    
                    Button(action: {
                        gameStartButton = false
                        startGame()
                        resetDisable = true
                    }) {
                        Text("ゲーム開始")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(14) // default is 16points
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                            .minimumScaleFactor(0.5) // 设置文本缩放最小值
                    }
                    .frame(width: 120, height: 50) //按钮大小
                    .padding(.bottom, 3)
                    
                    Button(action: {
                        showRuleView = true
                    }) {
                        Text("アイテム一覧")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(13)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                            .minimumScaleFactor(0.5) // 设置文本缩放最小值
                    }
                    .frame(width: 120, height: 50) //按钮大小
                    
                }
                
                
                if showRuleView {
                    RuleView()
                        .onTapGesture {
                            showRuleView = false
                        }
                }
                if showRankView {
                    TitleRankView()
                        .onTapGesture {
                            showRankView = false
                        }
                }
            }
            
            if gameOver {
                ZStack {
                    if resultChanged {
                        GameResultView()
                    } else {
                        RankingView()
                    }
                }
                .onTapGesture {
                    resultChanged.toggle()
                }
                Text("Homeに戻る")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        initialGame()
                        resetDisable = false
                    }
                    .offset(y:210)
            }
            //ユーザー名を入力するView
            if enterName {
                EnterUserNameView(showResult: $enterName)
            }
            
            if showPoo {
                PooView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showMusicSheet) {
            MusicView()
                .presentationDetents([.medium])
        }
        .onAppear() {
            playerPositionX.width = UIScreen.main.bounds.width/2 - 30
        }
        .onDisappear() {
            stopAllTimer()
        }
    }
    private func createBurger() {
        let randomNumber = Int.random(in: 1...100)
        let randomImage: String
        if randomNumber <= grafUpProbability  {
            randomImage = "grafup"
        } else if randomNumber <= grafUpProbability + goldBurgerProbability {
            randomImage = "GoldBurger"
        } else if randomNumber <= grafUpProbability + goldBurgerProbability + clockProbability {
            randomImage = "clock"
        } else if randomNumber <= grafUpProbability + goldBurgerProbability + clockProbability + vagetableProbability {
            randomImage = "vagetable"
        } else if randomNumber <= grafUpProbability + goldBurgerProbability + clockProbability + vagetableProbability + hammerProbability {
            randomImage = "hammer"
        } else if randomNumber <= grafUpProbability + goldBurgerProbability + clockProbability + vagetableProbability + hammerProbability + misteryProbability {
            randomImage = "hatena"
        } else {
            randomImage = "Burger"
        }
        let randomX = CGFloat.random(in: Burger.burgerWidth/2 + 30...(gameScreenWidth-40))
        let newItem = Burger(imageName: randomImage, burgerPosition:CGPoint(x:randomX,y:10))
        GetBurger.append(newItem)
    }
    private func createPoo() {
        let newPoo = Poo(pooPosition:CGPoint(x:playerPositionX.width + dragPositionX.width + 10,y:playerPositionY))
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
                    if hStackCount <= 6 {
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
            checkCharChange()
        }
    }
    private func checkCharChange() {
        if score >= 100 {
            charChange = false
        } else {
            charChange = true
        }
    }
    private func startGame() {
        playerDisable = false
        countTimer?.invalidate()
        countGameTime()
        createBurgerTimer = Timer.scheduledTimer(withTimeInterval: createSpeed, repeats: true) { _ in
            createBurger()
            falling()
        }
    }
    private func stopGame() {
        if gameTimeCount <= 0 {
            playerRank.score = score
            stopAllTimer()
            playerDisable = true
            GetBurger.removeAll()
            GetPoo.removeAll()
            deadLine = UIScreen.main.bounds.height-200
            fallingSpeed = 0.004
            createSpeed = 0.5
            grafUpTime = 0
            bonusTimeTxt = false
            scoreColor = false
            withAnimation(.linear(duration:1)) {
                backgroundOpacity += 1.0
                playerOpacity = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                enterName = true
                lastScoreCalculate()
                enterNameAfter()
            }
        }
    }
    private func enterNameAfter() {
        //名前を入力した後に行う処理
        charChange = true
        hStackCount = 0
        backgroundOpacity = 0
        gameOver = true
    }
    
    private func initialGame() {
        gameOver = false
        gameStartButton = true
        checkPopover = false
        resultChanged = true
        score = 0
        countdata.getBurgerCount = 0
        countdata.getGoldBurgerCount = 0
        countdata.totalGameTime = 10
        countdata.bonusTime = 0
        gameTimeCount = 10
        playerPositionY = UIScreen.main.bounds.height-200
        playerPositionX.width = UIScreen.main.bounds.width/2 - 30
        playerOpacity = 1.0
    }
    private func stopAllTimer() {
        countTimer?.invalidate()
        createBurgerTimer?.invalidate()
        fallingTimer?.invalidate()
        pooTimer?.invalidate()
        pointUpTimer?.invalidate()
    }
    private func startAllTimer() {
        countGameTime()
        startGame()
        falling()
        pooAction()
        countStart()
    }
    private func collision() {
        let newMainPosition = CGPoint(x:playerPositionX.width + dragPositionX.width,
                                      y:playerPositionY - 50)
        let newMainFrame = CGRect(x:newMainPosition.x - mainObWidth/1.5,
                                  y:newMainPosition.y,
                                  width:mainObWidth,
                                  height:mainObHeight)
        //配列中のBurgerを判定した後削除
        for index in GetBurger.indices.reversed() {
            let newBurgerRect = CGRect(x: GetBurger[index].burgerPosition.x - Burger.burgerWidth / 2,
                                       y: GetBurger[index].burgerPosition.y - Burger.burgerHeight / 2,
                                       width: Burger.burgerWidth,
                                       height: Burger.burgerHeight)
            if newMainFrame.intersects(newBurgerRect) {
                let itemName = GetBurger[index]
                if itemName.imageName == "Burger" {
                    generateImpactFeedback(for: .light)
                    GetBurger.remove(at: index)
                    withAnimation(.linear(duration:0.2)) {
                        score += getScore
                    }
                    countdata.getBurgerCount += 1
                    createPoo()
                    pooAction()
                } else if itemName.imageName == "clock" {
                    generateImpactFeedback(for: .heavy)
                    GetBurger.remove(at: index)
                    getTimeAnimation()
                    countdata.totalGameTime += 3
                } else if itemName.imageName == "hatena" {
                    let randomNum = Int.random(in: 1...100)
                    GetBurger.remove(at: index)
                    goldBurgerMSG = false
                    if randomNum < 67 {
                        goodMessage = true
                        generateImpactFeedback(for: .heavy)
                        score += 20
                        showScoreMessage()
                    } else {
                        goodMessage = false
                        generateImpactFeedback(for: .heavy)
                        hitHatena()
                        showScoreMessage()
                    }
                }else if itemName.imageName == "GoldBurger" {
                    generateImpactFeedback(for: .heavy)
                    GetBurger.remove(at: index)
                    goldBurgerMSG = true
                    showScoreMessage()
                    withAnimation(.linear(duration:0.2)) {
                        score += 10
                    }
                    countdata.getGoldBurgerCount += 1
                } else if itemName.imageName == "grafup" {
                    generateImpactFeedback(for: .heavy)
                    GetBurger.remove(at: index)
                    grafTimeOpacity = 1.0
                    scoreColor = true
                    bonusTimeTxt = true
                    grafUpTime += 5
                    countStart()
                    countdata.bonusTime += 3
                } else if itemName.imageName == "vagetable" {
                    generateErrorFeedback()
                    GetBurger.remove(at: index)
                    showPoo = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showPoo = false
                    }
                } else if itemName.imageName == "hammer" {
                    generateImpactFeedback(for: .heavy)
                    GetBurger.remove(at: index)
                    if hStackCount > 0 {
                        hStackCount -= 1
                        playerPositionY += Burger.burgerHeight
                        deadLine += Burger.burgerHeight
                    } else {
                        score += 2
                    }
                }
            }
        }
    }
    func generateImpactFeedback(for style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
    func generateErrorFeedback() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        // 类型有 .success .error 和 .warning
        //分别对应通知,错误和警告
        feedbackGenerator.notificationOccurred(.error)
    }
    private func countGameTime() {
        countTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            gameTimeCount -= 1
            speedChange()
            if hStackCount <= 0 {
                hammerProbability = 0
            } else {
                hammerProbability = 10
            }
        }
    }
    private func speedChange() {
        guard !isPenaltyActive else { return } // 如果Penalty激活，则不增加速度
        if fallingSpeed > 0.002 {
            fallingSpeed -= 0.002 / 90 // 缓慢增加速度
            createSpeed -= 0.003 / 60 // 让创建速度同步变化
        }
    }
    private func hitHatena() {
        guard !isPenaltyActive else { return } // 如果已经在Penalty中，避免再次触发
        
        // 设置Penalty状态
        isPenaltyActive = true
        baseSpeed = fallingSpeed // 保存当前速度以便恢复
        fallingSpeed = penaltySpeed // 立即加速到Penalty速度
        
        // 1秒后恢复到正常速度
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                fallingSpeed = baseSpeed // 恢复到原本的速度
            }
            isPenaltyActive = false // 重置Penalty状态
        }
    }
    private func lastScoreCalculate() {
        lastScore = score
    }
    private func countStart() {
        pointUpTimer?.invalidate()
        pointUpTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if grafUpTime > 0 {
                grafUpTime -= 1
                getScore = 2
            } else if grafUpTime <= 0{
                pointUpTimer?.invalidate()
                bonusTimeTxt = false
                getScore = 1
                scoreColor = false
                grafTimeOpacity = 0.0
            }
        }
        if countdata.totalGameTime <= 30 {
            clockProbability = 20
        } else if countdata.totalGameTime <= 60 {
            clockProbability = 10
        } else {
            clockProbability = 5
        }
    }
    private func getTimeAnimation() {
        withAnimation(.linear(duration: 0.5)) {
            gameTimeCount += getTime
        }
    }
    private func getTimeColor(value: Double) -> Color {
        if value > 3 {
            return Color.white
        } else {
            return Color.red
        }
    }
    private func showScoreMessage() {
        scoreMessage += 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            scoreMessage -= 1.0
        }
    }
}

#Preview {
    GameView()
}
