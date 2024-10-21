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
    var musicSwitchOne:Bool = false
    var musicSwitchTwo:Bool = false
    
    func playMusicOne() {
        if let musicPath = Bundle.main.path(forResource: "whatever you like", ofType: "mp3") {  // 替换为你的音频文件名
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
    func stopMusicOne() {
        backgroundMusicPlayer?.stop()
    }
    //bgm2
    func playMusicTwo() {
        if let musicPath = Bundle.main.path(forResource: "Funky Cat", ofType: "mp3") {  // 替换为你的音频文件名
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
    func stopMusicTwo() {
        backgroundMusicPlayer?.stop()
    }
}
struct MusicView: View {
    var body: some View {
        HStack {
            //bgm1
            Button(action: {
                MusicPlayer.shared.musicSwitchTwo = false
                if !MusicPlayer.shared.musicSwitchTwo {
                    MusicPlayer.shared.musicSwitchOne.toggle()
                    if MusicPlayer.shared.musicSwitchOne {
                        MusicPlayer.shared.playMusicOne()
                    } else {
                        MusicPlayer.shared.stopMusicOne()
                    }
                }
            }) {
                Image("whateverlikeyouIMG")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:100)
            }
            //bgm2
            Button(action: {
                MusicPlayer.shared.musicSwitchOne = false
                if !MusicPlayer.shared.musicSwitchOne {
                    MusicPlayer.shared.musicSwitchTwo.toggle()
                    if MusicPlayer.shared.musicSwitchTwo {
                        MusicPlayer.shared.playMusicTwo()
                    } else {
                        MusicPlayer.shared.stopMusicTwo()
                    }
                }
            }) {
                Image("funkycatIMG")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:100)
                
            }
        }
    }
}

#Preview {
    MusicView()
}
