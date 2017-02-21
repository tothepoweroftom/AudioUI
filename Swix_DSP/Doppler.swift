//
//  Doppler.swift
//  AudInt_2
//
//  Created by Tom Power on 13/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import Foundation

protocol DopplerDelegate: class {
    
    func dopplerDidStart(_ sender: Doppler )
//    func onRead(sender: Doppler)
    func dopplerDidEnd(_ sender: Doppler)
        //Do stuff when frames are read
    
    //Gestures
    func onSlowPush(_ sender: Doppler)
    func onSlowPull(_ sender: Doppler)
    func onFastPush(_ sender: Doppler)
    func onFastPull(_ sender: Doppler)
    func onTap(_ sender: Doppler)
    func onDoubleTap(_ sender: Doppler)
    func onNothing(_ sender: Doppler)
    func onProximityClose(_ sender: Doppler)
    func onProximityFar(_ sender: Doppler)

    
}



class Doppler {
    
    //Analysis Variables
    var leftBand = 0
    var rightBand = 0
    
    var fftSize = N
    var sampleRate = 44100.0
    
    //Frequency bins are scanned until the amp drops below 1% of the peak amp
    var maxVolRatio = 0.1
    var RELEVANT_FREQ_WINDOW = 15
    var SECOND_PEAK_RATIO = 0.3
    

    
    //AUDIOKIT PARAMETERS
    var frequency = 19000.0
    var amplitude = 1.0
    var freqIndex: Int!
    var fftData = [Double]()
    var velocity = 0
    var velLabel = ["none", "slow", "medium", "fast"]
    
    //Delegates
    var delegate: DopplerDelegate!
    
    //GESTURE DETECTION
    var previousDirection = 0
    var directionChanges = 0
    var cyclesLeftToRead = -1
    var cyclesToRefresh = 0
    var cyclesToRead = 5
    
    var proximity = 0.0
    
    
    //Booleans
    var calibrate = false
    var repeater = false
    var proxHasChanged = false
    var proxState = 0
    var proxPrevState = 0
    
    //Energy Accumulator
    var energy = 0.0
    var framesToSample = 5
    
    
    var referenceEnergy = 0.0
    var refEnergyArray = [Double]()
    var energyCounter = 0
    
    
    //False slow, true fast
    var speed = false
    
    init(frequency: Double){
        self.frequency = frequency
        freqIndex = freqToIndex(self.frequency, fftSize: fftSize, sampleRate: sampleRate)
        print(freqIndex)
        print(indexToFreq(freqIndex, fftSize: fftSize, sampleRate: sampleRate))
        
        
        
    }
    
    func start(){
 
        delegate?.dopplerDidStart(self)
        

        
    }
    
    func stop(){

        delegate?.dopplerDidEnd(self)
        
    }
    
    func update(fftData: [Double]) {
        self.fftData = fftData

        
        if (calibrate) {
            optimizeFrequency(minFreq: 18000, maxFreq: 21000)
            calibrateEnergy()

        } else {
            let bandwidths = self.getBandwidth()
            self.leftBand = bandwidths[0]
            self.rightBand = bandwidths[1]
            calculateGestures()
            calculateProximity()
            
        }
        
    }
    
    func calibrateEnergy() {
        if (energyCounter < framesToSample) {
            refEnergyArray.append(calculateEnergy(bandIndex: freqIndex, bandWidth: 5))
            energyCounter += 1
        } else if (energyCounter == framesToSample) {
            var r = 0.0
            for elem in refEnergyArray {
                r += elem
            }
            referenceEnergy = r/refEnergyArray.count
            print("Reference energy = \(referenceEnergy)")
            energyCounter += 1
            self.calibrate = false

        }
    }
    
    func getBandwidth() -> [Int] {
        //setup variables

        let bin = freqIndex
        var normalizedVolume = 0.0
        let binVolume = fftData[bin!]
        
        
        //LEFT Bandwidth -- First Scan

        var leftBandwidth = 0

        repeat {
            leftBandwidth += 1
            let volume = fftData[bin! - leftBandwidth] as Double
            normalizedVolume = volume/binVolume
        } while (normalizedVolume > maxVolRatio && leftBandwidth < RELEVANT_FREQ_WINDOW )
        
//        //LEFT Bandwidth -- Second Scan
        var secondaryScanFlag = 0
        var secondaryLeftBandwidth = leftBandwidth
        repeat {
                secondaryLeftBandwidth+=1
                let volume = fftData[bin!-secondaryLeftBandwidth]
                normalizedVolume = volume/binVolume
                    if (normalizedVolume > SECOND_PEAK_RATIO) {
                        secondaryScanFlag = 1
                    }
        
                    if (secondaryScanFlag == 1 && normalizedVolume < maxVolRatio ) {
                        break
                    }
                    
        } while (secondaryLeftBandwidth < RELEVANT_FREQ_WINDOW)
        
        //RIGHT Bandwidth -- First Scan
        
        var rightBandwidth = 0
        
        repeat {
            rightBandwidth+=1
            let volume = fftData[bin! + rightBandwidth]
            normalizedVolume = volume/binVolume
        } while(normalizedVolume > maxVolRatio && rightBandwidth < RELEVANT_FREQ_WINDOW)
        
//        //RIGHT Bandwidth -- Second Scan
        secondaryScanFlag = 0
        var secondaryRightBandwidth = 0
        
        repeat {
                secondaryRightBandwidth+=1
                let volume = fftData[bin!+secondaryRightBandwidth]
                normalizedVolume = volume/binVolume
    
                if (normalizedVolume > SECOND_PEAK_RATIO) {
                    secondaryScanFlag = 1
                }
        
                if (secondaryScanFlag == 1 && normalizedVolume < maxVolRatio ) {
                    break
                }
                    
        } while (secondaryRightBandwidth < RELEVANT_FREQ_WINDOW)

        if (secondaryScanFlag == 1) {
            rightBandwidth = secondaryRightBandwidth
        }
        
        
        
        
      return [leftBandwidth, rightBandwidth]
        
    }
    
