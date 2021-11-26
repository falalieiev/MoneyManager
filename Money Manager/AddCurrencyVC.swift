//
//  AddCurrencyVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 26.11.2021.
//

import UIKit

class AddCurrencyVC: UIViewController {
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        currencyPicker.selectRow(6, inComponent: 0, animated: false)
        pickerView(currencyPicker, didSelectRow: 6, inComponent: 0)
    }
    
    var currencySymbol = ""
    var billName = ""
    let currencyArray = ["(AED) United Arab Emirates dirham - د.إ",
                         "(AFN) Afghan afghani - ؋",
                         "(ALL) Albanian lek - L",
                         "(AMD) Armenian dram - դր.",
                         "(ANG) Netherlands Antillean guilder - ƒ",
                         "(AOA) Angolan kwanza - Kz",
                         "(ARS) Argentine peso - $",
                         "(AUD) Australian dollar - $",
                         "(AWG) Aruban florin - ƒ",
                         "(AZN) Azerbaijani manat - m"]
    
    @IBAction func toBudget(_ sender: UIButton) {
        performSegue(withIdentifier: "addBudget", sender: sender)
    }
}

extension AddCurrencyVC: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
          if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 20.0)
            pickerLabel?.textAlignment = .left
          }
          pickerLabel?.text = currencyArray[row]
          return pickerLabel!
    }
}

extension AddCurrencyVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencySymbol = currencyArray[row].components(separatedBy: "- ")[1]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AddBudgetVC
        destinationVC.currencyNew = currencySymbol
        destinationVC.billNew = billName
    }
}
