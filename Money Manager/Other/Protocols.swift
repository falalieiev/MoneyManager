//
//  Protocols.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 16.12.2021.
//

import Foundation

protocol MainVCDelegate {
    func updateBillIndex(_ billIndex: Int)
}

protocol SearchCurrencyDelegate: AnyObject {
    func getCurrency(_ currencyIndexPassed: Int)
}

protocol CategoriesDelegate {
    func getCategoryInfo(category: Category)
}
