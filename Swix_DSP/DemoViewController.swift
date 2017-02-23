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
        imageView.image = UIImage(named: "checked")
        self.label.text = "Tapped"
    }
    
    func onSlowPull(_ sender: Doppler) {
        //        print("Pull")
        imageView.image = UIImage(named: "right-arrow")
        speedView.image = UIImage(named: "slow")
        
        self.label.text = "Pulled"
        self.speedLabel.text = "Slow"
        
    }
    
    func onSlowPush(_ sender: Doppler) {
        //        print("Push")
        imageView.image = UIImage(named: "leftArrow")
        speedView.image = UIImage(named: "slow")
        
        self.label.text = "Pushed"
        self.speedLabel.text = "Slow"
        
    }
    
    func onFastPull(_ sender: Doppler) {
        //        print("Pull")
        imageView.image = UIImage(named: "right-arrow")
        speedView.image = UIImage(named: "fast")
        
        self.label.text = "Pulled"
        self.speedLabel.text = "Fast"
        
    }
    
    func onFastPush(_ sender: Doppler) {
        //        print("Push")
        imageView.image = UIImage(named: "leftArrow")
        speedView.image = UIImage(named: "fast")
        
        self.label.text = "Pushed"
        self.speedLabel.text = "Fast"
        
    }
    
    func onNothing(_ sender: Doppler) {
        //        print(" ")
        imageView.image = UIImage(named: "ear")
        label.text = "I'm listening for gestures..."
        //        speedView.image = UIImage(named: "ear")
        proxLabel.text = "..."
        speedLabel.text = "..."
        
    }
    
    func onDoubleTap(_ sender: Doppler) {
        //        print("Double Tap")
        imageView.image = UIImage(named: "circle")
        label.text = "Double Tapped"
        
    }
    
    func onProximityClose(_ sender: Doppler) {
        proxView.image = UIImage(named: "heavy-metal")
        proxLabel.text = "Close"
    }
    
    func onProximityFar(_ sender: Doppler) {
        proxView.image = UIImage(named: "hills")
        proxLabel.text = "Far"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        doppler.stop()
        engine.stop()
    }
    
    
    
}

