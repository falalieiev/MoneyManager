//
//  EditTransactionVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 06.12.2021.
//

import UIKit
import RealmSwift

class EditTransactionVC: UITableViewController, CategoriesDelegate {
    
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet var numberPadView: UIView!
    @IBOutlet weak var cell1: UITableViewCell!
    @IBOutlet weak var cell2: UITableViewCell!
    @IBOutlet weak var cell3: UITableViewCell!
    @IBOutlet weak var barItem: UIBarButtonItem!
    
    var transactionForEdit: Transaction!
    let numberPadManager = NumberPadManager()
    var categoryInfo: Category?
    let empty = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if transactionForEdit.note == "" {
            note.text = "-"
        } else {
            note.text = transactionForEdit.note
        }
        value.text = String(transactionForEdit.value)
        categoryLabel.text = transactionForEdit.category
        tableView.allowsSelection = false
        
        tableView.sectionHeaderHeight = 1
        tableView.sectionFooterHeight = 1
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
    
    @IBAction func removeButton(_ sender: UIButton) {
        numberPadManager.remove(value, sender)
    }
    @IBAction func numbers(_ sender: UIButton) {
        numberPadManager.numbers(value, sender)
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)
        
        if indexPath.row == 0 {
            numberPadView.isHidden = true
            currentCell?.isSelected = false
            performSegue(withIdentifier: "categories", sender: self)
        }
        
        if indexPath.row == 1 {
            if numberPadView.isHidden {
                numberPadView.isHidden = false
            } else {
                numberPadView.isHidden = true
            }
            currentCell?.isSelected = false
        }
        
        if indexPath.row == 2 {
            numberPadView.isHidden = true
            currentCell?.isSelected = false
            var textField = UITextField()
            textField.autocapitalizationType = .sentences
            let alert = UIAlertController(title: "Заметка", message: "", preferredStyle: .alert)
            let change = UIAlertAction(title: "Изменить", style: .default) { (change) in
                self.note.text = textField.text
            }
            let cancel = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            alert.addAction(change)
            alert.addTextField { (field) in
                textField = field
                textField.placeholder = "Заметка"
            }
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categories" {
            let destinationVC = segue.destination as! CategoryVC
            destinationVC.delegate = self
        }
    }
    
    func getCategoryInfo(category: Category) {
        categoryInfo = category
        categoryLabel.text = category.name
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        if sender.title == "Ред." {
            sender.title = "Сохранить"
            cell1.accessoryType = .disclosureIndicator
            cell2.accessoryType = .disclosureIndicator
            cell3.accessoryType = .disclosureIndicator
            tableView.allowsSelection = true
        }
        
        else {
            let dict: [String: Any?] = ["value": Float(value.text ?? "0.0"),
                                        "note": note.text,
                                        "transactionType": categoryInfo?.type ?? transactionForEdit.transactionType,
                                        "category": categoryInfo?.name ?? transactionForEdit.category]
            RealmService.shared.update(transactionForEdit, with: dict)
            cell1.accessoryType = .none
            cell2.accessoryType = .none
            cell3.accessoryType = .none
            tableView.allowsSelection = false
            //sender.title = "Ред."
            //tableView.reloadData()
            navigationController?.popViewController(animated: true)
        }
    }
}
