//
//  AddTransactionVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 27.11.2021.
//

import UIKit
import RealmSwift

class AddTransactionVC: UIViewController {

    @IBOutlet weak var segmentPicker: UISegmentedControl!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var valueLabel: UILabel!
    
    let numberPadManager = NumberPadManager()
    var transaction: Results<Transaction>!
    var currentBill: Bill?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextField.delegate = self

        let realm = RealmService.shared.realm
        transaction = realm.objects(Transaction.self)
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        let valueString = valueLabel.text!
        let newValue = Float(valueString) ?? 0.0
        
        let newTransaction = Transaction(value: newValue, note: notesTextField.text, transactionType: segmentPicker.selectedSegmentIndex, creationDate: Date())
        RealmService.shared.append(newTransaction, currentBill!)
    }
    
    @IBAction func numberButtons(_ sender: UIButton) {
        numberPadManager.numbers(valueLabel, sender)
    }
    
    @IBAction func removeButtonPressed(_ sender: UIButton) {
        numberPadManager.remove(valueLabel, sender)
    }
}

extension AddTransactionVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        notesTextField.resignFirstResponder()
        return true 
    }
}
