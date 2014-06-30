JHWaveform2
===========

A reimplementation of JHWaveformView, in Swift.  The objective of this project is to provide an 
NSView/UIView subclass that can be dropped into an app for use as an audio preview.

I decided to start over rather than migrate JHWaveformView, because I'd made certain decisions
early in the JHWaveformView dev process that I realized later were mistakes, and starting over
would give a better foundation.


Interfaces
-------

* JHAudioWaveformView
  `JHAudioWaveformView` is a primitive NSView that will plot an variable-area graph of a 
  `JHAudioFrameProvider`.  It's meant to be composed with other views to make a complete widget.
* JHAudioFrameProvider
  `JHAudioFrameProvider` is a protocol for classes that vend samples to an 
  `JHAudioWaveformView`.
  * `JHAVAudioFileFrameProvider` is a class that implements `JHAudioFrameProvider`, it wraps
  a channel of an `AVAudioFile`.
  * `JHWaveformTransformingFrameProvider` is a class that implements `JHAudioFrameProvider`,
  it wraps another `JHAudioFrameProvider` and passes its frames through an affine transform,
  resampling and scaling the wrapped provider.
  
