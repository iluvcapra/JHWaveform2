//
//  JHAVAssetFrameProvider.swift
//  JHWaveform2
//
//  Created by Jamie Hardt on 6/28/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import Cocoa
import AVFoundation

class JHAVAudioFileFrameProvider: JHAudioFrameProvider {

    var audioFile: AVAudioFile
    var frameCount: Int {
    get {
        return audioFile.length
    }
    }
    
    init(_ asset: AVAudioFile) {
        self.audioFile = asset
    }
    
    func readFrames(range: NSRange) -> Float[] {
        audioFile.framePosition = range.location
        
    }
    
}
