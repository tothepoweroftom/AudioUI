//
//  ViewController.swift
//  Swix_DSP
//
//  Created by Tom Power on 09/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import UIKit
import Charts


class DemoViewController: UIViewController, DopplerDelegate {
    
    var engine: AudioEngine!
    var doppler: Doppler!
    
    
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var speedView: UIImageView!
    @IBOutlet weak var proxView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var proxLabel: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engine = AudioEngine()
        engine.start()
        engine.sineWave.play()
        
        self.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.height, height: self.view.frame.size.width)
        
        
        doppler = Doppler(frequency: engine.sineWave.frequency)
        
        doppler.delegate = self
        doppler.start()
        
        Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(proxUpdate), userInfo: nil, repeats: true)
        
    }
    
 
    
    
    func update() {
        //        print(engine.fftMagnitudes)
        //
        if (engine.fftMagnitudes != nil) {
            //        var dataEntries: [BarChartDataEntry] = []
            //
            //        var index = freqToIndex(22000, fftSize: N, sampleRate: 44100.0)
            //
            //        for i in index-300..<index {
            //            let dataEntry = BarChartDataEntry(x: Double(i), y: engine.fftMagnitudes[i])
            //            dataEntries.append(dataEntry)
            //
            //        }
            //
            //        let chartDataSet = BarChartDataSet(values: dataEntries, label: "FFT Mags")
            //            chartDataSet.colors = [UIColor.red]
            //        let chartData = BarChartData(dataSet: chartDataSet)
            //        barChartView.data = chartData
            //
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
         AppUtility.lockOrientation(.landscapeRight, andRotateTo: .landscapeRight)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all, andRotateTo: .portrait)
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
        imageView.image = UIImage(named: "tapFig")
        self.label.text = "Tap"
    }
    
    func onSlowPull(_ sender: Doppler) {
        //        print("Pull")
        imageView.image = UIImage(named: "slowRightFig")
        speedView.image = UIImage(named: "slowRight")
        
        self.speedLabel.text = "Slow Right"
        
    }
    
    func onSlowPush(_ sender: Doppler) {
        //        print("Push")
        imageView.image = UIImage(named: "slowLeftFig")
        speedView.image = UIImage(named: "slowLeft")
        
//        self.label.text = "Pushed"
        self.speedLabel.text = "Slow Left"
        
    }
    
    func onFastPull(_ sender: Doppler) {
        //        print("Pull")
        imageView.image = UIImage(named: "fastRightFig")
        speedView.image = UIImage(named: "fastRight")
        
        self.speedLabel.text = "Fast Right"
        
    }
    
    func onFastPush(_ sender: Doppler) {
        //        print("Push")
        imageView.image = UIImage(named: "fastLeftFig")
        speedView.image = UIImage(named: "fastLeft")
        
        self.speedLabel.text = "Fast Left"
        
    }
    
    func onNothing(_ sender: Doppler) {
        //        print(" ")
        imageView.image = UIImage(named: "listenA")
//        label.text = "..."
        //        speedView.image = UIImage(named: "ear")
        
        
    }
    
    func onDoubleTap(_ sender: Doppler) {
        //        print("Double Tap")
        imageView.image = UIImage(named: "doubleTapFig")
        label.text = "Double Tap"
        
    }
    
    func onProximityClose(_ sender: Doppler) {
        proxView.image = UIImage(named: "closePhone")

        proxLabel.text = "Close"
    }
    
    func onProximityFar(_ sender: Doppler) {
        proxView.image = UIImage(named: "farPhone")

        proxLabel.text = "Far"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        doppler.stop()
        engine.stop()
    }
    
    
    
}

