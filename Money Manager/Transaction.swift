//
//  Transaction.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 27.11.2021.
//

import Foundation
import RealmSwift

class Transaction: Object {
    
    @objc dynamic var value: Float = 0.0
    @objc dynamic var note: String?
    @objc dynamic var transactionType: Int = 0
    @objc dynamic var creationDate: Date?
    
    convenience init(value: Float, note: String?, transactionType: Int, creationDate: Date?) {
        self.init()
        self.value = value
        self.note = note
        self.transactionType = transactionType
        self.creationDate = creationDate
    }
    
    var parentCategory = LinkingObjects(fromType: Bill.self, property: "transaction")
}
