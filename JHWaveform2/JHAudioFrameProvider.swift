//
//  JHWaveformProvider.swift
//  JHWaveform2
//
//  Created by Jamie Hardt on 6/28/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import Foundation

extension NSRange {
    func transformRangeAlongX(xform: NSAffineTransform) -> NSRange {
        let origin = NSPoint(x: 0, y: CGFloat(self.location) )
        let terminus = NSPoint(x: 0, y: CGFloat(self.location + self.length) )
        
        let transformedOrigin = xform.transformPoint(origin)
        let transformedTerminus = xform.transformPoint(terminus)
        let length = ceil(transformedTerminus.x - transformedOrigin.x)
        
        return NSRange(location:Int(transformedOrigin.x), length:Int(length))
    }
    
    func toRange() -> Range<Int> {
        return Range(start:self.location, end:self.location+self.length)
    }
}


protocol JHAudioFrameProvider {
    
    var frameCount: Int  { get }
    
    func readFrames(range: NSRange) -> Float[]
}

class JHFloatArrayFrameProvider : JHAudioFrameProvider {
    
    var dataBuf : Array<Float>
    
    var frameCount: Int {
        return dataBuf.count
    }
    
    init(_ floatData: Float[] ) {
        dataBuf = floatData.copy()
    }
    
    func readFrames(range: NSRange) -> Float[] {
        let s: Range<Int> = range.toRange()
        return Array(dataBuf[s])
    }
    
}

func resampleArray(samples: Float[], length l: Int) -> Float[] {
    var retArray = Float[]()
    let boundsRange = Range(start:0, end:samples.count - 1)
    let stride = samples.count / l
    let ranges = StridedRangeGenerator(boundsRange,stride: stride)
    
    for i in ranges {
        let end = min(i+stride, boundsRange.endIndex + 1)
        let theRange = Range(start: i, end: end)
        let subArray = samples[theRange]
        retArray.append(maxElement(subArray))
    }
    
    return retArray
}

class JHWaveformTransformingFrameProvider: JHAudioFrameProvider {
    
    var sourceProvider:             JHAudioFrameProvider
    var sourceToTargetTransform:    NSAffineTransform
    var targetToSourceTransform:    NSAffineTransform {
    get {
        let retVal = sourceToTargetTransform
        retVal.invert()
        return retVal
    }
    }
    
    var frameCount: Int {
    get {
        let inRange = NSRange(location:0 , length: Int(sourceProvider.frameCount) )
        let outRange = inRange.transformRangeAlongX(sourceToTargetTransform)
        
        return outRange.length
    }
    }
    
    init(_ sp: JHAudioFrameProvider, transform: NSAffineTransform?) {
        sourceProvider = sp
        if (transform) {
            sourceToTargetTransform = transform!
        } else {
            sourceToTargetTransform = NSAffineTransform()
        }
        
    }

    func readFrames(range: NSRange) -> Float[] {
        let transformedRange = range.transformRangeAlongX(targetToSourceTransform)
        let sourceSamples = sourceProvider.readFrames(transformedRange)
        
        return resampleArray(sourceSamples,length:range.length)
    }
}