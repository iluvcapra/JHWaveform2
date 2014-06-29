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
        }
    }
    }
    
    init(frame: NSRect) {
        super.init(frame: frame)
    }

    func calculateWaveformBezierPath() -> Void {
        if let fp = transformer {
            
        } else {
            waveformBezierPath = nil
        }
    }
    
    func drawWaveform(dirtyRect : NSRect) {
        if let path = waveformBezierPath {
            // FIXME impl
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        if frameProvider {
            drawWaveform(dirtyRect)
        }
    }
    
}
