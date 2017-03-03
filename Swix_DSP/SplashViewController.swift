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
    var numPoints = 40
    var sineWavePoints = [Point]()
    var sineWaveCircles = [Circle]()
    var sineWavePoints2 = [Point]()
    var sineWaveCircles2 = [Circle]()
    let margin = 60.0
    var theta = 0.0
    var theta2 = 0.0

    var period = 100.0
    var dx: Double!
    var amp = 30.0
    var spacing = 0.0
    var anim: ViewAnimation!
    
    //Walkthrough
    var walkthrough: BWWalkthroughViewController!
    
    
    override func setup() {
        canvas.backgroundColor =  Color(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1.0)


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
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.add(viewController:page_one)
        walkthrough.add(viewController:page_two)
        walkthrough.add(viewController:page_three)
        walkthrough.add(viewController:page_four)
        walkthrough.add(viewController:page_five)
        
        self.present(walkthrough, animated: true, completion: nil)

        
    }
    
    func walkthroughCloseButtonPressed() {
        walkthrough.dismiss(animated: true, completion: nil)
    }
    func createSineWave(){
        sineWavePoints.removeAll()
        var x = theta
        for var i in 0...numPoints {
            let point = Point(canvas.center.x + amp*sin(x), margin + i*spacing)
            sineWavePoints.append(point)
            x+=dx
        }
        sineWavePoints2.removeAll()
        x = theta2
        for var i in 0...numPoints {
            let point = Point(canvas.center.x + amp*sin(x + pi) , margin + i*spacing)
            sineWavePoints2.append(point)
            x+=dx
        }
    }
    
    func renderSineWave(){
        sineWaveCircles.removeAll()
        for point in sineWavePoints {
            let circle = Circle(center: point, radius: 2.0)
            circle.fillColor = white
            circle.strokeColor = nil
            sineWaveCircles.append(circle)
            canvas.add(circle)
        }
        for point in sineWavePoints2 {
            let circle = Circle(center: point, radius: 1.0)
            circle.fillColor = lightGray
            circle.strokeColor = nil
            sineWaveCircles2.append(circle)
            canvas.add(circle)
        }
    }
    
    func updateSineWave(){
        var x = theta
        var i = 0
        for circle in sineWaveCircles {
            circle.center = Point(canvas.center.x + amp*sin(x), margin + i*spacing)
            i+=1
            x+=dx
        }
        x = theta2
        i = 0
        for circle in sineWaveCircles2 {
            circle.center = Point(canvas.center.x + amp*sin(x + pi), margin + i*spacing)
            i+=1
            x+=dx
        }
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    


}
