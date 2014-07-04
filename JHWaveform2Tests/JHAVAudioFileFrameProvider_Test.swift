//
//  JHAVAudioFileFrameProvider_Test.swift
//  JHWaveform2
//
//  Created by Jamie Hardt on 6/29/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import XCTest
import AVFoundation

func urlForWAV(klass: AnyClass, filename : String) -> NSURL {
    return NSBundle(forClass: klass).URLForResource(
        filename, withExtension: "wav")
}

class JHAVAudioFileFrameProvider_Test: XCTestCase {
    
    @final class func urlForWAV(filename : String) -> NSURL {
        return NSBundle(forClass: self).URLForResource(
            filename, withExtension: "wav")
    }
    
    let monoDTMF_url  = urlForWAV(JHAVAudioFileFrameProvider_Test.self, "Mono_DTMF_Test")
    let monoWav_url = urlForWAV(JHAVAudioFileFrameProvider_Test.self, "Mono_Wav_Test")
    let stereoPluck_url  = urlForWAV(JHAVAudioFileFrameProvider_Test.self , "Stereo_Pluck_Test")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMonoWav() {
        var error : NSError? = nil
        let avaudio = AVAudioFile(forReading: monoDTMF_url,
            commonFormat: AVAudioCommonFormat.PCMFormatFloat32,
            interleaved: false, error: &error)
        
        XCTAssertNil(error,"failed to create AVAudioFile")
        XCTAssertEqual(avaudio.processingFormat.channelCount, 1,"")
        
        let frameProvider = JHAVAudioFileFrameProvider(fileURL: monoDTMF_url)
        
        XCTAssertEqual(Int(frameProvider.frameCount), Int(avaudio.length), "Frame provider/AvAudioFile mismatch")
        
        let bufSize = 0x1000
        let buf = Float[](count: bufSize, repeatedValue: 0.0)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
