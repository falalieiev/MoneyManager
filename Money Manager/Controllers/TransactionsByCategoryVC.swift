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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = operations.first?.value(forKey: "category") as? String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        cell.transactionName.text = operations[indexPath.row].category
        cell.transactionValue.text = String(operations[indexPath.row].value)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
