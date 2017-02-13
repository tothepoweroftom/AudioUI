//
//  AudioEngine.swift
//  Swix_DSP
//
//  Created by Tom Power on 09/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import Foundation
import AVFoundation

let N = 4096
let σ = 1.0/8.0


class AudioEngine {
    let audioEngine = AVAudioEngine()
    let frameLength = UInt32(N)
    let bus = 0
    let subFrameLength = UInt32(N/2)
    let binWidth = 44100.0/Double(N)
    var frameVals = [Double](repeating: 0.0, count: N)
    
    var frame: vector!
    var subFrame = vector(n: N/2)
    
    let fftSetup: FFTSetupD = fftInit(N: N)
    var fftArray: (real: vector, imag: vector)!
    var fftMagnitudes: vector!

    var hanningWindow: vector = 0.5 + 0.5*cos((pi * linspace(-0.5, max: 0.5, num: N))/(N/2))
    
    var frameStart: NSDate!

    
    init(){
        
    }
    
    
    func setup(){
        guard let inputNode = audioEngine.inputNode else {
            print("Error finding input")
            return
        }
        
        inputNode.installTap(onBus: 0, bufferSize: subFrameLength, format: nil, block: {
            (buffer, time) in
            
            buffer.frameLength = self.subFrameLength
            
            self.frameStart = NSDate()
            let bfr = UnsafeBufferPointer(start: buffer.floatChannelData!.pointee, count: Int(buffer.frameLength))
            
            var i = 0
            
            for x in bfr {
                self.subFrame[i] = Double(x)
                i += 1
            }
            
            
            
        
        })
    }
    
    
}
