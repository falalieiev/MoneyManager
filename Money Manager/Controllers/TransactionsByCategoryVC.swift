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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = operations.first?.value(forKey: "category") as? String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "operations", for: indexPath) as! TransactionCell
        cell.transactionName.text = operations.sorted(byKeyPath: "creationDate", ascending: false)[indexPath.row].category
        cell.transactionValue.text = String(operations.sorted(byKeyPath: "creationDate", ascending: false)[indexPath.row].value)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        transactionForEdit = operations.sorted(byKeyPath: "creationDate", ascending: false)[indexPath.row]
        performSegue(withIdentifier: "editTransaction", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditTransactionVC
        destinationVC.transactionForEdit = transactionForEdit
        //destinationVC.barItem.title = ""
        //destinationVC.title = ""
    }
}
