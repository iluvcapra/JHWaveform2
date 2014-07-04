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
    
    var channelCount: Int {
    get {
        return Int(audioFile.processingFormat.channelCount)
    }
    }
    
    var frameCount: Int {
    get {
        return Int(audioFile.length)
    }
    }
    
    init(fileURL: NSURL) {
        var error : NSError? = nil
        self.audioFile = AVAudioFile(forReading: fileURL, commonFormat: AVAudioCommonFormat.PCMFormatFloat32,
            interleaved: false, error: &error)
        
        
    }
    
    func readFrames(range: NSRange) -> Float[] {
        return readFrames(range, channel: 0)
    }
    
    func readFrames(range: NSRange, channel: Int) -> Float[] {
        let channelIndex = min(channel,self.channelCount)
        let getRange = NSIntersectionRange(range, NSMakeRange(0, self.frameCount))

        objc_sync_enter(self)
        audioFile.framePosition = AVAudioFramePosition(range.location)
        var format = audioFile.processingFormat
        var buf = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: AVAudioFrameCount(range.length) )
        var error: NSError? = nil
        audioFile.readIntoBuffer(buf, error: &error)
        
        var channelData = buf.floatChannelData[channelIndex]
        
        var r = UnsafeArray<Float>(start: channelData, length: range.length)
        objc_sync_exit(self)

        var retVal = Array(r)
        return retVal
    }
    
}
