//
//  ChartViewController.swift
//  Swix_DSP
//
//  Created by Tom Power on 22/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import UIKit
import Charts

class BarViewController: UIViewController, DopplerDelegate {

        
        var engine: AudioEngine!
        var doppler: Doppler!
    
        
        

    @IBOutlet var barChartView: BarChartView!
        
        
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            engine = AudioEngine()
            engine.start()
            engine.sineWave.play()
            
            
            doppler = Doppler(frequency: engine.sineWave.frequency)
            
            doppler.delegate = self
            doppler.start()
            barChartView.tintColor = UIColor.white
            barChartView.backgroundColor = UIColor.black
            Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            
        }
        
        func update() {
            //        print(engine.fftMagnitudes)
            //
            if (engine.fftMagnitudes != nil) {
                        var dataEntries: [BarChartDataEntry] = []
                
                        var index = freqToIndex(22000, fftSize: N, sampleRate: 44100.0)
                
                        for i in index-500..<index {
                            
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
                
            }
        }

    @IBAction func changeMagnitudes(_ sender: Any) {
        
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

        }
        
        func onSlowPull(_ sender: Doppler) {

            
        }
        
        func onSlowPush(_ sender: Doppler) {

            
        }
        
        func onFastPull(_ sender: Doppler) {

            
        }
        
        func onFastPush(_ sender: Doppler) {

            
        }
        
        func onNothing(_ sender: Doppler) {

            
        }
        
        func onDoubleTap(_ sender: Doppler) {

            
        }
        
        func onProximityClose(_ sender: Doppler) {

        }
        
        func onProximityFar(_ sender: Doppler) {
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            doppler.stop()
            engine.stop()
        }
        
        
        
}

