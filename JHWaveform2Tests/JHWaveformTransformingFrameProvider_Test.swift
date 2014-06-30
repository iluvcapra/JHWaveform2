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
    
    /*
    
    Range conversion - when ranges are scaled in time, they must round their offset DOWN and
    their length UP.
    
    */
    
    func testSimpleRangeConverstion() {
        let testRange = NSMakeRange(0, 100)
        var affineTransform = NSAffineTransform()
        affineTransform.scaleXBy(0.3, yBy: 1)
        let outRange = testRange.transformRangeAlongX(affineTransform)
        XCTAssertEqualObjects(outRange.location, 0, "")
        XCTAssertEqualObjects(outRange.length, 30, "")
    }
    
    func testRangeConversion() {
        let testRange = NSMakeRange(5,10)
        var affineTransform = NSAffineTransform()
        affineTransform.scaleXBy(0.9, yBy: 1.0)
        let outRange = testRange.transformRangeAlongX(affineTransform)
        XCTAssertEqualObjects(outRange.location, 4, "")
        XCTAssertEqualObjects(outRange.length, 9, "")
    }
    
    func testRangeConversionExp() {
        let testRange = NSMakeRange(5,10)
        var affineTransform = NSAffineTransform()
        affineTransform.scaleXBy(1.1, yBy: 1.0)
        let outRange = testRange.transformRangeAlongX(affineTransform)
        XCTAssertEqualObjects(outRange.location, 5, "")
        XCTAssertEqualObjects(outRange.length, 11, "")
    }

    func testCoalesce() {
        let testSrc = JHFloatArrayFrameProvider([1.0,-1.0,2.0,-1.0,3.0,-1.0])
        var xform = NSAffineTransform()
        xform.scaleXBy(0.5, yBy: 1.0)
        let testXformer = JHWaveformTransformingFrameProvider(testSrc, transform: xform)
        
        XCTAssertEqual(testXformer.frameCount, 3, "Frame count is incorrect")
        let coalescedData = testXformer.readFrames(NSMakeRange(0, 3))
        XCTAssertEqualObjects(coalescedData, [1.0,2.0,3.0], "Coalesced data is incorrect")
    }
    
    func testYScale() {
        let testSrc = JHFloatArrayFrameProvider([3.0, -2.0, 3.0,5.0])
        var xform = NSAffineTransform()
        xform.scaleXBy(1.0, yBy: 0.01)
        let testXformer = JHWaveformTransformingFrameProvider(testSrc, transform: xform)
        let coalescedData = testXformer.readFrames(NSMakeRange(0, 4))
        XCTAssertEqualObjects(coalescedData, [300.0, -200.0, 300.0,500.0], "Coalecsed Y scaled data is incorrect")

    }

    func testBiggerCoalesce() {
        
        let testSrc = JHFloatArrayFrameProvider([ 0.1,  0.2, 0.3 , 0.4,
            0.5 , 0.1, -0.5, 0.2,
            -1.4,  3.2, 0.4 , 4.2,
            1.5, 9.3, -4.6, 1.0,
            -1.2, -1.0, 1.0])
        
        var xform = NSAffineTransform()
        xform.scaleBy(0.5)
        let testXformer = JHWaveformTransformingFrameProvider(testSrc, transform: xform)
        XCTAssertEqual(testXformer.frameCount, 10, "")
        
        let coalescedData = testXformer.readFrames(NSMakeRange(0,10))
        XCTAssertEqual(coalescedData.count, 10)
    }
    
}
