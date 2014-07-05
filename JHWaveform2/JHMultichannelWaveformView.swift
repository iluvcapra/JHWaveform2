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
                
                var channelView = JHAudioWaveformView(frame: self.boundsRectForChannel($0))
                channelView.channel = $0
                channelView.frameProvider = fp
                var color = self.colorForChannel($0)
                channelView.strokeColor = color
                channelView.fillColor = color.colorWithAlphaComponent(0.3)
                channelView.backgroundColor = NSColor.whiteColor().colorWithAlphaComponent(0.0)
                
                return channelView
            }
        }
    }
    }
    

    enum MultichannelStyle {
        case OneLane
        case HalfOverlap
        case MultiLane
    }
    
    var multichannelStyle: MultichannelStyle = .MultiLane {
    didSet {
        moveChannelFrames()
    }
    }
    
    var backgroundColor: NSColor = NSColor.controlBackgroundColor()
    
    let channelColorCarousel: Array<NSColor> = [
        NSColor.redColor(),
        NSColor.blueColor(),
        NSColor.orangeColor(),
        NSColor.greenColor(),
        NSColor.purpleColor(),
        NSColor.brownColor()]
    
    init(frame: NSRect) {
        super.init(frame: frame)
        
    }
    
    func moveChannelFrames() -> () {
        var anims = Array<NSDictionary>()
        for (i, view) in enumerate(self.channelViews) {
            var thisAnim = NSMutableDictionary()
            thisAnim.setObject(view, forKey: NSViewAnimationTargetKey)
            thisAnim.setObject(NSValue(rect: view.frame), forKey: NSViewAnimationStartFrameKey)
            thisAnim.setObject(NSValue(rect:boundsRectForChannel(i)), forKey: NSViewAnimationEndFrameKey )
            
            anims.append(thisAnim)
        }
        
        var animation = NSViewAnimation(viewAnimations: anims)
        animation.duration = 1.0
        animation.animationCurve = NSAnimationCurve.Linear
        animation.startAnimation()
        
    }
    
    func colorForChannel(channelIndex : Int) -> NSColor {
        return self.channelColorCarousel[ channelIndex % self.channelColorCarousel.count ]
    }
    
    func boundsRectForChannel(channelIndex : Int) -> NSRect {
        var retVal = NSZeroRect
        if let fp = self.frameProvider {
            
            switch multichannelStyle {
            case .HalfOverlap:
                fallthrough
                
            case .MultiLane:
                let height = self.bounds.height / CGFloat(fp.channelCount)
                
                retVal = NSRect(x: 0.0,
                    y: height * CGFloat((fp.channelCount - 1) - channelIndex),
                    width: self.bounds.width,
                    height: height)
                
            case .OneLane:
                retVal = self.bounds
            }
        }
        return retVal
    }
    

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        NSGraphicsContext.saveGraphicsState()
        
        backgroundColor.setFill()
        NSBezierPath.fillRect(dirtyRect)
        
        NSGraphicsContext.restoreGraphicsState()
    }
    
}
