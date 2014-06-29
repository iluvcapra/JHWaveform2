//
//  JHWaveformTransformingFrameProvider_Test.swift
//  JHWaveform2
//
//  Created by Jamie Hardt on 6/28/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import XCTest

class JHWaveformTransformingFrameProvider_Test: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCoalesce() {
        let testSrc = JHFloatArrayFrameProvider(floatData:[1.0,-1.0,2.0,-1.0,3.0,-1.0])
        var xform = NSAffineTransform()
        xform.scaleBy(0.5)
        let testXformer = JHWaveformTransformingFrameProvider(sp: testSrc, transform: xform)
        
        XCTAssertEqual(testXformer.frameCount(), 3, "Frame count is incorrect")
        let coalescedData = testXformer.readFrames(NSMakeRange(0, 3))
        XCTAssertEqualObjects(coalescedData, [1.0,2.0,3.0], "Coalesced data is incorrect")
    }

}
