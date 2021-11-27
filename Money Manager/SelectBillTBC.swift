//
//  SelectBillTBC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 27.11.2021.
//

import UIKit
import RealmSwift

protocol MainVCDelegate: AnyObject {
    func updateBillIndex(_ billIndex: Int)
}

class SelectBillTBC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = RealmService.shared.realm
        bill = realm.objects(Bill.self)
    }
    
    weak var delegate: MainVCDelegate?
    var bill: Results<Bill>!
    var billIndexPassed: Int?

    @IBAction func addBillPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addFromBills", sender: sender)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bill.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath) as! BillCell
        cell.configureBill(with: bill[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.popViewController(animated: true)
        delegate?.updateBillIndex(indexPath.row)
    }

}
