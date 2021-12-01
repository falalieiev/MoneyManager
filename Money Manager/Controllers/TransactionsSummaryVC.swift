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
    
    @IBOutlet weak var chartView: HorizontalBarChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var transactionObject: List<Transaction>!
    var entries = [BarChartDataEntry]()
    var arrayExpenses: [String] = []
    var arrayIncome: [String] = []
    var sortedDictionary: [Dictionary<String, Float>.Element] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        arrayExpenses = transactionObject.filter("transactionType == %@", 0).distinct(by: ["category"]).value(forKey: "category") as! [String]
        arrayIncome = transactionObject.filter("transactionType == %@", 1).distinct(by: ["category"]).value(forKey: "category") as! [String]
        
        sortedDictionary = RealmService.shared.transactionsByOrder(array: arrayExpenses, object: transactionObject, type: 0)
    }
    
    @IBAction func transactionTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sortedDictionary = []
            sortedDictionary = RealmService.shared.transactionsByOrder(array: arrayExpenses, object: transactionObject, type: segmentControl.selectedSegmentIndex)
        } else {
            sortedDictionary = []
            sortedDictionary = RealmService.shared.transactionsByOrder(array: arrayIncome, object: transactionObject, type: segmentControl.selectedSegmentIndex)
        }
        entries = []
        tableView.reloadData()
    }
    
    func createChart(x: Double, y: Double) {
        chartView.chartSetting(chartView)
        entries.append(BarChartDataEntry(x: x, y: y))
        let set = BarChartDataSet(entries: entries)
        set.colors = [UIColor.red, UIColor.blue, UIColor.yellow, UIColor.green]
        if segmentControl.selectedSegmentIndex == 0 {
            set.label = "Расходы"

        } else {
            set.label = "Доходы"
        }
        set.stackLabels = ["sad", "asd"]
        let data = BarChartData(dataSet: set)
        chartView.data = data
    }
    
    
    
}

extension TransactionsSummaryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
}

extension TransactionsSummaryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionCell
        
        let keysArraySorted = Array(sortedDictionary.map({ $0.key }))
        let valuesArraySorted = Array(sortedDictionary.map({ $0.value }))
        cell.transactionName.text = keysArraySorted[indexPath.row]
        cell.transactionValue.text = String(valuesArraySorted[indexPath.row])
        
        createChart(x: Double(indexPath.row + 1), y: Double(valuesArraySorted[indexPath.row]))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
            return arrayExpenses.count
        } else {
            return arrayIncome.count
        }
    }
    
}

