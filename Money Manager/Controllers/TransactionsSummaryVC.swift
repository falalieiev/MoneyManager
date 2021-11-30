//
//  TransactionsSummaryVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 30.11.2021.
//

import UIKit
import RealmSwift
import Charts

class TransactionsSummaryVC: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var bill: Results<Bill>!
    var transactionObject: List<Transaction>!
    var billIndex: Int?
    var list: Results<Transaction>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = RealmService.shared.realm
        bill = realm.objects(Bill.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        list = transactionObject.filter("transactionType == %@", 0).distinct(by: ["category"]).sorted(byKeyPath: "category")
        
        
        setupPieChart()

        }
    
    @IBAction func transactionTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            list = transactionObject.filter("transactionType == %@", 0).distinct(by: ["category"]).sorted(byKeyPath: "category")
        } else {
            list = transactionObject.filter("transactionType == %@", 1).distinct(by: ["category"]).sorted(byKeyPath: "category")
        }
        tableView.reloadData()
    }
    
    
    
    
    func setupPieChart() {
        pieChartView.chartDescription?.enabled = false
        pieChartView.drawHoleEnabled = false
        pieChartView.rotationAngle = 0
               //pieView.rotationEnabled = false
        pieChartView.isUserInteractionEnabled = false
        pieChartView.centerText = "Hello"
        pieChartView.drawHoleEnabled = true
        pieChartView.entryLabelColor = .black
        pieChartView.entryLabelFont = (.systemFont(ofSize: 11, weight: .light))
               
               pieChartView.legend.enabled = false
               
               var entries: [PieChartDataEntry] = Array()
               entries.append(PieChartDataEntry(value: 50.0, label: "Takeout"))
               entries.append(PieChartDataEntry(value: 30.0, label: "Healthy Food"))
               entries.append(PieChartDataEntry(value: 20.0, label: "Soft Drink"))
               entries.append(PieChartDataEntry(value: 10.0, label: "Water"))
               entries.append(PieChartDataEntry(value: 40.0, label: "Home Meals"))
               
        let dataSet = PieChartDataSet(entries: entries, label: "sds")
               
        let c1 = UIColor.yellow
               let c2 = UIColor.red
               let c3 = UIColor.blue
               let c4 = UIColor.cyan
               let c5 = UIColor.green
           
               dataSet.colors = [c1, c2, c3, c4, c5]
               dataSet.drawValuesEnabled = true
               
        pieChartView.data = PieChartData(dataSet: dataSet)
    }
    
    
}

extension TransactionsSummaryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension TransactionsSummaryVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionCell
        
        if let transaction = list?[indexPath.row] {
            let category = transactionObject.filter("transactionType == %@", segmentControl.selectedSegmentIndex).filter("category == %@", transaction.category)
            let value = category.value(forKey: "value") as! [Float]
            let sumOfEachCategory = value.reduce(0, {$0 + $1})
            cell.transactionName.text = transaction.category
            cell.transactionValue.text = String(sumOfEachCategory) //+ billSymbol
    }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
}

