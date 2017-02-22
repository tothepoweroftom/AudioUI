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
    var numPoints = 2000
    var sineWavePoints = [Point]()
    var sineWaveCircles = [Circle]()
    let margin = 50.0
    var theta = 0.0
    var period = 50.0
    var dx: Double!
    var amp = 50.0
    var spacing = 0.0
    
    //Walkthrough
    var walkthrough: BWWalkthroughViewController!
    
    
    override func setup() {
        canvas.backgroundColor = black
        spacing = (canvas.height - 2*margin)/Double(numPoints)
        dx = (2*pi / period) * spacing
        
        let img = Image("lab")
        img?.width = canvas.width/4
        img?.height = canvas.width/4
        img?.center = Point(canvas.width/4, canvas.height/2)
        canvas.add(img)
        

        
        createSineWave()
        renderSineWave()
        
        

    }
    


    @IBAction func triggerWalkthrough(_ sender: Any) {
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        walkthrough = stb.instantiateViewController(withIdentifier: "Master") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewController(withIdentifier: "page_1") as UIViewController
        let page_two = stb.instantiateViewController(withIdentifier: "page_2") as UIViewController
        let page_three = stb.instantiateViewController(withIdentifier: "page_3") as UIViewController
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        
        self.present(walkthrough, animated: true, completion: nil)

        
    }
    
    func walkthroughCloseButtonPressed() {
        walkthrough.dismiss(animated: true, completion: nil)
    }
    func createSineWave(){
        var x = theta
        for var i in 0...numPoints {
            let point = Point(canvas.center.x + amp*sin(x), margin + i*spacing)
            sineWavePoints.append(point)
            x+=dx
        }
    }
    
    func renderSineWave(){
        for point in sineWavePoints {
            let circle = Circle(center: point, radius: 1.0)
            circle.fillColor = white
            circle.strokeColor = nil
            sineWaveCircles.append(circle)
            canvas.add(circle)
        }
    }
    
    func updateSineWave(){
        var x = theta
        var i = 0
        for circle in sineWaveCircles {
            circle.center = Point(canvas.center.x + amp*sin(x), margin + i*spacing)
            i+=1
        }
        

        
    }

}
