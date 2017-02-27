//
//  CookViewController.swift
//  Swix_DSP
//
//  Created by Tom Power on 23/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import UIKit

class CookViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, DopplerDelegate {

    
    var engine: AudioEngine!
    var doppler: Doppler!
    
    
    let pages = ["PagesContentController1", "PagesContentController2"]
    var vcs = [UIViewController]()

    var button: UIButton!
    var enableScrolling = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        self.dataSource = self
        
        button = UIButton(frame: CGRect(x: self.view.frame.size.width-30, y: 10, width: 20, height: 20))
        button.setImage(UIImage(named: "close-button_black"), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view.add(button)
        
        // Do any additional setup after loading the view, typically from a nib.
        engine = AudioEngine()
        engine.start()
        engine.sineWave.play()
        
        
        doppler = Doppler(frequency: engine.sineWave.frequency)
        
        doppler.delegate = self
        doppler.start()
        Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        

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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PagesContentController1")
        let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "PagesContentController2")
        vcs.append(vc!)
        vcs.append(vc2!)
        
        setViewControllers([vc!], // Has to be a single item array, unless you're doing double sided stuff I believe
            direction: .forward,
            animated: true,
            completion: nil)
        
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
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.view = nil
        engine.stop()
        doppler.stop()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        engine.stop()
        doppler.stop()
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index > 0 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index-1])
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let identifier = viewController.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                if index < pages.count - 1 {
                    return self.storyboard?.instantiateViewController(withIdentifier: pages[index+1])
                }
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count

    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let identifier = viewControllers?.first?.restorationIdentifier {
            if let index = pages.index(of: identifier) {
                return index
            }
        }
        return 0
    }
    
    
    func dopplerDidEnd(_ sender: Doppler) {
        print("Doppler End")
    }
    
    func dopplerDidStart(_ sender: Doppler) {
        
        print("Doppler Start")
        
    }
    
    func onTap(_ sender: Doppler) {
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
    
    func onNothing(_ sender: Doppler) {
        
    }
    
    func onFastPull(_ sender: Doppler) {
        
        if(enableScrolling) {
        guard let currentViewController = self.viewControllers?.first else { return }
        
        guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
        
        setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func onFastPush(_ sender: Doppler) {
        if (enableScrolling) {
        guard let currentViewController = self.viewControllers?.first else { return }
        
        guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }
        
        setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
        }
        
    }
    
    func onSlowPull(_ sender: Doppler) {
        
        if(enableScrolling) {
            guard let currentViewController = self.viewControllers?.first else { return }
            
            guard let nextViewController = dataSource?.pageViewController( self, viewControllerAfter: currentViewController ) else { return }
            
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func onSlowPush(_ sender: Doppler) {
        if (enableScrolling) {
            guard let currentViewController = self.viewControllers?.first else { return }
            
            guard let previousViewController = dataSource?.pageViewController( self, viewControllerBefore: currentViewController ) else { return }
            
            setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func onDoubleTap(_ sender: Doppler) {


    }
    
    func onProximityFar(_ sender: Doppler) {
        
    }
    
    func onProximityClose(_ sender: Doppler) {
        
    }
}
