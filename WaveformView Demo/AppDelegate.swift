//
//  AppDelegate.swift
//  WaveformView Demo
//
//  Created by Jamie Hardt on 6/29/14.
//  Copyright (c) 2014 Jamie Hardt. All rights reserved.
//

import Cocoa
import JHWaveform2

class AppDelegate: NSObject, NSApplicationDelegate {
                            
    @IBOutlet var window        : NSWindow
    @IBOutlet var waveformView  : JHAudioWaveformView
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }
    
    @IBAction func selectAudioFile(sender: AnyObject?) {
        NSBeep()
    }


}

