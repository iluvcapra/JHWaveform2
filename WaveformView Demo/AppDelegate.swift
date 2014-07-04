//
//  AppDelegate.swift
//  WaveformView Demo
//
//  Created by Jamie Hardt on 6/29/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import Cocoa
import JHWaveform2
import AVFoundation

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet var window        : NSWindow
    @IBOutlet var waveformView  : JHAudioWaveformView
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        //var fp = JHAVAudioFileFrameProvider(file: file, channelIndex: 0)
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    @IBAction func selectAudioFile(sender: AnyObject?) {
        var p = NSOpenPanel()
        p.beginSheetModalForWindow(self.window, completionHandler: { retval in
            if retval == NSFileHandlingPanelOKButton {
                var error : NSError? = nil
                if error {
                    self.window.presentError(error)
                } else {
                    let fp = JHAVAudioFileFrameProvider(fileURL:p.URL)
                    self.waveformView.frameProvider = fp
                }
            }
        })
            
    }


}

