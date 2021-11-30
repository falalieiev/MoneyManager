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
    @IBOutlet weak var categoriesCollection: UICollectionView!
    
    let numberPadManager = NumberPadManager()
    var transaction: Results<Transaction>!
    var currentBill: Bill?
    var categoryName = ""
    
    var categoryArray = ["+ Добавить", "Развлечения", "Долги", "Автомобиль", "Ребёнок", "Музыка", "Кредит", "Транспорт"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextField.delegate = self
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
        
        let realm = RealmService.shared.realm
        transaction = realm.objects(Transaction.self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let valueString = valueLabel.text!
        let newValue = Float(valueString) ?? 0.0
        
        let newTransaction = Transaction(value: newValue, note: notesTextField.text, transactionType: segmentPicker.selectedSegmentIndex, creationDate: Date(), category: categoryName)
        RealmService.shared.append(newTransaction, currentBill!)
        navigationController?.popToRootViewController(animated: true)
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

extension AddTransactionVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = #colorLiteral(red: 1, green: 0.8032061458, blue: 0.2743474245, alpha: 1)
        cell?.layer.borderWidth = 2
        cell?.layer.cornerRadius = 10
        cell?.isSelected = true
        categoryName = categoryArray[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.isSelected = false
    }
}

extension AddTransactionVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollection.dequeueReusableCell(withReuseIdentifier: "categories", for: indexPath) as! CategoryCell
        cell.nameOfCategory.text = categoryArray[indexPath.row]
        return cell
    }
}

extension AddBillVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 25)
    }
}
