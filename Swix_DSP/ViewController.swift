//
//  ViewController.swift
//  Swix_DSP
//
//  Created by Tom Power on 09/02/2017.
//  Copyright © 2017 MOBGEN:Lab. All rights reserved.
//

import UIKit
import Charts


class ViewController: UIViewController {
    
    var engine: AudioEngine!
    
    
    
    @IBOutlet weak var barChartView: BarChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        engine = AudioEngine()
        engine.start()
        

        engine.sineWave.play()

        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func update() {
//        print(engine.fftMagnitudes)
        
        if (engine.fftMagnitudes != nil) {
        var dataEntries: [BarChartDataEntry] = []
            
        var index = freqToIndex(21000, fftSize: N, sampleRate: 44100.0)

        for i in index-300..<index {
            let dataEntry = BarChartDataEntry(x: Double(i), y: engine.fftMagnitudes[i])
            dataEntries.append(dataEntry)
            
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "FFT Mags")
            chartDataSet.colors = [UIColor.red]
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    



}

