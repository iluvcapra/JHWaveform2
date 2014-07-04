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
    var audioFileQueue = dispatch_queue_create("JHAVAudioFileFrameProvider", DISPATCH_QUEUE_SERIAL)
    
    var multichannelReadCache: Array<(channel:Int,range:NSRange,data:Float[])> = []
    
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
    
    func rawReadFrames(range: NSRange, channel: Int) -> Float[] {
        let channelIndex = min(channel,self.channelCount)
        let getRange = NSIntersectionRange(range, NSMakeRange(0, self.frameCount))
        
        var retVal = Array<Float>()
        
        dispatch_sync(audioFileQueue) {
            self.audioFile.framePosition = AVAudioFramePosition(range.location)
            var format = self.audioFile.processingFormat
            var buf = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: AVAudioFrameCount(range.length) )
            var error: NSError? = nil
            self.audioFile.readIntoBuffer(buf, error: &error)
            
            var channelData = buf.floatChannelData[channelIndex]
            
            var r = UnsafeArray<Float>(start: channelData, length: range.length)
            retVal = Array(r)
        }
        
        return retVal
    }
    
    func readFrames(range: NSRange, channel: Int) -> Float[] {
        
        return rawReadFrames(range, channel: channel)
    }
    
}
