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
    
    
    var numSquares = 75
    var hexagons = [RegularPolygon]()
    var points = [Double]()
    
    var tapToggle = false
    var tapToggle2 = false

    var words = ["MOBGEN:Lab", "Amazing", "Heavy Metal", "Experimental", "Art", "Music", "Research", "Innovation", "The Future", "Tom Power", "Da Vinci"]
    let f = Font(font: UIFont(name: "Helvetica", size: 26.0)!)
    var textShape: TextShape!

    
    override func setup() {
        // Do any additional setup after loading the view, typically from a nib.
        engine = AudioEngine()
        engine.start()
        engine.sineWave.play()

        
        doppler = Doppler(frequency: engine.sineWave.frequency)
        
        doppler.delegate = self
        doppler.start()

        Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(proxUpdate), userInfo: nil, repeats: true)
        
        
        //C4 Stuff
        canvas.backgroundColor = black
        
        textShape = TextShape(text:words[0], font: f)!

        
        //create a shape using a string and font
        textShape.center = Point(100, 100)
        textShape.fillColor = white
        textShape.strokeColor = white
        
        //add the shape to the canvas
        canvas.add(textShape)
        
        for var i in 0..<numSquares {
            points.append(map(Double(i), min: 0.0, max: Double(numSquares), toMin: 0, toMax: π/2))
            hexagons.append(createHexagon(d: Double(i)*2.0))
        }
        
        var i=0
        for hexagon in hexagons {
            if (i%2==0) {
                hexagon.fillColor = nil
                hexagon.strokeColor = white
                hexagon.lineWidth = 0.8
            } else if (i == hexagons.count) {
                //Text
                
   
            }
            else {
                hexagon.fillColor = nil
                hexagon.strokeColor = orange
                hexagon.lineWidth = 0.8
                
                
            }
            canvas.add(hexagon)
            i+=1
            
        }
        
        canvas.addPanGestureRecognizer { locations, center, translation, velocity, state in
            
            for hexagon in self.hexagons {
                hexagon.center = center
            }
        }
        



        
        

    }

    func createHexagon(d: Double) -> RegularPolygon {
        let hexagon = RegularPolygon(center: canvas.center, radius: d, sides: 20)
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
    
    func proxUpdate(){
        doppler.proxUpdate()

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
//        canvas.backgroundColor = white
        var i=0
        for hexagon in self.hexagons {
            if (i%2==0) {
                hexagon.fillColor = nil
                hexagon.strokeColor = white
                hexagon.lineWidth = 0.5
                hexagon.sides = 3
            }
            else {
                hexagon.fillColor = nil
                hexagon.strokeColor = lightGray
                hexagon.lineWidth = 0.5
                hexagon.sides = 5
                
                
            }
            i+=1
            
            self.textShape.center = self.canvas.center

            self.textShape.text = "Tapped"

        }
        } else {
            canvas.backgroundColor = black
            var i=0
            for hexagon in self.hexagons {
                if (i%2==0) {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = white
                    hexagon.lineWidth = 0.8
                    hexagon.sides = 6
                }
                else {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = white
                    hexagon.lineWidth = 0.8
                    hexagon.sides = 6
                    
                    
                }
                i+=1
                self.textShape.center = self.canvas.center

                self.textShape.text = "Tapped"

            }
        }
        
        tapToggle = !tapToggle

    }
    
    func onSlowPull(_ sender: Doppler) {
        print("Pull")
        canvas.remove(textShape)
        self.textShape.text = "Slow Pull"
        self.textShape.center = self.canvas.center
        let rotateBackward = ViewAnimation(duration: 3.0, animations: {
            var i = 0
            for hexagon in self.hexagons {
                hexagon.rotation += sin(self.points[i]*2*π)*25
                hexagon.transform = Transform.makeScale(pow(sin(self.points[i]*2*π), 2), pow(sin(self.points[i]*2*π),2))
                
                self.points[i] -= 0.4
                i+=1
            }
//            self.textShape.rotation += sin(self.points[i]*2*π)*25


        })
        rotateBackward.animate()



    }
    
    func onSlowPush(_ sender: Doppler) {
        self.textShape.center = self.canvas.center
        
        self.textShape.text = "Slow Push"
        print("Push")
        let rotateForward = ViewAnimation(duration: 3.0, animations: {
            var i = 0
            for hexagon in self.hexagons {
                hexagon.rotation += sin(self.points[i]*2*π)*25
                hexagon.transform = Transform.makeScale(cos(pow(sin(self.points[i]*2*π), 2))*3, cos(pow(sin(self.points[i]*2*π),2))*3)
                self.points[i] += 0.2
                i+=1
            }
            
//            self.textShape.rotation -= sin(self.points[i]*2*π)*25

        })
        
        rotateForward.animate()


    }
    
    func onFastPull(_ sender: Doppler) {
        //        print("Pull")
        self.textShape.center = self.canvas.center
        
        self.textShape.text = "Fast Pull"
        let rotateBackward = ViewAnimation(duration: 0.5, animations: {
            var i = 0
            for hexagon in self.hexagons {
                hexagon.rotation += sin(self.points[i]*2*π)*25
                hexagon.transform = Transform.makeScale(pow(sin(self.points[i]*2*π), 2), pow(sin(self.points[i]*2*π),2))
                
                self.points[i] -= 0.4
                i+=1
            }
            
//            self.textShape.rotation += sin(self.points[i]*2*π)*25

        })
        rotateBackward.animate()
        
    }
    
    func onFastPush(_ sender: Doppler) {
        print("Push")
        //            self.textShape.rotation -= sin(self.points[i]*2*π)*25
        self.textShape.center = self.canvas.center
        
        self.textShape.text = "Fast Push"
        let rotateForward = ViewAnimation(duration: 0.5, animations: {
            var i = 0
            for hexagon in self.hexagons {
                hexagon.rotation += sin(self.points[i]*2*π)*25
                hexagon.transform = Transform.makeScale(cos(pow(sin(self.points[i]*2*π), 2))*3, cos(pow(sin(self.points[i]*2*π),2))*3)
                self.points[i] += 0.2
                i+=1
            }
            

        })
        
        rotateForward.animate()
        
    }
    
    func onNothing(_ sender: Doppler) {


    }
    
    func onDoubleTap(_ sender: Doppler) {
        print("Double Tap")

        if(!tapToggle2) {
            self.textShape.center = self.canvas.center
            
            self.textShape.text = "Double Tap"
//            canvas.backgroundColor = white
            self.textShape.lineWidth = 1.0
            var i=0
            for hexagon in self.hexagons {
                if (i%2==0) {
                    hexagon.fillColor = Color(UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.3))
                    hexagon.strokeColor = white
                    hexagon.lineWidth = 1.0
                    hexagon.sides = 5
                    hexagon.transform = Transform.makeScale(cos(pow(sin(self.points[i]*2*π), 2))*3, cos(pow(sin(self.points[i]*2*π),2))*3)

                }
                else {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = orange
                    hexagon.lineWidth = 2.0
                    hexagon.sides = 3
                    
                    
                }
                i+=1
            }


        } else {
            canvas.backgroundColor = black
            self.textShape.lineWidth = 1.0
            self.textShape.center = self.canvas.center
            self.textShape.fillColor = white
            self.textShape.text = "Double Tap"
            var i=0
            for hexagon in self.hexagons {
                if (i%2==0) {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = white
                    hexagon.lineWidth = 0.8
                    hexagon.sides = 20
                    hexagon.transform = Transform.makeScale(cos(pow(sin(self.points[i]*2*π), 2))*0.25, cos(pow(sin(self.points[i]*2*π),2))*0.25)

                }
                else {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = orange
                    hexagon.lineWidth = 0.8
                    hexagon.sides = 20
                    
                    
                }
                i+=1
                
            }

        }
        
        tapToggle2 = !tapToggle2

    }
    
    

    func onProximityClose(_ sender: Doppler) {
        let positionAnim = ViewAnimation(duration: 1.0, animations: {
            self.textShape.text = "Hand Close"
            self.textShape.center = Point(self.canvas.center.x + (random01()-1)*500,self.canvas.center.y)
        for hexagon in self.hexagons {
            hexagon.center = Point(self.canvas.center.x + (random01()-1)*500,self.canvas.center.y)
            }


        })
        
        positionAnim.animate()
    }

    func onProximityFar(_ sender: Doppler) {
        let posAnim = ViewAnimation(duration: 1.0, animations: {
            self.textShape.center = self.canvas.center

            for hexagon in self.hexagons {
                hexagon.center = self.canvas.center
                
            }

        })
        
        
        posAnim.animate()
 
    }
    



}

