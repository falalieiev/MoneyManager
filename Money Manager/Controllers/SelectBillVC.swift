//
//  SelectBillVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 27.11.2021.
//

import UIKit
import RealmSwift

protocol MainVCDelegate {
    func updateBillIndex(_ billIndex: Int)
}

class SelectBillVC: UITableViewController {
    
    var delegate: MainVCDelegate?
    var transactionObject: List<Transaction>!
    var bill: Results<Bill>!
    var billIndexPassed: Int?
    var sum1: Float = 0.0
    var billForEdit: Bill!
    let colors = Colors()
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = RealmService.shared.realm
        bill = realm.objects(Bill.self)
        
        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.tableFooterView = UIView(frame: frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Bill Selected
    
    @IBAction func addBillPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addFromBills", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editBill" {
            let destinationVC = segue.destination as! EditBillVC
            destinationVC.billForEdit = billForEdit
        }
    }
    
    // MARK: - TableView
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bill.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath) as! BillCell
        transactionObject = bill[indexPath.row].transaction
        sum1 = RealmService.shared.sumOfAllTransactions(object: transactionObject)
        cell.configureBill(with: bill[indexPath.row], sum: sum1, colors.colors[indexPath.row % colors.colors.count])
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
            self.billForEdit = self.bill[indexPath.row]
            self.performSegue(withIdentifier: "editBill", sender: self)
            success(true)
        })
        editAction.backgroundColor = .gray
        editAction.image = UIImage(systemName: "square.and.pencil")
        
        return UISwipeActionsConfiguration(actions: [trashAction, editAction])
    }
    
}
