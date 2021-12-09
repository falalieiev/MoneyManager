//
//  ViewController.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 26.11.2021.
//

import UIKit
import RealmSwift
import SideMenu

class MainVC: UIViewController, MainVCDelegate {
    
    @IBOutlet weak var billView: UIStackView!
    @IBOutlet weak var billImage: UIImageView!
    @IBOutlet weak var billName: UILabel!
    @IBOutlet weak var billValue: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var summaryView: UIStackView!
    
    var bill: Results<Bill>!
    var transactionObject: List<Transaction>!
    var billIndex: Int?
    var billValueFloat: Float = 0.0
    var billSymbol = ""
    var groupedItems = [Date:Results<Transaction>]()
    var itemDates = [Date]()
    var items: Results<Transaction>?
    var transactionForEdit: Transaction!
    let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(billTapped))
        billView.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(summaryTapped))
        summaryView.addGestureRecognizer(gesture1)
        
        let realm = RealmService.shared.realm
        bill = realm.objects(Bill.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        loadTransactions()
        
        sideMenuSettings()
        
        tableView.sectionFooterHeight = 1
        tableView.sectionHeaderHeight = 29
        
        let formate = Date().getFormattedDate(format: "E, d MMMM")
        self.title = formate
    }
    
    func sideMenuSettings() {
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "sideMenu") as? SideMenuNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view, forMenu: .left)
        var settings = SideMenuSettings()
        settings.presentationStyle = .viewSlideOutMenuIn
        settings.menuWidth = 300
        settings.presentationStyle.presentingEndAlpha = 0.5
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if billIndex == nil {
            billIndex = 0
        }
        
        if bill.isEmpty == false {
            loadTransactions()
            configureBill(with: bill[billIndex ?? 0])
            loadTransactions()
        } else {
            billImage.image = UIImage(systemName: "plus")
            billValue.text = ""
            billName.text = "Добавить счет"
            expensesLabel.text = "0.0$"
            incomeLabel.text = "0.0$"
            itemDates = []
            tableView.reloadData()
        }
    }
    
    @objc func billTapped(sender : UITapGestureRecognizer) {
        if bill.count == 0 {
            performSegue(withIdentifier: "addBill", sender: sender)
        } else {
            performSegue(withIdentifier: "toBillSelection", sender: sender)
        }
    }
    
    @objc func summaryTapped(sender : UITapGestureRecognizer) {
        if bill.count != 0 {
            performSegue(withIdentifier: "transactionObserve", sender: sender)
        }
    }
    
    func configureBill(with bill: Bill) {
        billImage.image = UIImage(systemName: "creditcard")
        billName.text = bill.name
        var billSum = bill.budget + billValueFloat
        billValue.text = billSum.floatToString() + bill.currency.components(separatedBy: "- ")[1]
        billSymbol = bill.currency.components(separatedBy: "- ")[1]
    }
    
    func updateBillIndex(_ billIndexPassed: Int) {
        billIndex = billIndexPassed
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBillSelection" {
            guard let destination = segue.destination as? SelectBillVC else { return }
            destination.delegate = self
        } else if segue.identifier == "addTransaction" {
            let destinationAddTransaction = segue.destination as! AddTransactionVC
            destinationAddTransaction.currentBill = bill[billIndex ?? 0]
        } else if segue.identifier == "transactionObserve" {
            let destinationVC = segue.destination as! TransactionsSummaryVC
            destinationVC.transactionObject = transactionObject
            destinationVC.billSymbol = billSymbol
        } else if segue.identifier == "transactionInfo" {
            let transactionInfo = segue.destination as! EditTransactionVC
            transactionInfo.transactionForEdit = transactionForEdit
        } else if segue.identifier == "sideMenuSettings" {
            let sideMenuNavigationController = segue.destination as? SideMenuNavigationController
            sideMenuNavigationController?.presentationStyle = .viewSlideOutMenuIn
            sideMenuNavigationController?.presentationStyle.presentingEndAlpha = 0.5
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
            
            items = transactionObject?.sorted(byKeyPath: "creationDate", ascending: false)
            
            itemDates = items!.reduce(into: [Date](), { results, currentItem in
                let date = currentItem.creationDate!
                let beginningOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 0, minute: 0, second: 0))!
                let endOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 23, minute: 59, second: 59))!
                
                if !results.contains(where: { addedDate->Bool in
                    return addedDate >= beginningOfDay && addedDate <= endOfDay
                }) {
                    results.append(beginningOfDay)
                }
            })
            
            groupedItems = itemDates.reduce(into: [Date:Results<Transaction>](), { results, date in
                let beginningOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 0, minute: 0, second: 0))!
                let endOfDay = Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: date), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date), hour: 23, minute: 59, second: 59))!
                results[beginningOfDay] = items!.filter("creationDate >= %@ AND creationDate <= %@", beginningOfDay, endOfDay)
            })
            
            var sumOfIncome = RealmService.shared.sumOfIncome(object: transactionObject)
            var sumOfExpenses = RealmService.shared.sumOfExpenses(object: transactionObject)
            expensesLabel.text = "-" + sumOfExpenses.floatToString() + billSymbol
            incomeLabel.text = sumOfIncome.floatToString() + billSymbol
            billValueFloat = sumOfIncome - sumOfExpenses
            configureBill(with: bill[billIndex ?? 0])
            tableView.reloadData()
        }
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = groupedItems[itemDates[indexPath.section]]!
        transactionForEdit = Array(transaction)[indexPath.row]
        performSegue(withIdentifier: "transactionInfo", sender: self)
    }
    
}

extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trashAction = UIContextualAction(style: .destructive, title:  "Trash", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            RealmService.shared.delete(self.items![indexPath.row])
            self.loadTransactions()
            success(true)
        })
        trashAction.backgroundColor = .red
        trashAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [trashAction])
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemDates.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formate = itemDates[section].getFormattedDate(format: "yyyy-MM-dd")
        return itemDates[section].getFormattedDate(format: formate)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedItems[itemDates[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transaction", for: indexPath) as! TransactionCell
        
        let itemsForDate = groupedItems[itemDates[indexPath.section]]!
        cell.transactionName.text = "\(Array(itemsForDate)[indexPath.row].category)"
        cell.transactionColor.textColor = colors.colors[indexPath.row % colors.colors.count]
        var value = Array(itemsForDate)[indexPath.row].value
        if Array(itemsForDate)[indexPath.row].transactionType == 0 {
            cell.transactionType.tintColor = .red
            cell.transactionType.image = UIImage(systemName: "arrow.down")
            cell.transactionValue.text = "-\(value.floatToString())\(billSymbol)"
        } else {
            cell.transactionType.tintColor = #colorLiteral(red: 0.2045667768, green: 0.7816080451, blue: 0.3486227691, alpha: 1)
            cell.transactionType.image = UIImage(systemName: "arrow.up")
            cell.transactionValue.text = "\(value.floatToString())\(billSymbol)"
        }
        return cell
    }
}
