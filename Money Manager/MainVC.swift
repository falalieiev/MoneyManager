//
//  ViewController.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 26.11.2021.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var billView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(billTapped))
        billView.addGestureRecognizer(gesture)
    }
    
    @objc func billTapped(sender : UITapGestureRecognizer) {
            performSegue(withIdentifier: "addBill", sender: sender)
    }


}

