//
//  AddBillVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 26.11.2021.
//

import UIKit

class AddBillVC: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    var billName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        if textField.text!.isEmpty{
            nextButton.isUserInteractionEnabled = false
            nextButton.alpha = 0.5
            }
    }

    @IBAction func toCurrencyChoice(_ sender: UIButton) {
        if billName != "" {
        performSegue(withIdentifier: "addCurrency", sender: sender)
        }
    }
}

extension AddBillVC: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.text != "" {
            billName = textField.text!
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)

            if !text.isEmpty{
                nextButton.isUserInteractionEnabled = true
                nextButton.alpha = 1
            } else {
                nextButton.isUserInteractionEnabled = false
                nextButton.alpha = 0.5
            }
            return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddCurrencyVC
        destinationVC.billName = billName
    }
}
