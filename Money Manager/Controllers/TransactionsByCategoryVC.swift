//
//  TransactionsByCategoryVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 02.12.2021.
//

import UIKit
import RealmSwift

class TransactionsByCategoryVC: UITableViewController {
    
    var operations: Results<Transaction>!
    var transactionForEdit: Transaction!
    var billSymbol = ""
    let colors = Colors()
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.title = operations.first?.value(forKey: "category") as? String
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if operations.count == 0 {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditTransactionVC
        destinationVC.transactionForEdit = transactionForEdit
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "operations", for: indexPath) as! TransactionCell
        var value = operations.sorted(byKeyPath: "creationDate", ascending: false)[indexPath.row].value
        cell.transactionName.text = operations.sorted(byKeyPath: "creationDate", ascending: false)[indexPath.row].category
        cell.transactionValue.text = value.floatToString() + billSymbol
        cell.transactionColor.textColor = colors.colors[indexPath.row % colors.colors.count]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transactionForEdit = operations.sorted(byKeyPath: "creationDate", ascending: false)[indexPath.row]
        performSegue(withIdentifier: "editTransaction", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trashAction = UIContextualAction(style: .destructive, title:  "Trash", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            RealmService.shared.delete(self.operations.sorted(byKeyPath: "creationDate", ascending: false)[indexPath.row])
            tableView.reloadData()
            success(true)
        })
        trashAction.backgroundColor = .red
        trashAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [trashAction])
    }
}
