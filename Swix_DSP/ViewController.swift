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
    var closeButton: UIButton!
    
    var numSquares = 100
    var hexagons = [RegularPolygon]()
    var points = [Double]()
    
    var tapToggle = false
    var tapToggle2 = false


    
    override func setup() {
        // Do any additional setup after loading the view, typically from a nib.
        engine = AudioEngine()
        engine.start()
        engine.sineWave.play()
        
        closeButton = UIButton(frame: CGRect(x: canvas.width-35, y: 15, width: 30, height: 30))
        closeButton.tintColor = UIColor.white
        closeButton.setImage(UIImage(named: "close-button"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeArt), for: .touchUpInside)
        canvas.add(closeButton)

        
        doppler = Doppler(frequency: engine.sineWave.frequency)
        
        doppler.delegate = self
        doppler.start()

        Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(proxUpdate), userInfo: nil, repeats: true)
        
        
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
                hexagon.lineWidth = 0.5
            } else if (i == hexagons.count) {
                //Text
                
   
            }
            else {
                hexagon.fillColor = nil
                hexagon.strokeColor = orange
                hexagon.lineWidth = 0.5
                
                
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
        let hexagon = RegularPolygon(center: canvas.center, radius: d, sides: 30)
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
//        print("Tap")
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
            


        }
        } else {
            canvas.backgroundColor = black
            var i=0
            for hexagon in self.hexagons {
                if (i%2==0) {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = white
                    hexagon.lineWidth = 0.5
                    hexagon.sides = 6
                }
                else {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = white
                    hexagon.lineWidth = 0.5
                    hexagon.sides = 6
                    
                    
                }
                i+=1


            }
        }
        
        tapToggle = !tapToggle

    }
    
    func onSlowPull(_ sender: Doppler) {
//        print("Pull")

        let rotateBackward = ViewAnimation(duration: 3.0, animations: {
            for hexagon in self.hexagons {
                hexagon.center = Point(self.canvas.center.x + (random01())*500,self.canvas.center.y)

            }


        })
        rotateBackward.animate()



    }
    
    func onSlowPush(_ sender: Doppler) {
        


//        print("Push")
        let rotateForward = ViewAnimation(duration: 3.0, animations: {
            var i = 0
            for hexagon in self.hexagons {
//                hexagon.rotation += sin(self.points[i]*2*π)*25
//                hexagon.transform = Transform.makeScale(cos(pow(sin(self.points[i]*2*π), 2))*3, cos(pow(sin(self.points[i]*2*π),2))*3)
//                self.points[i] += 0.2
//                i+=1
                hexagon.center = Point(self.canvas.center.x - (random01())*500,self.canvas.center.y)

            }

        })
        
        rotateForward.animate()


    }
    
    func onFastPull(_ sender: Doppler) {

        let rotateBackward = ViewAnimation(duration: 1.5, animations: {
            var i = 0
            for hexagon in self.hexagons {
                hexagon.rotation += sin(self.points[i]*2*π)*25
                hexagon.transform = Transform.makeScale(pow(sin(self.points[i]*2*π), 2), pow(sin(self.points[i]*2*π),2))
                hexagon.center = self.canvas.center
                self.points[i] -= 0.4
                i+=1
            }
            
//            self.textShape.rotation += sin(self.points[i]*2*π)*25

        })
        rotateBackward.animate()
        
    }
    
    func onFastPush(_ sender: Doppler) {
//        print("Push")
        
        let rotateForward = ViewAnimation(duration: 1.5, animations: {
            var i = 0
            for hexagon in self.hexagons {
                hexagon.rotation += sin(self.points[i]*2*π)*25
                hexagon.transform = Transform.makeScale(cos(pow(sin(self.points[i]*2*π), 2))*3, cos(pow(sin(self.points[i]*2*π),2))*3)
                self.points[i] += 0.2
                hexagon.center = self.canvas.center

                i+=1
            }
            

        })
        
        rotateForward.animate()
        
    }
    
    func onNothing(_ sender: Doppler) {


    }
    
    func onDoubleTap(_ sender: Doppler) {

        if(!tapToggle2) {
            
//            canvas.backgroundColor = white
            var i=0
            for hexagon in self.hexagons {
                if (i%2==0) {
                    hexagon.fillColor = Color(UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.3))
                    hexagon.strokeColor = white
                    hexagon.lineWidth = 0.5
                    hexagon.sides = 5
                    hexagon.transform = Transform.makeScale(cos(pow(sin(self.points[i]*2*π), 2))*3, cos(pow(sin(self.points[i]*2*π),2))*3)

                }
                else {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = orange
                    hexagon.lineWidth = 0.5
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
                    hexagon.lineWidth = 0.5
                    hexagon.sides = 20
                    hexagon.transform = Transform.makeScale(cos(pow(sin(self.points[i]*2*π), 2))*0.25, cos(pow(sin(self.points[i]*2*π),2))*0.25)

                }
                else {
                    hexagon.fillColor = nil
                    hexagon.strokeColor = orange
                    hexagon.lineWidth = 0.5
                    hexagon.sides = 20
                    
                    
                }
                i+=1
                
            }

        }
        
        tapToggle2 = !tapToggle2

    }
    
    

    func onProximityClose(_ sender: Doppler) {
        let positionAnim = ViewAnimation(duration: 1.0, animations: {
        for hexagon in self.hexagons {
            hexagon.center = Point(self.canvas.center.x ,self.canvas.center.y + (random01()-1)*500)
            }


        })
        
        positionAnim.animate()
    }

    func onProximityFar(_ sender: Doppler) {
        let posAnim = ViewAnimation(duration: 1.0, animations: {

            for hexagon in self.hexagons {
                hexagon.center = self.canvas.center
                
            }

        })
        
        
        posAnim.animate()
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "return" {
            doppler.stop()
            engine.stop()
        }
    }
    


    func closeArt(){
        performSegue(withIdentifier: "return", sender: self)
        
    }

}

