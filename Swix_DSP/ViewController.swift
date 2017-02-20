//
//  ViewController.swift
//  Swix_DSP
//
//  Created by Tom Power on 09/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import UIKit
import Charts


class ViewController: UIViewController, DopplerDelegate {
    
    var engine: AudioEngine!
    var doppler: Doppler!
    
    
    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var proxView: UIImageView!
    @IBOutlet weak var label: UILabel!
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
        var dataEntries: [BarChartDataEntry] = []
            
        var index = freqToIndex(22000, fftSize: N, sampleRate: 44100.0)

        for i in index-300..<index {
            let dataEntry = BarChartDataEntry(x: Double(i), y: engine.fftMagnitudes[i])
            dataEntries.append(dataEntry)
            
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "FFT Mags")
            chartDataSet.colors = [UIColor.red]
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        
        var fftData = [Double]()
        for var i in 0..<engine.fftMagnitudes.n {
            fftData.append(engine.fftMagnitudes[i])
        }
        doppler.update(fftData: fftData)
        doppler.proxUpdate()

        }
    }
    
    func proxUpdate(){
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
    
    func onPull(_ sender: Doppler) {
//        print("Pull")
        imageView.image = UIImage(named: "right-arrow")
        self.label.text = "Pulled"
    }
    
    func onPush(_ sender: Doppler) {
//        print("Push")
        imageView.image = UIImage(named: "leftArrow")
        self.label.text = "Pushed"
    }
    
    func onNothing(_ sender: Doppler) {
//        print(" ")
        imageView.image = UIImage(named: "ear")
        label.text = "I'm listening for gestures..."

    }
    
    func onDoubleTap(_ sender: Doppler) {
//        print("Double Tap")
        imageView.image = UIImage(named: "circle")
        label.text = "Double Tapped"

    }

    func onProximityClose(_ sender: Doppler) {
        proxView.image = UIImage(named: "heavy-metal")
    }

    func onProximityFar(_ sender: Doppler) {
        proxView.image = UIImage(named: "hills")
    }
    



}

