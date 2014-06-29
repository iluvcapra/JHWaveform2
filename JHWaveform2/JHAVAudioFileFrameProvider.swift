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
    
    init(url: NSURL, channelIndex: Int, error: NSErrorPointer) {
        var myerror: NSError? = nil
        self.audioFile = AVAudioFile(forReading: url, commonFormat: AVAudioCommonFormat.PCMFormatFloat32, interleaved: false, error: &myerror)
        if (myerror) {
            error.memory = myerror
        }
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
        
        // FIXME finish implementation -- fill the retval
        
        return retVal
    }
    
}
