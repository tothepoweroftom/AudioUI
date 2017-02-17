//
//  ViewController.swift
//  Swix_DSP
//
//  Created by Tom Power on 09/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import UIKit
import Charts
import C4

class ViewController: CanvasController, DopplerDelegate {
    
    var engine: AudioEngine!
    var doppler: Doppler!
    
    
    var numSquares = 150
    var hexagons = [RegularPolygon]()
    var points = [Double]()
    
    var tapToggle = false
    var tapToggle2 = false

    
    
    override func setup() {
        // Do any additional setup after loading the view, typically from a nib.
        engine = AudioEngine()
        engine.start()
        engine.sineWave.play()

        
        doppler = Doppler(frequency: engine.sineWave.frequency)
        
        doppler.delegate = self
        doppler.start()

        Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
        
        //C4 Stuff
        
        canvas.backgroundColor = black
        
        for var i in 0..<numSquares {
            points.append(map(Double(i), min: 0.0, max: Double(numSquares), toMin: 0, toMax: π/2))
            hexagons.append(createHexagon(d: Double(i)*2.0))
        }
        
        var i=0
        for hexagon in hexagons {
            if (i%2==0) {
                hexagon.fillColor = nil
                hexagon.strokeColor = white
                hexagon.lineWidth = 0.25
            }
            else {
                hexagon.fillColor = nil
                hexagon.strokeColor = orange
                hexagon.lineWidth = 0.25
                
                
            }
            canvas.add(hexagon)
            i+=1
            
        }
        

        

        
        

    }

    func createHexagon(d: Double) -> RegularPolygon {
        let hexagon = RegularPolygon(center: canvas.center, radius: d*0.5)
        return hexagon
    }
    
    func update() {
//        print(engine.fftMagnitudes)
//        
        if (engine.fftMagnitudes != nil) {
        
        var fftData = [Double]()
        for var i in 0..<engine.fftMagnitudes.n {
            fftData.append(engine.fftMagnitudes[i])
        }
        doppler.update(fftData: fftData)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dopplerDidStart(_ sender: Doppler) {
        print("Doppler Start")
    }
    
    func dopplerDidEnd(_ sender: Doppler) {
        print("Doppler End")

    }
    
    func onTap(_ sender: Doppler) {
        print("Tap")
        if(!tapToggle) {
        canvas.backgroundColor = white
        var i=0
        for hexagon in self.hexagons {
            if (i%2==0) {
                hexagon.fillColor = nil
                hexagon.strokeColor = black
                hexagon.lineWidth = 0.1
                hexagon.sides = 3
            }
            else {
                hexagon.fillColor = nil
                hexagon.strokeColor = lightGray
                hexagon.lineWidth = 0.1
                hexagon.sides = 3
                
                
            }
            i+=1
        }
        } else {
            canvas.backgroundColor = black
            var i=0
            for hexagon in self.hexagons {
                if (i%2==0) {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = white
                    hexagon.lineWidth = 0.25
                    hexagon.sides = 6
                }
                else {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = orange
                    hexagon.lineWidth = 0.25
                    hexagon.sides = 6
                    
                    
                }
                i+=1

            }
        }
        
        tapToggle = !tapToggle

    }
    
    func onPull(_ sender: Doppler) {
        print("Pull")
        let rotateBackward = ViewAnimation(duration: 2.0, animations: {
            var i = 0
            for hexagon in self.hexagons {
                hexagon.rotation += sin(self.points[i]*2*π)*25
                hexagon.transform = Transform.makeScale(pow(sin(self.points[i]*2*π), 2), -pow(sin(self.points[i]*2*π),2))
                
                self.points[i] -= 0.4
                i+=1
            }
        })
        rotateBackward.animate()


    }
    
    func onPush(_ sender: Doppler) {
        print("Push")
        let rotateForward = ViewAnimation(duration: 2.0, animations: {
            var i = 0
            for hexagon in self.hexagons {
                hexagon.rotation += sin(self.points[i]*2*π)*25
                hexagon.transform = Transform.makeScale(cos(pow(sin(self.points[i]*2*π), 2))*4, cos(pow(sin(self.points[i]*2*π),2))*4)
                self.points[i] += 0.2
                i+=1
            }
        })
        
        rotateForward.animate()

    }
    
    func onNothing(_ sender: Doppler) {
        print(" ")


    }
    
    func onDoubleTap(_ sender: Doppler) {
        print("Double Tap")

        if(!tapToggle2) {
            canvas.backgroundColor = white
            var i=0
            for hexagon in self.hexagons {
                if (i%2==0) {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = black
                    hexagon.lineWidth = 0.1
                    hexagon.sides = 12
                    hexagon.transform = Transform.makeScale(cos(pow(sin(self.points[i]*2*π), 2))*4, cos(pow(sin(self.points[i]*2*π),2))*4)

                }
                else {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = lightGray
                    hexagon.lineWidth = 0.1
                    hexagon.sides = 12
                    
                    
                }
                i+=1
            }
        } else {
            canvas.backgroundColor = black
            var i=0
            for hexagon in self.hexagons {
                if (i%2==0) {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = white
                    hexagon.lineWidth = 0.25
                    hexagon.sides = 6
                    hexagon.transform = Transform.makeScale(cos(pow(sin(self.points[i]*2*π), 2))*4, cos(pow(sin(self.points[i]*2*π),2))*0.25)

                }
                else {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = orange
                    hexagon.lineWidth = 0.25
                    hexagon.sides = 6
                    
                    
                }
                i+=1
                
            }
        }
        
        tapToggle2 = !tapToggle2

    }
    

    



}

