//
//  ViewController.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 26.11.2021.
//

import UIKit
import RealmSwift
import SideMenu

class MainVC: UIViewController {
    
    @IBOutlet weak var billView: UIStackView!
    @IBOutlet weak var billImage: UIImageView!
    @IBOutlet weak var billName: UILabel!
    @IBOutlet weak var billValue: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var summaryView: UIStackView!
    
    var billValueFloat: Float = 0.0
    var manager = MainVCManager()
    var sideMenu: SideMenuNavigationController!
    
    //MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(billTapped))
        billView.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(summaryTapped))
        summaryView.addGestureRecognizer(gesture1)
        
        let realm = RealmService.shared.realm
        manager.bill = realm.objects(Bill.self)
        
        loadTransactions()
        
        sideMenu = storyboard?.instantiateViewController(withIdentifier: "sideMenu") as? SideMenuNavigationController
        manager.sideMenuSettings(sideMenu, view, navigationController!.navigationBar)
        
        tableView.sectionFooterHeight = 1
        tableView.sectionHeaderHeight = 29
        
        let formate = Date().getFormattedDate(format: "E, d MMMM")
        self.title = formate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if manager.billIndex == nil {
            manager.billIndex = 0
        }
        
        if manager.bill.isEmpty == false {
            loadTransactions()
            configureBill(with: manager.bill[manager.billIndex ?? 0])
            loadTransactions()
        } else {
            billImage.image = UIImage(systemName: "plus")
            billValue.text = ""
            billName.text = "Добавить счет"
            expensesLabel.text = "0.0$"
            incomeLabel.text = "0.0$"
            manager.itemDates = []
            tableView.reloadData()
        }
    }
    
    //MARK: - Button Pressed
    
    @objc func billTapped(sender: UITapGestureRecognizer) {
        if manager.bill.count == 0 {
            performSegue(withIdentifier: "addBill", sender: sender)
        } else {
            performSegue(withIdentifier: "toBillSelection", sender: sender)
        }
    }
    
    @objc func summaryTapped(sender: UITapGestureRecognizer) {
        if manager.bill.count != 0 {
            performSegue(withIdentifier: "transactionObserve", sender: sender)
        }
    }
    
    @IBAction func sideMenuButton(_ sender: UIBarButtonItem) {
        if sideMenu.isHidden == false {
            dismiss(animated: true, completion: nil)
        } else {
            present(sideMenu, animated: true, completion: nil)
        }
    }
    
    @IBAction func addTransactionPressed(_ sender: UIBarButtonItem) {
        if manager.bill.count == 0 {
            performSegue(withIdentifier: "addBill", sender: sender)
        } else {
            performSegue(withIdentifier: "addTransaction", sender: sender)
        }
    }
    
    //MARK: - UI Changes
    
    func loadTransactions() {
        if manager.billIndex != nil {
            manager.transactionObject = manager.bill[manager.billIndex ?? 0].transaction
            manager.sortItemsByDate(manager.transactionObject)
            var sumOfIncome = RealmService.shared.sumOfIncome(object: manager.transactionObject)
            var sumOfExpenses = RealmService.shared.sumOfExpenses(object: manager.transactionObject)
            expensesLabel.text = "-" + sumOfExpenses.floatToString() + manager.billSymbol
            incomeLabel.text = sumOfIncome.floatToString() + manager.billSymbol
            billValueFloat = sumOfIncome - sumOfExpenses
            configureBill(with: manager.bill[manager.billIndex ?? 0])
            tableView.reloadData()
        }
    }
    
    func configureBill(with bill: Bill) {
        billImage.image = UIImage(systemName: "creditcard")
        billName.text = bill.name
        var billSum = bill.budget + billValueFloat
        billValue.text = billSum.floatToString() + bill.currency.components(separatedBy: "- ")[1]
        manager.billSymbol = bill.currency.components(separatedBy: "- ")[1]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        manager.prepareSegues(segue, self)
    }
}

    //MARK: - MaincVCDelegate

extension MainVC: MainVCDelegate {
    
    func updateBillIndex(_ billIndex: Int) {
        manager.billIndex = billIndex
    }
}

    //MARK: - TableView Methods

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = manager.groupedItems[manager.itemDates[indexPath.section]]!
        manager.transactionForEdit = Array(transaction)[indexPath.row]
        performSegue(withIdentifier: "transactionInfo", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        manager.deleteAction(indexPath: indexPath) {
            self.loadTransactions()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return manager.itemDates.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formate = manager.itemDates[section].getFormattedDate(format: "yyyy-MM-dd")
        return manager.itemDates[section].getFormattedDate(format: formate)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.groupedItems[manager.itemDates[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transaction", for: indexPath) as! TransactionCell
        return manager.setupCell(indexPath: indexPath, cell: cell)
    }
}
