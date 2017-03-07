//
//  WebViewController.swift
//  Swix_DSP
//
//  Created by Tom Power on 23/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate, DopplerDelegate {
    
    var engine: AudioEngine!
    var doppler: Doppler!
    
    var webView : WKWebView!
    
    var button: UIButton!
    var upbutton: UIButton!
    var dnbutton: UIButton!

    var scroll: UIScrollView!
    var yPos: CGFloat = 0.0
    
    var enableScrolling = true

    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view, typically from a nib.
        engine = AudioEngine()
        engine.start()
        engine.sineWave.play()
        
        
        doppler = Doppler(frequency: engine.sineWave.frequency)
        
        doppler.delegate = self
        doppler.start()
        Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(update), userInfo: nil, repeats: true)

        
        // loading URL :
        let myBlog = "https://en.wikipedia.org/wiki/Batman"
        let url = URL(string: myBlog)
        let request = URLRequest(url: url!)
        

        
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        webView.navigationDelegate = self
        webView.load(request)
        self.view = webView
//        self.view.sendSubview(toBack: webView)
        
        button = UIButton(frame: CGRect(x: self.view.frame.size.width-30, y: 10, width: 20, height: 20))
        button.setImage(UIImage(named: "close-button_black"), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.add(button)
//
        upbutton = UIButton(frame: CGRect(x: 30, y: view.frame.height-50, width: 40, height: 20))
        upbutton.setTitle("UP", for: .normal)
        upbutton.tintColor = UIColor.black
        upbutton.setTitleColor(UIColor.black, for: .normal)
        view.addSubview(upbutton)
        view.bringToFront(upbutton)

        
        upbutton.addTarget(self, action: #selector(scrollUp), for: .touchUpInside)
        
        dnbutton = UIButton(frame: CGRect(x: view.frame.width-50, y: view.frame.height-50, width: 40, height: 20))
        dnbutton.setTitle("DN", for: .normal)
        dnbutton.setTitleColor(UIColor.black, for: .normal)
        dnbutton.tintColor = UIColor.black
        
        dnbutton.addTarget(self, action: #selector(scrollDown), for: .touchUpInside)


        view.add(dnbutton)
        view.bringToFront(dnbutton)

        
        scroll = webView.scrollView
        yPos = scroll.frame.maxY
        
    

        
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
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //        AppUtility.lockOrientation(.landscape)
        // Or to rotate and lock
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissView(){
        engine.sineWave.stop()
        self.engine.stop()
        self.engine.cleanUp()
        self.doppler.stop()
        self.dismiss(animated: true, completion: { [unowned self] in
            print("Dismissed")
            
        })
    }
    
    func scrollUp() {
        if(yPos < scroll.contentSize.height) {
        yPos += CGFloat(500.0)
        let poin = CGPoint(x: CGFloat(0), y: yPos)
        scroll.setContentOffset(poin, animated: true)
        } else {
            yPos = CGFloat(0.0)
            let poin = CGPoint(x: CGFloat(0), y: yPos)
            scroll.setContentOffset(poin, animated: true)
        }



        
    }
    
    func scrollDown(){
        
        if yPos >= CGFloat(0.0) {
        yPos -= CGFloat(500.0)
        let poin = CGPoint(x: CGFloat(0), y: yPos)
        scroll.setContentOffset(poin, animated: true)
        print(scroll.contentOffset)
        } else {
            yPos = CGFloat(0.0)
            let poin = CGPoint(x: CGFloat(0), y: yPos)
            scroll.setContentOffset(poin, animated: true)
        }

        

        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func dopplerDidEnd(_ sender: Doppler) {
        print("Doppler End")
    }
    
    func dopplerDidStart(_ sender: Doppler) {
        
        print("Doppler Start")
        
    }
    
    func onTap(_ sender: Doppler) {
//        enableScrolling = !enableScrolling
//        var str = " "
//        if (enableScrolling) {
//            str = "enabled"
//        } else {
//            str = "disabled"
//        }
//        let alert = UIAlertController(title: "Scrolling " + str, message: " ", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
//            alert.removeFromParentViewController()
//            
//            alert.dismiss(animated: true, completion: nil)
//        }))
//        self.present(alert, animated: true, completion: nil)
        
        enableScrolling = !enableScrolling
        var str = " "
        if (enableScrolling) {
            str = "enabled"
        } else {
            str = "disabled"
        }
        let alert = UIAlertController(title: "Scrolling " + str, message: " ", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
            alert.removeFromParentViewController()
            
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func scrolling(){
        enableScrolling = true
        print("Enablescrolling = true")
    }
    
    func onNothing(_ sender: Doppler) {
        
    }
    
    func onFastPull(_ sender: Doppler) {
        
        if(enableScrolling) {
            scrollDown()
            enableScrolling = false
            let date = Date().addingTimeInterval(1)
            let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(scrolling), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
    }
    
    func onFastPush(_ sender: Doppler) {
        if (enableScrolling) {
            scrollUp()
            enableScrolling = false
            let date = Date().addingTimeInterval(1)
            let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(scrolling), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
        
    }
    
    func onSlowPull(_ sender: Doppler) {
        if(enableScrolling) {
            scrollDown()
            enableScrolling = false
            let date = Date().addingTimeInterval(1)
            let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(scrolling), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
    }
    
    func onSlowPush(_ sender: Doppler) {
        if (enableScrolling) {
            scrollUp()
            enableScrolling = false
            let date = Date().addingTimeInterval(1)
            let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(scrolling), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
    }
    
    func onDoubleTap(_ sender: Doppler) {
        
        
    }
    
    func onProximityFar(_ sender: Doppler) {
        
    }
    
    func onProximityClose(_ sender: Doppler) {
        
    }


}
