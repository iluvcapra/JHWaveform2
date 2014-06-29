//
//  JHWaveformProvider.swift
//  JHWaveform2
//
//  Created by Jamie Hardt on 6/28/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import Foundation

extension NSRange {
    func transformRangeAlongY(xform: NSAffineTransform) -> NSRange {
        let origin = NSPoint(x: 0, y: CGFloat(self.location) )
        let terminus = NSPoint(x: 0, y: CGFloat(self.location + self.length) )
        
        let transformedOrigin = xform.transformPoint(origin)
        let transformedTerminus = xform.transformPoint(terminus)
        
        return NSRange(location:Int(transformedOrigin.y), length:Int(transformedTerminus.y - transformedOrigin.y))
    }
}


protocol JHAudioFrameProvider {
    func readFrames(range: NSRange) -> Float[]
    func frameCount() -> Int
}

class JHFloatArrayFrameProvider : JHAudioFrameProvider {
    
    var data: Float[]
    
    init( floatData: Float[]) {
        data = floatData
    }
    
    func readFrames(range: NSRange) -> Float[] {
        let subrange = Range(start:range.location, end:range.location+range.length)
        return data[subrange]
    }
    
    func frameCount() -> Int {
        return data.count
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
    
    init(sp: JHAudioFrameProvider, transform: NSAffineTransform?) {
        sourceProvider = sp
        if (transform) {
            sourceToTargetTransform = transform!
        } else {
            sourceToTargetTransform = NSAffineTransform()
        }
        
    }
    
    func frameCount() -> Int  {
        let inRange = NSRange(location:0 , length: Int(sourceProvider.frameCount()) )
        let outRange = inRange.transformRangeAlongY(sourceToTargetTransform)
        
        return outRange.length
    }
    
    func readFrames(range: NSRange) -> Float[] {
        let transformedRange = range.transformRangeAlongY(targetToSourceTransform)
        let sourceSamples = sourceProvider.readFrames(transformedRange)
        
        return resampleArray(sourceSamples,length:range.length)
    }
}