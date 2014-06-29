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
    var frameProvider:      JHAudioFrameProvider? {
    
    didSet {
        calculateWaveformBezierPath()
    }
    }
    
    init(frame: NSRect) {
        super.init(frame: frame)
    }

    func calculateWaveformBezierPath() -> Void {
        if let fp = frameProvider {
            
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
        
        drawWaveform(dirtyRect)
    }
    
}
