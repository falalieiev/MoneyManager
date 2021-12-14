//
//  MainVCManager.swift.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 14.12.2021.
//

import UIKit
import RealmSwift
import SideMenu

struct MainVCManager {
    
    var groupedItems = [Date:Results<Transaction>]()
    var itemDates = [Date]()
    var items: Results<Transaction>?
    var bill: Results<Bill>!
    var transactionObject: List<Transaction>!
    var billIndex: Int?
    var billSymbol = ""
    var transactionForEdit: Transaction!
    let colors = Colors()
    
    
    mutating func sortItemsByDate(_ transactionObject: List<Transaction>) {
        items = transactionObject.sorted(byKeyPath: "creationDate", ascending: false)
        
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
    }
    
    func prepareSegues(_ segue: UIStoryboardSegue, _ delegate: MainVCDelegate) {
        if segue.identifier == "toBillSelection" {
            guard let destination = segue.destination as? SelectBillVC else { return }
            destination.delegate = delegate
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
    
    func setupCell(indexPath: IndexPath, cell: TransactionCell) -> TransactionCell {
        let itemsForDate = groupedItems[itemDates[indexPath.section]]!
        
        cell.transactionName.text = "\(Array(itemsForDate)[indexPath.row].category)"
        cell.transactionColor.textColor = colors.colors[indexPath.row % colors.colors.count]
        
        var value = Array(itemsForDate)[indexPath.row].value
        
        if Array(itemsForDate)[indexPath.row].transactionType == 0 {
            cell.transactionType.tintColor = UIColor.red
            cell.transactionType.image = UIImage(systemName: "arrow.down")
            cell.transactionValue.text = "-\(value.floatToString())\(billSymbol)"
        } else {
            cell.transactionType.tintColor = #colorLiteral(red: 0.2045667768, green: 0.7816080451, blue: 0.3486227691, alpha: 1)
            cell.transactionType.image = UIImage(systemName: "arrow.up")
            cell.transactionValue.text = "\(value.floatToString())\(billSymbol)"
        }
        return cell
    }
    
    func sideMenuSettings(_ vc: SideMenuNavigationController, _ v: UIView, _ nb: UINavigationBar) {
        SideMenuManager.default.leftMenuNavigationController = vc
        SideMenuManager.default.addPanGestureToPresent(toView: v)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: nb, forMenu: .left)
        
        var settings = SideMenuSettings()
        settings.presentationStyle = .viewSlideOutMenuIn
        settings.menuWidth = 300
        settings.presentationStyle.presentingEndAlpha = 0.5
        
        SideMenuManager.default.leftMenuNavigationController?.settings = settings
    }
}
