//
//  NumberPadManager.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 27.11.2021.
//

import UIKit

class NumberPadManager {
    
    func numbers(_ label: UILabel, _ sender: UIButton) {
        var numValue = sender.currentTitle!
        
        if label.text!.contains(".") && numValue == "." {
            numValue = ""
        } else if label.text == "0" && numValue == "." {
            label.text = "0"
        } else if label.text == "0" {
            label.text = ""
        }
        
        if (label.text?.contains("."))! {
            let limitDecimalPlace = 2
            let decimalPlace = label.text?.components(separatedBy: ".").last
            if (decimalPlace?.count)! < limitDecimalPlace {
                
            } else {
                numValue = ""
            }
        }
        
        label.text! += numValue
    }
    
    func remove(_ label: UILabel, _ sender: UIButton) {
        if label.text!.count > 1 {
            label.text?.removeLast()
        } else {
            label.text = "0"
        }
    }
}
