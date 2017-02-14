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


class AudioEngine {
    let audioEngine: AVAudioEngine!
    let frameLength = UInt32(N)
    let bus = 0
    let subFrameLength = UInt32(N/2)
    let binWidth = 44100.0/Double(N)
    var frameVals = [Double](repeating: 0.0, count: N)
    
//    var frame: vector!
    var frame = vector(n: N)
    
    let fftSetup: FFTSetupD = fftInit(N: N)
    var fftArray: (real: vector, imag: vector)!
    var fftMagnitudes: vector!

    var hanningWindow: vector = 0.5 + 0.5*cos((pi * linspace(-0.5, max: 0.5, num: N))/(N/2))
    
    var frameStart: NSDate!
    
    var isSetup = false
    
    //Audio Generation
    let sineWave: AVTonePlayerUnit!
    
    
    
    
    init(){
        audioEngine = AVAudioEngine()
        sineWave = AVTonePlayerUnit()
        sineWave.frequency = 20000.0
        audioEngine.attach(sineWave)
        let mixer = audioEngine.mainMixerNode
        let format = AVAudioFormat(standardFormatWithSampleRate: sineWave.sampleRate, channels: 1)
        audioEngine.connect(sineWave, to: mixer, format: format)
        mixer.volume = 1.0
        
        sineWave.preparePlaying()
        
    }
    
    
    func setup(){
        guard let inputNode = audioEngine.inputNode else {
            print("Error finding input")
            return
        }
        
//        do {
//          var session = AVAudioSession.sharedInstance()
//          try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
//        
//        } catch {
//            print("error setting Category")
//        }
        
        inputNode.installTap(onBus: 0, bufferSize: frameLength, format: nil, block: {
            (buffer, time) in
            
            buffer.frameLength = self.frameLength
            
            self.frameStart = NSDate()
            let bfr = UnsafeBufferPointer(start: buffer.floatChannelData!.pointee, count: Int(buffer.frameLength))
            
            var i = 0
            
            for x in bfr {
                self.frame[i] = Double(x)
                i += 1
            }
            

            //Hanning Windowed FFT
            self.fftArray = fft(x: self.frame*self.hanningWindow, withSetup: self.fftSetup)
            let fftLength = 1+Int(self.frameLength)/2
            self.fftMagnitudes = sqrt((pow(self.fftArray.real[0..<fftLength], power: 2.0)) + (pow(self.fftArray.imag[0..<fftLength], power: 2.0)))
            
            return
        })
        
//        audioEngine.connect(inputNode, to: audioEngine.outputNode, format: inputNode.inputFormat(forBus: bus))
//        audioEngine.disconnectNodeOutput(inputNode)

        audioEngine.prepare()
        isSetup = true
        
        
            
            
            
        
    }
    
    func start() {
        if !isSetup {
            setup()
        }
        
        do {
            try audioEngine.start()
            sineWave.play()
        } catch {
            print("Audio Engine Start error")
        }
        

    }
    
    func stop() {
        sineWave.stop()

    }
    
    func cleanUp() {
        if isSetup {
            if let inputNode = audioEngine.inputNode {
                inputNode.removeTap(onBus: bus)
            }
            isSetup = false
        }
    }
    
    
}
