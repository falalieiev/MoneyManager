//
//  Extensions.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 29.11.2021.
//

import Foundation
import Charts

extension Float {
    mutating func floatToString() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = ""
        let formattedNumber = numberFormatter.string(from: NSNumber(value: self))!
        return formattedNumber
    }
}

extension HorizontalBarChartView {
    func chartSetting(_ chartView: HorizontalBarChartView) {
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        xAxis.granularity = 20

        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0

        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0

        
        chartView.legend.enabled = false
        chartView.extraBottomOffset = 5.0
        chartView.isUserInteractionEnabled = false
        chartView.fitBars = true
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.locale = Locale(identifier: "ru_RU")
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
