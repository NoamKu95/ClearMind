//
//  AudioPlayer.swift
//  Restart
//
//  Created by Noam Kurtzer on 21/02/2023.
//

import Foundation
import AVFoundation

var audioPlayer : AVAudioPlayer?

func playSound(withFile sound: String, ofType type: String ) {
    
    guard let path = Bundle.main.path(forResource: sound, ofType: type) else {return}
        
    do {
        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        audioPlayer?.play()
    } catch {
        print("Cant play audio file")
    }
}
