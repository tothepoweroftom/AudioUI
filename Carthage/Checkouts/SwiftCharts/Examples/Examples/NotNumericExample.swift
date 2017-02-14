//
//  NotNumericExample.swift
//  SwiftCharts
//
//  Created by ischuetz on 04/05/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit
import SwiftCharts

class NotNumericExample: UIViewController {

    fileprivate var chart: Chart? // arc

    override func viewDidLoad() {
        super.viewDidLoad()

        let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)

        let quantityVeryLow = MyQuantity(number: 0, text: "Very low")
        let quantityLow = MyQuantity(number: 1, text: "low")
        let quantityAverage = MyQuantity(number: 2, text: "Average")
        let quantityHigh = MyQuantity(number: 3, text: "High")
        let quantityVeryHigh = MyQuantity(number: 4, text: "Very high")
        
        
        let item0 = MyItem(name: "Fruits", quantity: quantityHigh)
        let item1 = MyItem(name: "Vegetables", quantity: quantityVeryHigh)
        let item2 = MyItem(name: "Fish", quantity: quantityAverage)
        let item3 = MyItem(name: "Red meat", quantity: quantityAverage)
        let item4 = MyItem(name: "Cereals", quantity: quantityLow)
        
        
        let chartPoints: [ChartPoint] = [item0, item1, item2, item3, item4].enumerated().map {index, item in
            let xLabelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont, rotation: 45, rotationKeep: .top)
            let x = ChartAxisValueString(item.name, order: index, labelSettings: xLabelSettings)
            let y = ChartAxisValueString(item.quantity.text, order: item.quantity.number, labelSettings: labelSettings)
            return ChartPoint(x: x, y: y)
        }
        
        let xValues = [ChartAxisValueString("", order: -1)] + chartPoints.map{$0.x} + [ChartAxisValueString("", order: 5)]
        
        func toYValue(_ quantity: MyQuantity) -> ChartAxisValue {
            return ChartAxisValueString(quantity.text, order: quantity.number, labelSettings: labelSettings)
        }
        
        let yValues = [toYValue(quantityVeryLow), toYValue(quantityLow), toYValue(quantityAverage), toYValue(quantityHigh), toYValue(quantityVeryHigh)]
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Axis title", settings: labelSettings.defaultVertical()))
        let chartFrame = ExamplesDefaults.chartFrame(self.view.bounds)
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: ExamplesDefaults.chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let minBarSpacing: CGFloat = ExamplesDefaults.minBarSpacing + 16

        let generator = {(chartPointModel: ChartPointLayerModel, layer: ChartPointsLayer, chart: Chart) -> UIView? in
            let bottomLeft = CGPoint(x: layer.innerFrame.origin.x, y: layer.innerFrame.origin.y + layer.innerFrame.height)
            
            let barWidth = layer.minXScreenSpace - minBarSpacing
            
            let (p1, p2): (CGPoint, CGPoint) = (CGPoint(x: chartPointModel.screenLoc.x, y: bottomLeft.y), CGPoint(x: chartPointModel.screenLoc.x, y: chartPointModel.screenLoc.y))
            return ChartPointViewBar(p1: p1, p2: p2, width: barWidth, bgColor: UIColor.blue.withAlphaComponent(0.6))
        }
        
        let chartPointsLayer = ChartPointsViewsLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints, viewGenerator: generator)
        
        let settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.black, linesWidth: ExamplesDefaults.guidelinesWidth)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        let dividersSettings =  ChartDividersLayerSettings(linesColor: UIColor.black, linesWidth: Env.iPad ? 1 : 0.2, start: Env.iPad ? 7 : 3, end: 0, onlyVisibleValues: true)
        let dividersLayer = ChartDividersLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: dividersSettings)
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                dividersLayer,
                chartPointsLayer
            ]
        )
        
        self.view.addSubview(chart.view)
        self.chart = chart
    }
}


private struct MyQuantity {
    let number: Int
    let text: String
    
    init(number: Int, text: String) {
        self.number = number
        self.text = text
    }
}

private struct MyItem {
    let name: String
    let quantity: MyQuantity
    
    init(name: String, quantity: MyQuantity) {
        self.name = name
        self.quantity = quantity
    }
}
