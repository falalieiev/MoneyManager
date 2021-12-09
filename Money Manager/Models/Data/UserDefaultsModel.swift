//
//  UserDefaultsModel.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 09.12.2021.
//

import Foundation

struct UserDefaultsModel {
    static var shared  = UserDefaultsModel()
    
    var theme: Theme {
        get {
            return Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .light
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
        
    }
}
