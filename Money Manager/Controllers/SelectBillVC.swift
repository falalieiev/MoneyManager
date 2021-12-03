//
//  SelectBillVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 27.11.2021.
//

import UIKit
import RealmSwift

protocol MainVCDelegate: AnyObject {
    func updateBillIndex(_ billIndex: Int)
}

class SelectBillVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = RealmService.shared.realm
        bill = realm.objects(Bill.self)
    }
    
    weak var delegate: MainVCDelegate?
    var transactionObject: List<Transaction>!
    var bill: Results<Bill>!
    var billIndexPassed: Int?
    var sum1: Float = 0.0
    var billName = ""
    var billCurrency = ""
    var billValue: Float = 0.0
    
    @IBAction func addBillPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addFromBills", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditBillVC
        destinationVC.currency = billCurrency
        destinationVC.name = billName
        destinationVC.capital = billValue
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bill.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath) as! BillCell
        transactionObject = bill[indexPath.row].transaction
        sum1 = RealmService.shared.sumOfAllTransactions(object: transactionObject)
        cell.configureBill(with: bill[indexPath.row], sum: sum1)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        delegate?.updateBillIndex(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trashAction = UIContextualAction(style: .destructive, title:  "Trash", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            RealmService.shared.deleteAll(self.bill[indexPath.row], transaction: self.transactionObject)
            self.delegate?.updateBillIndex(0)
            self.tableView.reloadData()
            success(true)
        })
        trashAction.backgroundColor = .red
        trashAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .normal, title:  "More", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.billValue = self.bill[indexPath.row].budget
            self.billName = self.bill[indexPath.row].name
            self.billCurrency = self.bill[indexPath.row].currency
            self.performSegue(withIdentifier: "editBill", sender: self)
            success(true)
        })
        editAction.backgroundColor = .gray
        editAction.image = UIImage(systemName: "square.and.pencil")
        
        return UISwipeActionsConfiguration(actions: [trashAction, editAction])
    }
    
}