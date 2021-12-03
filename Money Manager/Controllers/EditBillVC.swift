//
//  EditBillVC.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 03.12.2021.
//

import UIKit

class EditBillVC: UITableViewController {

    @IBOutlet weak var billCapital: UILabel!
    @IBOutlet weak var billCurrency: UILabel!
    @IBOutlet weak var billName: UILabel!
    
    var capital: Float = 0.0
    var currency = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billCapital.text = String(capital)
        billCurrency.text = currency
        billName.text = name
    }

}
