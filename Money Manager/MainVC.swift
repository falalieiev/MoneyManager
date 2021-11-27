//
//  ViewController.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 26.11.2021.
//

import UIKit
import RealmSwift

class MainVC: UIViewController, MainVCDelegate {
    
    @IBOutlet weak var billView: UIStackView!
    @IBOutlet weak var billImage: UIImageView!
    @IBOutlet weak var billName: UILabel!
    @IBOutlet weak var billValue: UILabel!
    
    var bill: Results<Bill>!
    var billIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(billTapped))
        billView.addGestureRecognizer(gesture)
        
        let realm = RealmService.shared.realm
        bill = realm.objects(Bill.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if bill.isEmpty == false {
            configureBill(with: bill[billIndex])
        }
    }
    
    @objc func billTapped(sender : UITapGestureRecognizer) {
        if bill.count == 0 {
            performSegue(withIdentifier: "addBill", sender: sender)
        } else {
            performSegue(withIdentifier: "toBillSelection", sender: sender)
        }
    }
    
    func configureBill(with bill: Bill) {
        billImage.image = UIImage(systemName: "creditcard")
        billName.text = bill.name
        billValue.text = bill.currency + String(bill.budget)
    }
    
    func updateBillIndex(_ billIndexPassed: Int) {
        billIndex = billIndexPassed
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBillSelection" {
            guard let destination = segue.destination as? SelectBillTBC else { return }
            destination.delegate = self
        } else if segue.identifier == "addTransaction" {
            let destinationAddTransaction = segue.destination as! AddTransactionVC
            destinationAddTransaction.currentBill = bill[billIndex]
        }
    }
    
    @IBAction func addTransactionPressed(_ sender: UIBarButtonItem) {
        if bill.count == 0 {
            performSegue(withIdentifier: "addBill", sender: sender)
        } else {
            performSegue(withIdentifier: "addTransaction", sender: sender)
        }
    }
    
}

