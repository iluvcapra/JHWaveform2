//
//  JHMultichannelWaveformView.swift
//  JHWaveform2
//
//  Created by Jamie Hardt on 7/4/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import Cocoa

class JHMultichannelWaveformView: NSView {

    var waveformStyle: JHAudioWaveformView.WaveformStyle {
    get {
        return channelViews[0].waveformStyle
    }
    set {
        for view in self.channelViews {
            view.waveformStyle = newValue
        }
    }
    }
    
    var channelViews: JHAudioWaveformView[] = [] {
    willSet {
        self.subviews = []
    }
    
    didSet {
        self.subviews = channelViews

    }
    }
    
    var frameProvider : JHAudioFrameProvider? = nil {
    willSet {
        for view in channelViews {
            view.frameProvider = nil
        }
        channelViews = []
    }
    didSet {
        if let fp = frameProvider {
            let height = self.bounds.height / CGFloat(fp.channelCount)
            
            self.channelViews = Array(0..fp.channelCount).map {
                var thisframe = NSRect(x: 0.0,
                    y: height * CGFloat($0),
                    width: self.bounds.width,
                    height: height)
                
                var channelView = JHAudioWaveformView(frame: thisframe)
                channelView.channel = $0
                channelView.frameProvider = fp
                
                return channelView
            }
        }
    }
    }
    
    
    init(frame: NSRect) {
        super.init(frame: frame)
        
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

  
    }
    
}
