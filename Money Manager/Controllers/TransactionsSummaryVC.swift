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
    var operationsByCategory: Results<Transaction>!
    var billSymbol = ""
    let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrayExpenses = transactionObject.filter("transactionType == %@", 0).distinct(by: ["category"]).value(forKey: "category") as! [String]
        arrayIncome = transactionObject.filter("transactionType == %@", 1).distinct(by: ["category"]).value(forKey: "category") as! [String]
        if segmentControl.selectedSegmentIndex == 0 {
        sortedDictionary = RealmService.shared.transactionsByOrder(array: arrayExpenses, object: transactionObject, type: 0)
        } else {
            sortedDictionary = RealmService.shared.transactionsByOrder(array: arrayIncome, object: transactionObject, type: 1)
        }
        if sortedDictionary.isEmpty {
            chartView.data = nil
        }
        entries = []
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TransactionsByCategoryVC
        destinationVC.operations = operationsByCategory
        destinationVC.billSymbol = billSymbol
    }
    
    @IBAction func transactionTypeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            sortedDictionary = []
            sortedDictionary = RealmService.shared.transactionsByOrder(array: arrayExpenses, object: transactionObject, type: segmentControl.selectedSegmentIndex)
        } else {
            sortedDictionary = []
            sortedDictionary = RealmService.shared.transactionsByOrder(array: arrayIncome, object: transactionObject, type: segmentControl.selectedSegmentIndex)
        }
        if sortedDictionary.isEmpty {
            chartView.data = nil
        }
        entries = []
        tableView.reloadData()
    }
    
    func createChart(x: Double, y: Double) {
        chartView.chartSetting(chartView)
        entries.append(BarChartDataEntry(x: x, y: y))
        let set = BarChartDataSet(entries: entries)
        set.colors = colors.colors
        
        let data = BarChartData(dataSet: set)
        chartView.data = data
    }
    
}

extension TransactionsSummaryVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! TransactionCell
        operationsByCategory = transactionObject.filter("transactionType == %@", segmentControl.selectedSegmentIndex).filter("category == %@", currentCell.transactionName.text ?? "empty")
        performSegue(withIdentifier: "allOperationsByCategory", sender: self)
        currentCell.isSelected = false
    }
}

extension TransactionsSummaryVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionCell

        let keysArraySorted = Array(sortedDictionary.map({ $0.key }))
        var valuesArraySorted = Array(sortedDictionary.map({ $0.value }))
        cell.transactionName.text = keysArraySorted[indexPath.row]
        cell.transactionValue.text = valuesArraySorted[indexPath.row].floatToString() + billSymbol
        cell.transactionColor.textColor = colors.colors[indexPath.row % colors.colors.count]
        
        if entries.count < 12 {
            let yValue = valuesArraySorted[indexPath.row].rounded()
            createChart(x: Double(indexPath.row + 1), y: Double(yValue))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentControl.selectedSegmentIndex == 0 {
            return arrayExpenses.count
        } else {
            return arrayIncome.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
}
