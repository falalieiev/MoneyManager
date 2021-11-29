//
//  RealmService.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 26.11.2021.
//

import Foundation
import RealmSwift

class RealmService {
    
    private init() {}
    static let shared = RealmService()
    
    var realm = try! Realm()
    
    func create<T: Object>(_ object: T) {
        do {
            try realm.write{
                realm.add(object)
            }
        } catch {
            print(error)
        }
    }
    
    func append(_ object: Transaction, _ bill: Bill) {
        do {
            try realm.write{
                bill.transaction.append(object)
            }
        } catch {
            print(error)
        }
    }
    
    func sumOfIncome(object: List<Transaction>) -> Float {
        let filter = object.filter("transactionType == %@", 1)
        let value = filter.value(forKey: "value") as! [Float]
        let sumOfIncome = value.reduce(0, {$0 + $1})
        return sumOfIncome
    }
    
    func sumOfExpenses(object: List<Transaction>) -> Float {
        let filter1 = object.filter("transactionType == %@", 0)
        let value1 = filter1.value(forKey: "value") as! [Float]
        let sumOfExpenses = value1.reduce(0, {$0 + $1})
        return sumOfExpenses
    }
    
    func sumOfAllTransactions(object: List<Transaction>) -> Float {
        let filter = object.filter("transactionType == %@", 1)
        let value = filter.value(forKey: "value") as! [Float]
        let sumOfIncome = value.reduce(0, {$0 + $1})
        let filter1 = object.filter("transactionType == %@", 0)
        let value1 = filter1.value(forKey: "value") as! [Float]
        let sumOfExpenses = value1.reduce(0, {$0 + $1})
        return sumOfIncome - sumOfExpenses
    }
        
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print(error)
        }
    }
    
    
}
