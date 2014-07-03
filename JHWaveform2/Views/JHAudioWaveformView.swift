//
//  JHAudioWaveformView.swift
//  JHWaveform2
//
//  Created by Jamie Hardt on 6/28/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import Cocoa

class JHAudioWaveformView: NSView {
    
    var waveformBezierPath: NSBezierPath? = nil {
    didSet {
        self.setNeedsDisplayInRect(self.bounds)
    }
    }
    
    var transformer:        JHWaveformTransformingFrameProvider?
    var frameProvider:      JHAudioFrameProvider? {
    
    didSet {
        if let fp = frameProvider {
            let xform = NSAffineTransform()
            xform.scaleXBy(self.bounds.width / CGFloat(fp.frameCount), yBy: self.bounds.height )
            transformer = JHWaveformTransformingFrameProvider(fp,transform: xform.copy() as NSAffineTransform!)
            calculateWaveformBezierPath()
        } else {
            transformer = nil
        }
    }
    }
    
    init(frame: NSRect) {
        super.init(frame: frame)
    }
    
    func pointsForFrames(frames: Float[], start : Int) -> NSPoint[] {
        var retVal = NSPoint[]()
        retVal.reserveCapacity(frames.count)
        for (i, frame) in enumerate(frames) {
            retVal.append( NSPoint(x: CGFloat(i+start), y: CGFloat(frame) ) )
            
        }
        return retVal
    }

    func calculateWaveformBezierPath() -> Void {
        if let fp = transformer {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                
                let samples = fp.readFrames(NSMakeRange(0, fp.frameCount))
                
                dispatch_async(dispatch_get_main_queue()) {
                    var path = NSBezierPath()
                    path.moveToPoint(NSPoint(x: 0.0,y: 0.0))
                    var points = self.pointsForFrames(samples, start: 0)
                    path.appendBezierPathWithPoints( &points, count: points.count)
                    path.moveToPoint(NSPoint(x:CGFloat(self.bounds.width), y: 0.0))
                    
                    self.waveformBezierPath = path
                }
            }
        } else {
            waveformBezierPath = nil
        }
        
    }
    
    func drawWaveform(dirtyRect : NSRect) -> Void {
        if let path = waveformBezierPath {
            NSGraphicsContext.saveGraphicsState()
            
            NSColor.blackColor().setStroke()
            NSColor.grayColor().setFill()
            
            path.fill()
            path.stroke()
            
            NSGraphicsContext.restoreGraphicsState()
        }
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
        if transformer {
            drawWaveform(dirtyRect)
        }
    }
    
}
