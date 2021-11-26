//
//  ViewController.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 26.11.2021.
//

import UIKit
import RealmSwift

class MainVC: UIViewController {

    @IBOutlet weak var billView: UIStackView!
    @IBOutlet weak var billImage: UIImageView!
    @IBOutlet weak var billName: UILabel!
    @IBOutlet weak var billValue: UILabel!
    
    var bill: Results<Bill>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(billTapped))
        billView.addGestureRecognizer(gesture)
        
        let realm = RealmService.shared.realm
        bill = realm.objects(Bill.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if bill.isEmpty == false {
        configureBill(with: bill[0])
        }
    }
    
    @objc func billTapped(sender : UITapGestureRecognizer) {
            performSegue(withIdentifier: "addBill", sender: sender)
    }
    
    func configureBill(with bill: Bill) {
        billImage.image = UIImage(systemName: "creditcard")
        billName.text = bill.name
        billValue.text = bill.currency + String(bill.budget)
    }
}

