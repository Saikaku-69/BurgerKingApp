//
//  TotalRankView.swift
//  BurgerKingApp
//
//  Created by cmStudent on 2024/10/20.
//

import SwiftUI
import AVFoundation

class MusicPlayer {
    static let shared = MusicPlayer()  // 使用单例模式以便全局使用
    var backgroundMusicPlayer: AVAudioPlayer?

    // 播放背景音乐
    func playBackgroundMusic() {
        if let musicPath = Bundle.main.path(forResource: "background", ofType: "mp3") {  // 替换为你的音频文件名
            let url = URL(fileURLWithPath: musicPath)
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundMusicPlayer?.numberOfLoops = -1  // 设置循环播放
                backgroundMusicPlayer?.play()
            } catch {
                print("无法播放背景音乐: \(error.localizedDescription)")
            }
        }
    }
    
    // 停止背景音乐
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
}
struct MusicView: View {
    var body: some View {
        Text("Choose Music")
    }
}

#Preview {
    MusicView()
}
