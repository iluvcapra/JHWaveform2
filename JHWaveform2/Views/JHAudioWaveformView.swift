//
//  JHAudioWaveformView.swift
//  JHWaveform2
//
//  Created by Jamie Hardt on 6/28/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import Cocoa

class JHAudioWaveformView: NSView {
    
    var waveformBezierPath: NSBezierPath? = nil
    
    var transformer:        JHWaveformTransformingFrameProvider?
    var frameProvider:      JHAudioFrameProvider? {
    
    didSet {
        if let fp = frameProvider {
            var xform = NSAffineTransform()
            xform.scaleXBy(self.bounds.width / CGFloat(fp.frameCount), yBy: self.bounds.height )
            transformer = JHWaveformTransformingFrameProvider(fp,transform: nil)
            calculateWaveformBezierPath()
        } else {
            transformer = nil
        }
        self.setNeedsDisplayInRect(self.bounds)
    }
    }
    
    init(frame: NSRect) {
        super.init(frame: frame)
    }

    func calculateWaveformBezierPath() -> Void {
        if let fp = transformer {
            let samples = fp.readFrames(NSMakeRange(0, fp.frameCount))
            
            var path = NSBezierPath()
            path.moveToPoint(NSPoint(x: 0.0,y: 0.0))
            for (i, sample) in enumerate(samples) {
                let point = CGPoint(x: CGFloat(i), y: CGFloat(sample) )
                path.lineToPoint(point)
            }
            path.lineToPoint(NSPoint(x:CGFloat(self.bounds.width), y: 0.0))
            
            waveformBezierPath = path
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
