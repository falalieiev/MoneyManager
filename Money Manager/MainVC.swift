//
//  ViewController.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 26.11.2021.
//

import UIKit
import RealmSwift

class MainVC: UIViewController, MainVCDelegate {
    
    @IBOutlet weak var billView: UIStackView!
    @IBOutlet weak var billImage: UIImageView!
    @IBOutlet weak var billName: UILabel!
    @IBOutlet weak var billValue: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    
    var bill: Results<Bill>!
    var transactionObject: List<Transaction>!
    var billIndex: Int?
    var sumOfIncome: Float = 0.0
    var sumOfExpenses: Float = 0.0
    var billValue1: Float = 0.0
    var billSymbol = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(billTapped))
        billView.addGestureRecognizer(gesture)
        
        let realm = RealmService.shared.realm
        bill = realm.objects(Bill.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if bill.count != 0 {
            billIndex = 0
        }
        
        loadTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if bill.isEmpty == false {
            loadTransactions()
            configureBill(with: bill[billIndex ?? 0])
            loadTransactions()
        }
    }
    
    @objc func billTapped(sender : UITapGestureRecognizer) {
        if bill.count == 0 {
            performSegue(withIdentifier: "addBill", sender: sender)
        } else {
            performSegue(withIdentifier: "toBillSelection", sender: sender)
        }
    }
    
    func configureBill(with bill: Bill) {
        billImage.image = UIImage(systemName: "creditcard")
        billName.text = bill.name
        billValue.text = String(bill.budget + billValue1) + bill.currency
        billSymbol = bill.currency
    }
    
    func updateBillIndex(_ billIndexPassed: Int) {
        billIndex = billIndexPassed
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBillSelection" {
            guard let destination = segue.destination as? SelectBillTBC else { return }
            destination.delegate = self
        } else if segue.identifier == "addTransaction" {
            let destinationAddTransaction = segue.destination as! AddTransactionVC
            destinationAddTransaction.currentBill = bill[billIndex ?? 0]
        }
    }
    
    @IBAction func addTransactionPressed(_ sender: UIBarButtonItem) {
        if bill.count == 0 {
            performSegue(withIdentifier: "addBill", sender: sender)
        } else {
            performSegue(withIdentifier: "addTransaction", sender: sender)
        }
    }
    
    func loadTransactions() {
        if billIndex != nil {
            transactionObject = bill[billIndex ?? 0].transaction
            sumOfIncome = RealmService.shared.sumOfIncome(object: transactionObject)
            sumOfExpenses = RealmService.shared.sumOfExpenses(object: transactionObject)
            expensesLabel.text = sumOfExpenses.floatToString(sumOfExpenses) + billSymbol
            incomeLabel.text = sumOfIncome.floatToString(sumOfIncome) + billSymbol

            billValue1 = sumOfIncome - sumOfExpenses
            tableView.reloadData()
        }
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! TransactionCell
        
        print(currentCell.transactionName.text ?? "null")    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transaction", for: indexPath) as! TransactionCell
        if let transaction = transactionObject?[indexPath.row] {
            cell.transactionName.text = transaction.category
            cell.transactionValue.text = String(transaction.value) + billSymbol
            if transaction.transactionType == 0 {
                cell.transactionType.tintColor = .red
                cell.transactionType.image = UIImage(systemName: "arrow.down")
            } else {
                cell.transactionType.tintColor = #colorLiteral(red: 0.2045667768, green: 0.7816080451, blue: 0.3486227691, alpha: 1)
                cell.transactionType.image = UIImage(systemName: "arrow.up")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if billIndex != nil {
            return bill[billIndex ?? 0].transaction.count
        }
        return 0
    }
}

