//
//  JHTransformingFrameProvider_Files_Test.swift
//  JHWaveform2
//
//  Created by Jamie Hardt on 6/29/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import XCTest
import AVFoundation


class JHTransformingFrameProvider_Files_Test: XCTestCase {

    let monoDTMF_url  = urlForWAV(JHTransformingFrameProvider_Files_Test.self, "Mono_DTMF_Test")
    let monoWav_url = urlForWAV(JHTransformingFrameProvider_Files_Test.self, "Mono_Wav_Test")
    let stereoPluck_url  = urlForWAV(JHTransformingFrameProvider_Files_Test.self , "Stereo_Pluck_Test")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
//    
//    func testStereo() {
//
//        var chans = [0,1]
//        let nativeProviders: JHAVAudioFileFrameProvider[] = chans.map {
//            return JHAVAudioFileFrameProvider(file: audioFile, channelIndex: $0)
//        }
//        
//        let targetBufferSize = 500
//        
//        let transformingProviders: JHWaveformTransformingFrameProvider[] = nativeProviders.map {
//            var xform = NSAffineTransform()
//            xform.scaleXBy(CGFloat(targetBufferSize) / CGFloat($0.frameCount), yBy: 1.0)
//            return JHWaveformTransformingFrameProvider($0, transform:xform )
//        }
//        
//        
//        let buffers: Float[][] = transformingProviders.map {
//            return $0.readFrames( NSMakeRange(0, targetBufferSize) )
//        }
//        
//        println(buffers)
//        
//    }

    func testDTMF() {
    
        let nativeFrameProvider = JHAVAudioFileFrameProvider(fileURL:monoDTMF_url)
        
        let targetBufferSize = 20
        var xform = NSAffineTransform()
        
        xform.scaleXBy( CGFloat(targetBufferSize) / CGFloat(nativeFrameProvider.frameCount), yBy: 100.0)
        
        let transformingProvider = JHWaveformTransformingFrameProvider(nativeFrameProvider,transform: xform)
        
        var buffer = transformingProvider.readFrames(NSMakeRange(0, targetBufferSize))
        
        let targetBufferShould = [
            80.0,   80.0,   80.0,   80.0,   80.0,
            0.0,    0.0,
            80.0,   80.0,   80.0,   80.0,   80.0,   80.0,
            0.0,    0.0,
            80.0,   80.0,   80.0,   80.0,   80.0]
        
        for i in 0..buffer.count {
           XCTAssertEqualWithAccuracy(Float(targetBufferShould[i]), Float(buffer[i]), 10.0, "Target")
        }
        
    }

    
}
