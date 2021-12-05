//
//  Category.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 05.12.2021.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var type: Int = 0
    
    convenience init(_ name: String, _ type: Int) {
        self.init()
        self.name = name
        self.type = type
    }
}
