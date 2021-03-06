//
//  AddCurrencyVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 26.11.2021.
//

import UIKit

class AddCurrencyVC: UIViewController {
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var searchButton: UILabel!
    
    let currencyModel = CurrencyModel()
    var currencySymbol = ""
    var billName = ""
    var currencyIndex: Int?
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        currencyPicker.selectRow(142, inComponent: 0, animated: false)
        pickerView(currencyPicker, didSelectRow: 142, inComponent: 0)
        
        searchButton.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(searchPressed))
        searchButton.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currencyIndex != nil {
            currencyPicker.selectRow(currencyIndex!, inComponent: 0, animated: false)
            pickerView(currencyPicker, didSelectRow: currencyIndex!, inComponent: 0)
        }
    }
    
    //MARK: - Buttons
    
    @IBAction func toBudget(_ sender: UIButton) {
        performSegue(withIdentifier: "addBudget", sender: sender)
    }
    
    @objc func searchPressed(sender : UITapGestureRecognizer) {
        performSegue(withIdentifier: "currencySearch", sender: self)
    }
}

    //MARK: - SearchCurrencyDelegate

extension AddCurrencyVC: SearchCurrencyDelegate {
    
    func getCurrency(_ currencyIndexPassed: Int) {
        currencyIndex = currencyIndexPassed
    }
}

    //MARK: - UIPickerView Methods

extension AddCurrencyVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencySymbol = currencyModel.currencyArray[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBudget" {
            let destinationVC = segue.destination as! AddBudgetVC
            destinationVC.currencyNew = currencySymbol
            destinationVC.billNew = billName
            print(destinationVC.currencyNew)
        } else if segue.identifier == "currencySearch" {
            let searchVC = segue.destination as! CurrencySearchVC
            searchVC.delegate = self
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyModel.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 20.0)
            pickerLabel?.textAlignment = .left
        }
        pickerLabel?.text = currencyModel.currencyArray[row]
        return pickerLabel!
    }
}