    func calculateGestures(){
        
        if(cyclesToRefresh>0) {
            cyclesToRefresh -= 1



            return
        }
        

        
        if (leftBand > 4 || rightBand > 4) {
            let difference = leftBand - rightBand
            var direction = difference.sign()
            print("LB = \(leftBand) : RB = \(rightBand)")
            if(leftBand > 6 || rightBand > 6) {
                speed = true
            } else {
                speed = false
            }

            
            //Gestures
//            if(direction == 1) {
//                print("Direction: Postive")
//            } else if (direction == -1) {
//                print("Direction: Negative")
//            } else {
//                print("Direction: None")
//            }
            
            //Scan over a four frame window
            if (direction != 0 && direction != previousDirection) {
                cyclesLeftToRead = cyclesToRead
                previousDirection = direction
                directionChanges += 1
            }
        }
         cyclesLeftToRead -= 1
        
        
        
        if (cyclesLeftToRead == 0) {
            

            if (directionChanges == 1) {
                
                if (previousDirection == -1) {
                    if(speed) {
                        delegate?.onFastPush(self)
                    } else {
                        delegate?.onSlowPush(self)
                    }
//                    print("Push")
                } else {
                    if(speed) {
                        delegate?.onFastPull(self)
                    } else {
                        delegate?.onSlowPull(self)
                    }//                    print("LB = \(leftBand) : RB = \(rightBand)")

//                    print("Pull")

                }
                
            } else if ( directionChanges == 2 ) {
                
                delegate?.onTap(self)
//                print("Tap")
                
            } else {
                delegate?.onDoubleTap(self)
//                print("DoubleTap")
            }
            previousDirection = 0
            directionChanges = 0
            cyclesToRefresh = cyclesToRead
//            energy = 0.0
        } else {
            delegate?.onNothing(self)
//            print("_")

        }
        
//        energy = 0.0
        
    }
    
    func proxUpdate(){
        
        energy = calculateEnergy(bandIndex: freqIndex, bandWidth: 5)
        var thresholdMuliplier = 5
        
        if(referenceEnergy < 0.8){
            thresholdMuliplier = 5
        } else {
            thresholdMuliplier = 3
        }

        if (energy > thresholdMuliplier*referenceEnergy) {
            proxState = 1
            if(proxState != proxPrevState) {
                delegate?.onProximityClose(self)
//                print(energy/referenceEnergy)
//                print("Hand near")

                
            }
        } else {
            proxState = -1
            if(proxState != proxPrevState) {
                delegate?.onProximityFar(self)
//                print("Hand far")

                
            }
            
            
        }
        proxPrevState = proxState
    }
    
    func speedUpdate(){
        
        
    }
    
    func setFrequency(freq: Double){
        self.frequency = freq
    }
    
    func calculateProximity() {
        let bin = freqIndex
        var count = 0.0
        for i in bin!-5...bin!+5 {
            count += fftData[i]
        }
        print(count)
        
        delegate.updateProximity(self)
    }
    
    func optimizeFrequency(minFreq: Double, maxFreq: Double) {
        let minInd = freqToIndex(minFreq, fftSize: N, sampleRate: 44100.0)
        let maxInd = freqToIndex(maxFreq, fftSize: N, sampleRate: 44100.0)
        
        var primaryIndex = freqIndex
        
        for var i in minInd...maxInd {
            if(fftData[i] > fftData[primaryIndex!]) {
                primaryIndex = i
            }
        }
        
        self.setFrequency(freq: indexToFreq(primaryIndex!, fftSize: fftSize, sampleRate: 44100.0))
        print("Calibrated: " + "\(indexToFreq(primaryIndex!, fftSize: fftSize, sampleRate: 44100.0))")

    }
    
    func calculateEnergy(bandIndex: Int, bandWidth: Int) -> Double {
        var energy = 0.0
        
        for var i in bandIndex-bandWidth...bandIndex+bandWidth {
            energy += fftData[i]
        }
        
        return energy
        
        
    }
    

    
    
    
    
    
}
