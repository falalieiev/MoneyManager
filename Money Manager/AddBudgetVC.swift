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
    let numberPadManager = NumberPadManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = RealmService.shared.realm
        bill = realm.objects(Bill.self)
    }

    @IBAction func numberButtons(_ sender: UIButton) {
        numberPadManager.numbers(budgetLabel, sender)
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        numberPadManager.remove(budgetLabel, sender)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let budgetString = budgetLabel.text!
        budgetNew = Float(budgetString) ?? 0.0
        
        let newBill = Bill(billNew, currencyNew, budgetNew)
        RealmService.shared.create(newBill)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}
