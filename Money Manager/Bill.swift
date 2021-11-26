//
//  Bill.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 26.11.2021.
//

import Foundation
import RealmSwift

class Bill: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var currency: String = ""
    @objc dynamic var budget: Float = 0.0
    
    convenience init(_ name: String, _ currency: String, _ budget: Float) {
        self.init()
        self.name = name
        self.currency = currency
        self.budget = budget
    }
    
}
