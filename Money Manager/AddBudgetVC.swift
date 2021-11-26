//
//  AddBudgetVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 26.11.2021.
//

import UIKit
import RealmSwift

class AddBudgetVC: UIViewController {
    
    @IBOutlet weak var budgetLabel: UILabel!
    
    var bill: Results<Bill>!
    var billNew = ""
    var currencyNew = ""
    var budgetNew: Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(billNew)
        let realm = RealmService.shared.realm
        bill = realm.objects(Bill.self)
    }

    @IBAction func numberButtons(_ sender: UIButton) {
        var numValue = sender.currentTitle!
        
        if budgetLabel.text!.contains(".") && numValue == "." {
            numValue = ""
        } else if budgetLabel.text == "0" && numValue == "." {
            budgetLabel.text = "0"
        } else if budgetLabel.text == "0" {
            budgetLabel.text = ""
        }
        
        if (budgetLabel.text?.contains("."))! {
            let limitDecimalPlace = 2
            let decimalPlace = budgetLabel.text?.components(separatedBy: ".").last
            if (decimalPlace?.count)! < limitDecimalPlace {
                
            } else {
                numValue = ""
            }
        }
        
        budgetLabel.text! += numValue
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        if budgetLabel.text!.count > 1 {
            budgetLabel.text?.removeLast()
        } else {
            budgetLabel.text = "0"
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let budgetString = budgetLabel.text!
        budgetNew = Float(budgetString) ?? 0.0
        
        let newBill = Bill(billNew, currencyNew, budgetNew)
        RealmService.shared.create(newBill)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}
