//
//  EditBillVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 03.12.2021.
//

import UIKit
import RealmSwift

class EditBillVC: UITableViewController, SearchCurrencyDelegate {
    
    @IBOutlet var numberPadView: UIView!
    @IBOutlet weak var billCapital: UILabel!
    @IBOutlet weak var billCurrency: UILabel!
    @IBOutlet weak var billName: UILabel!
    
    var billForEdit: Bill!
    var dic: [String: Any?] = ["name": Any?.self]
    let currency = CurrencyModel()
    let numberPadManager = NumberPadManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        billCapital.text = String(billForEdit.budget)
        billName.text = billForEdit.name
        billCurrency.text = billForEdit.currency
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.view.addSubview(numberPadView)
        numberPadView.frame = CGRect(x: 0,
                                     y: self.view.bounds.size.height - (numberPadView.bounds.size.height + 40),
                                    width: self.view.bounds.size.width,
                                    height: numberPadView.bounds.size.height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        numberPadView.removeFromSuperview()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            numberPadView.isHidden = true
            var textField = UITextField()
            let alert = UIAlertController(title: "Новое название", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Изменить", style: .default) { (action) in
                self.billName.text = textField.text
            }
            alert.addAction(action)
            alert.addTextField { (field) in
                textField = field
                textField.placeholder = "Введите название"
            }
            present(alert, animated: true, completion: nil)
        }
        
        if indexPath.row == 1 {
            numberPadView.isHidden = true
           performSegue(withIdentifier: "editCurrency", sender: self)
        }
        
        if indexPath.row == 2 {
            if numberPadView.isHidden {
            numberPadView.isHidden = false
            }
            let currentCell = tableView.cellForRow(at: indexPath)
            currentCell?.isSelected = false
        }
    }
    
    func getCurrency(_ currencyIndexPassed: Int) {
        billCurrency.text = currency.currencyArray[currencyIndexPassed]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCurrency" {
            let currencyVC = segue.destination as! CurrencySearchVC
            currencyVC.delegate = self
        }
    }
    
    @IBAction func numbers(_ sender: UIButton) {
        numberPadManager.numbers(billCapital, sender)
    }
    
    @IBAction func deleteNumber(_ sender: UIButton) {
        numberPadManager.remove(billCapital, sender)
    }
    
    @IBAction func updateBillPressed(_ sender: UIBarButtonItem) {
        let dict: [String: Any?] = ["name": billName.text,
                                    "currency": billCurrency.text,
                                    "budget": Float(billCapital.text ?? "0.0")]
        RealmService.shared.update(billForEdit, with: dict)
    }
}
