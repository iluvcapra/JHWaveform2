//
//  JHAudioWaveformView.swift
//  JHWaveform2
//
//  Created by Jamie Hardt on 6/28/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import Cocoa

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
        path.moveToPoint(NSPoint(x:CGFloat(self.bounds.width), y: 0.0))
        return path
    }
    }
    
   // var transformer:        JHWaveformTransformingFrameProvider?
    var frameProvider:      JHAudioFrameProvider? {
    
    didSet {
        clearWaveformPoints()
        if let fp = frameProvider {
            let xform = NSAffineTransform()
            xform.scaleXBy(self.bounds.width / CGFloat(fp.frameCount), yBy: self.bounds.height )
            let transformer = JHWaveformTransformingFrameProvider(fp,transform: xform.copy() as NSAffineTransform!)
            readFramesFromProvider(transformer)
        }
        
    }
    }
    
    init(frame: NSRect) {
        waveformPoints = NSPoint[]()
        super.init(frame: frame)
        clearWaveformPoints()
    }
    
    func readFramesFromProvider(provider : JHAudioFrameProvider) {
        let frames = provider.readFrames(NSMakeRange(0, provider.frameCount))
        self.waveformPoints = self.pointsForFrames(frames, start: 0)
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
