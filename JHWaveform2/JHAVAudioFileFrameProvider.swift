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
    var channelIndex: Int
    
    var frameCount: Int {
    get {
        return Int(audioFile.length)
    }
    }
    
    init(file: AVAudioFile, channelIndex: Int) {
        self.audioFile = file
        self.channelIndex = min(channelIndex, Int(audioFile.fileFormat.channelCount) - 1)
    }
    
    func readFrames(range: NSRange) -> Float[] {
        audioFile.framePosition = AVAudioFramePosition(range.location)
        var format = audioFile.processingFormat
        var buf = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: AVAudioFrameCount(range.length) )
        var error: NSError? = nil
        audioFile.readIntoBuffer(buf, error: &error)
        
        var channelData = buf.floatChannelData[channelIndex]
        
        var r = UnsafeArray<Float>(start: channelData, length: range.length)
        
        return Array<Float>(r)
    }
    
}
