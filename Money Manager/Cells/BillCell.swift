//
//  BillCell.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 27.11.2021.
//

import UIKit

class BillCell: UITableViewCell {

    @IBOutlet weak var billColor: UILabel!
    @IBOutlet weak var billName: UILabel!
    @IBOutlet weak var billValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureBill(with bill: Bill, sum: Float) {
        let billValueString = String(bill.budget + sum)
        billColor.textColor = .red
        billName.text = bill.name
        billValue.text = bill.currency + billValueString
    }

}
