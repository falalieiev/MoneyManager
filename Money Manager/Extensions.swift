//
//  Extensions.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 29.11.2021.
//

import Foundation

extension Float {
    mutating func floatToString(_ number: Float) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = ""
        let formattedNumber = numberFormatter.string(from: NSNumber(value: number))!
        return formattedNumber
    }
}

