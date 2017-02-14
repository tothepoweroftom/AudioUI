//
//  Helpers.swift
//  Swix_DSP
//
//  Created by Tom Power on 14/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import Foundation


//Helper Functions

func freqToIndex(_ freq: Double, fftSize: Int, sampleRate: Double) -> Int {
    var nyquist = sampleRate*0.5
    return Int(round(freq/nyquist * (Double(fftSize)/2)))
}

func indexToFreq(_ index: Int, fftSize: Int, sampleRate: Double) -> Double {
    
    var nyquist = sampleRate*0.5
    return (Double(2*index)*nyquist)/Double(fftSize)
}

extension Integer {
    func sign() -> Int {
        return (self < 0 ? -1 : 1)
    }
    /* or, use signature: func sign() -> Self */
}
