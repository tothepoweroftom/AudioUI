//
//  SplashViewController.swift
//  Swix_DSP
//
//  Created by Tom Power on 21/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import UIKit
import C4
//import SwiftGif


@IBDesignable class SplashViewController: CanvasController, BWWalkthroughViewControllerDelegate {
    var numPoints = 100
    var sineWavePoints = [Point]()
    var sineWaveCircles = [Line]()
    var sineWavePoints2 = [Point]()
    var sineWaveCircles2 = [Circle]()
    let margin = 120.0
    var theta = 0.0
    var theta2 = 0.0

    var period = 70.0
    var dx: Double!
    var amp = 60.0
    var spacing = 0.0
    var anim: ViewAnimation!
    
    //Walkthrough
    var walkthrough: BWWalkthroughViewController!
    
    
    override func setup() {
        canvas.backgroundColor =  Color(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1.0)
        spacing = (canvas.width)/Double(numPoints)
        dx = (2*pi / period) * spacing
        self.createSineWave()
        self.renderSineWave()
        
        Timer.scheduledTimer(timeInterval: 0.08, target: self, selector: #selector(updateTheta), userInfo: nil, repeats: true)
//        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateAmp), userInfo: nil, repeats: true)

    }
    



    @IBAction func triggerWalkthrough(_ sender: Any) {
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        walkthrough = stb.instantiateViewController(withIdentifier: "Master") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewController(withIdentifier: "page_1") as UIViewController
        let page_two = stb.instantiateViewController(withIdentifier: "page_2") as UIViewController
        let page_three = stb.instantiateViewController(withIdentifier: "page_3") as UIViewController
        let page_four = stb.instantiateViewController(withIdentifier: "page_4") as UIViewController
        let page_five = stb.instantiateViewController(withIdentifier: "page_5") as UIViewController
        let page_six = stb.instantiateViewController(withIdentifier: "page_6") as UIViewController

        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        walkthrough.add(viewController:page_four)
        walkthrough.add(viewController:page_five)
            walkthrough.add(viewController:page_six)
        
        self.present(walkthrough, animated: true, completion: nil)

        
    }
    
    func walkthroughCloseButtonPressed() {
        walkthrough.dismiss(animated: true, completion: nil)
    }
    
    func updateTheta(){
        theta += 0.1
        updateSineWave()
    }
    
    func updateAmp(){
        amp = 60.0 * random01()
    }
    
    func createSineWave(){
        sineWavePoints.removeAll()
        var x = theta
        for var i in 0...numPoints {
            let point = Point( i*spacing, 100)
            sineWavePoints.append(point)
            x+=dx
        }
        sineWavePoints2.removeAll()
        x = theta2
        for var i in 0...numPoints {
            let point = Point(i*spacing+25, 100)
            sineWavePoints2.append(point)
            x+=dx
        }
    }
    
    func renderSineWave(){
        sineWaveCircles.removeAll()
        var x = theta
        let height = sin(x+random01())

        for point in sineWavePoints {
            let point1 = Point(point.x, point.y - height)
            let point2 = Point(point.x, point.y + height)
            let line = Line(begin: point2, end: point1)
            line.lineWidth = 0.4
            line.strokeColor = lightGray
            sineWaveCircles.append(line)
            canvas.add(line)
            x+=dx
        }

    }
    
    func updateSineWave(){
        var x = theta
        var i = 0
        for line in sineWaveCircles {
            let dH = random01()*20

            let change = amp*sin(x) + dH
            line.points[0].y =  100 + change
            line.points[1].y =  100 - change
            


            
            x+=dx
        }

        
        
 
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    


}


