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
        let start = NSPoint(x: CGFloat(self.location), y: 0 )
        let end = NSPoint(x: CGFloat(self.location + self.length), y: 0 )
        
        let transformedStart = xform.transformPoint(start)
        let transformedEnd = xform.transformPoint(end)
        let length = ceil(transformedEnd.x - transformedStart.x)
        
        return NSRange(location:Int(transformedStart.x), length:Int(length))
    }
    
    func toRange() -> Range<Int> {
        return Range(start:self.location, end:self.location+self.length)
    }
}


protocol JHAudioFrameProvider {
    
    var frameCount: Int  { get }
    var channelCount: Int { get }
    func readFrames(range: NSRange) -> Float[]
    func readFrames(range: NSRange, channel: Int) -> Float[]
}

class JHFloatArrayFrameProvider : JHAudioFrameProvider {
    
    var dataBuf : Array<Float>
    
    var channelCount = 1
    
    var frameCount: Int {
        return dataBuf.count
    }
    
    init(_ floatData: Float[] ) {
        dataBuf = floatData.copy()
    }
    
    func readFrames(range: NSRange) -> Float[] {
        return readFrames(range, channel: 0)
    }
    
    func readFrames(range: NSRange, channel: Int) -> Float[] {
        let s: Range<Int> = range.toRange()
        return Array(dataBuf[s])
    }
    
}

func resampleArray(samples: Float[], length l: Int) -> Float[] {
    let boundsRange = 0..samples.count
    let stride = samples.count / l
    let ranges = StridedRangeGenerator(boundsRange,stride: stride)
    
    
    var retArray: Float[] = Array(ranges).map {
        let end = min($0+stride, boundsRange.endIndex + 1)
        let theRange = Range(start: $0, end: end)
        let subArray = samples[theRange]
        return maxElement(subArray)
    }
    
    return retArray
}

func powResampleArray(samples: Float[], length l: Int) -> Float[] {
    return resampleArray(samples, length: l).map { powf($0, 2.0) }
}


class JHWaveformTransformingFrameProvider: JHAudioFrameProvider {
    
    var sourceProvider:             JHAudioFrameProvider
    var sourceToTargetTransform:    NSAffineTransform
    var targetToSourceTransform:    NSAffineTransform {
    get {
        var retVal = sourceToTargetTransform.copy() as NSAffineTransform
        retVal.invert()
        return retVal
    }
    }
    
    var channelCount: Int {
    get{
        return sourceProvider.channelCount
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
        return readFrames(range, channel: 0)
    }
    
    func readFrames(range: NSRange, channel: Int ) -> Float[] {
        let transformedRange = range.transformRangeAlongX(targetToSourceTransform)
        let sourceSamples = sourceProvider.readFrames(transformedRange, channel: channel)
        
        let xform = sourceToTargetTransform
        return resampleArray(sourceSamples,length:range.length).map {
            Float( xform.transformPoint( CGPointMake(0.0, CGFloat($0) )).y )
        }
    }
}