//
//  JHAudioWaveformView.swift
//  JHWaveform2
//
//  Created by Jamie Hardt on 6/28/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import Cocoa

class JHAudioWaveformReadOperation : NSOperation {
    var provider: JHAudioFrameProvider
    var frameBlockSize: Int
    var view: JHAudioWaveformView
    
    init(_ provider: JHAudioFrameProvider, blockSize: Int, view: JHAudioWaveformView) {
        self.provider = provider
        self.frameBlockSize = blockSize
        self.view = view
    }
    
    override func main() {
        for i in (0..provider.frameCount).by(self.frameBlockSize) {
            if !self.cancelled {
                let frames = provider.readFrames(NSMakeRange(i, self.frameBlockSize), channel: view.channel)
                
                if !self.cancelled {
                    dispatch_async(dispatch_get_main_queue()) {
                        let points = self.view.pointsForFrames(frames, start: i)
                        
                        for j in 0..points.count {
                            if i+j < self.view.waveformPoints.count {
                                self.view.waveformPoints[i+j] = points[j]
                            }
                        }
                    }
                }
            }
        }
    }

}

class JHAudioWaveformView: NSView {
    
    var waveformPoints: NSPoint[] {
    didSet {
        self.setNeedsDisplayInRect(self.bounds)
    }
    }
    
    var waveformBezierPath: NSBezierPath {
    get {
        var path = NSBezierPath()
        path.moveToPoint(NSPoint(x: 0.0,y: 0.0))
        var points = self.waveformPoints
        path.appendBezierPathWithPoints( &points, count: points.count)
        path.lineToPoint(NSPoint(x:CGFloat(self.bounds.width), y: 0.0))
        return path
    }
    }
    
    var channel: Int = 0 {
    didSet {
        updateWaveform()
    }
    }
    
    var frameProvider: JHAudioFrameProvider? {
    didSet {
        updateWaveform()
        
    }
    }
    
    var readOperationQueue = NSOperationQueue()
    
    init(frame: NSRect) {
        waveformPoints = NSPoint[]()
        super.init(frame: frame)
        clearWaveformPoints()
        readOperationQueue.maxConcurrentOperationCount = 1
    }
    
    func updateWaveform()->() {
        readOperationQueue.cancelAllOperations()
        clearWaveformPoints()
        if let fp = frameProvider {
            let xform = NSAffineTransform()
            xform.scaleXBy(self.bounds.width / CGFloat(fp.frameCount), yBy: self.bounds.height )
            let transformer = JHWaveformTransformingFrameProvider(fp,transform: xform.copy() as NSAffineTransform!)
            readFramesFromProvider(transformer)
        }
    }
    
    func readFramesFromProvider(provider : JHAudioFrameProvider) {
        let readOp = JHAudioWaveformReadOperation(provider,blockSize: 50,view: self)
        readOperationQueue.addOperation(readOp)
    }
    
    func clearWaveformPoints()->() {
        waveformPoints = NSPoint[]()
        waveformPoints.reserveCapacity( Int(self.bounds.width) )
        for i in 0..Int(self.bounds.width) {
            waveformPoints.append( NSPoint( x: CGFloat(i) , y: 0.0 ) )
        }
    }
    
    func pointsForFrames(frames: Float[], start : Int) -> NSPoint[] {
        var retVal = NSPoint[]()
        retVal.reserveCapacity(frames.count)
        for (i, frame) in enumerate(frames) {
            retVal.append( NSPoint(x: CGFloat(i+start), y: CGFloat(frame) ) )
            
        }
        return retVal
    }
    
    func drawWaveform(dirtyRect : NSRect) -> Void {
        
        NSGraphicsContext.saveGraphicsState()
        
        NSColor.blackColor().setStroke()
        NSColor.grayColor().setFill()
        
        waveformBezierPath.fill()
        waveformBezierPath.stroke()
        
        NSGraphicsContext.restoreGraphicsState()
    }
    
    func drawBackground(dirtyRect: NSRect) -> Void {
        NSGraphicsContext.saveGraphicsState()
        
        NSColor.whiteColor().setFill()
        NSBezierPath.fillRect(dirtyRect)
        
        NSGraphicsContext.restoreGraphicsState()
    }
    
    override func drawRect(dirtyRect: NSRect) -> Void {
        super.drawRect(dirtyRect)
        drawBackground(dirtyRect)
        if frameProvider {
            drawWaveform(dirtyRect)
        } else {
            
        }
        
        
    }
    
}
