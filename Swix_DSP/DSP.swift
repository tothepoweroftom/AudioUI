//
//  DSP.swift
//  Swix_DSP
//
//  Created by Tom Power on 09/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import Foundation


//Initialise the FFT
func fftInit(N: Int) -> FFTSetupD {
    let radix: FFTRadix = FFTRadix(kFFTRadix2)
    let pass: vDSP_Length = vDSP_Length((log2(N.double)+1.0).int)
    let setup: FFTSetupD = vDSP_create_fftsetupD(pass, radix)!
    return setup
    
}

//Clear the fft
func fftDeInit(setup: FFTSetupD) {
    vDSP_destroy_fftsetupD(setup)
}



//FFT code - takes a vector x (frame) and returns real and imaginary parts.
func fft(x: vector, withSetup setup: FFTSetupD) -> (vector, vector) {
    let N: Int = x.n.int
    var yr = zeros(N)
    var yi = zeros(N)
    
    let log2n: Int = (log2(N.double)+1.0).int
    let z = zeros(N.int)
    var x2: DSPDoubleSplitComplex = DSPDoubleSplitComplex(realp: !x, imagp:!z)
    var y = DSPDoubleSplitComplex(realp:!yr, imagp:!yi)
    let dir = FFTDirection(FFT_FORWARD)
    let stride = 1.stride
    
    vDSP_fft_zropD(setup, &x2, stride, &y, stride, log2n.length, dir)
    
    yr /= 2.0
    yi /= 2.0
    return (yr, yi)
}

func ifft(yr: vector, yi: vector, withSetup setup: FFTSetupD) -> vector {
    let N = yr.n
    var x = zeros(N)
    
    let log2n: Int = (log2(N.double)+1.0).int
    let z = zeros(N)
    var x2: DSPDoubleSplitComplex = DSPDoubleSplitComplex(realp: !yr, imagp:!yi)
    var result: DSPDoubleSplitComplex = DSPDoubleSplitComplex(realp: !x, imagp:!z)
    let dir = FFTDirection(FFT_INVERSE)
    let stride = 1.stride
    
    vDSP_fft_zropD(setup, &x2, stride, &result, stride, log2n.length, dir)
    
    x /= 16.0
    return x
}
