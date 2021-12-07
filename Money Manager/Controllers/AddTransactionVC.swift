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
    //var transaction: Results<Transaction>!
    var currentBill: Bill?
    var categoryName = ""
    var textField = UITextField()
    var categories: Results<Category>!
    var categoriesSum: Int = 0
    var notificationToken: NotificationToken?
    var indexPathsForSelectedItems: [IndexPath]?
    
    var categoryArray = ["+ Добавить", "Развлечения", "Долги", "Автомобиль", "Ребёнок", "Музыка", "Кредит", "Транспорт"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextField.delegate = self
        categoriesCollection.delegate = self
        categoriesCollection.dataSource = self
       
        let realm = RealmService.shared.realm
        categories = realm.objects(Category.self)
        
        notificationToken = realm.observe({ notification, realm in
            self.categoriesCollection.reloadData()
        })
    }
    override func viewWillDisappear(_ animated: Bool) {
        notificationToken?.invalidate()
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if categoryName == "" {
            print("u must select category")
        } else {
        let valueString = valueLabel.text!
        let newValue = Float(valueString) ?? 0.0
        let newTransaction = Transaction(value: newValue, note: notesTextField.text, transactionType: segmentPicker.selectedSegmentIndex, creationDate: Date(), category: categoryName)
        RealmService.shared.append(newTransaction, currentBill!)
        navigationController?.popToRootViewController(animated: true)
        }
    }
    @IBAction func typeChanged(_ sender: UISegmentedControl) {
        categoriesCollection.reloadData()
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
        
        if indexPath.row == categoriesSum - 1 {
            var textField = UITextField()
            let alert = UIAlertController(title: "Новая категория", message: "", preferredStyle: .alert)
            let change = UIAlertAction(title: "Добавить", style: .default) { (change) in
                let newCategory = Category(textField.text!, self.segmentPicker.selectedSegmentIndex)
                RealmService.shared.create(newCategory)
            }
            let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            alert.addAction(change)
            change.isEnabled = false
            
            alert.addTextField { (field) in
                textField = field
                textField.autocapitalizationType = .sentences
                textField.placeholder = "Введите название"
                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                                                        {_ in
                    let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                    let textIsNotEmpty = textCount > 0
                    
                    change.isEnabled = textIsNotEmpty
                }) }
            
            present(alert, animated: true, completion: nil)
        } else {
            cell?.layer.borderColor = #colorLiteral(red: 1, green: 0.8032061458, blue: 0.2743474245, alpha: 1)
            cell?.layer.borderWidth = 2
            cell?.layer.cornerRadius = 10
            cell?.isSelected = true
            categoryName = categories.filter("type == %@", segmentPicker.selectedSegmentIndex)[indexPath.row].name
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.isSelected = false
    }
}

extension AddTransactionVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentPicker.selectedSegmentIndex == 0 {
            categoriesSum = categories.filter("type == %@", 0).count + 1
            return categoriesSum
        } else {
            categoriesSum = categories.filter("type == %@", 1).count + 1
            return categoriesSum
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollection.dequeueReusableCell(withReuseIdentifier: "categories", for: indexPath) as! CategoryCell
        
        if segmentPicker.selectedSegmentIndex == 0 {
            if indexPath.row == categoriesSum - 1 {
                cell.nameOfCategory.text = "+ Добавить"
            } else {
                cell.nameOfCategory.text = categories.filter("type == %@", 0)[indexPath.row].name
            }
        }
        if segmentPicker.selectedSegmentIndex == 1 {
            if indexPath.row == categoriesSum - 1 {
                cell.nameOfCategory.text = "+ Добавить"
            } else {
                cell.nameOfCategory.text = categories.filter("type == %@", 1)[indexPath.row].name
            }
        }
        
        return cell
    }
}

extension AddBillVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 25)
    }
}
