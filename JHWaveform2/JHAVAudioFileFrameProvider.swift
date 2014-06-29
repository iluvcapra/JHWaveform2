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
        var retVal = Float[](count: range.length, repeatedValue: 0.0)
        
        audioFile.framePosition = AVAudioFramePosition(range.location)
        var format = audioFile.processingFormat
        var buf = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: AVAudioFrameCount(range.length) )
        var error: NSError? = nil
        audioFile.readIntoBuffer(buf, error: &error)
        
        var channelData = buf.floatChannelData[channelIndex]
        
        for (var i = 0; i < self.frameCount; i++){
            retVal[i] = channelData[i]
        }
        // there must be some faster way of doing this...
        return retVal
    }
    
}
