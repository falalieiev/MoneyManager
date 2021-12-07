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
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureBill(with bill: Bill, sum: Float, _ color: UIColor) {
        var billValueFloat = bill.budget + sum
        billColor.textColor = color
        billName.text = bill.name
        billValue.text = billValueFloat.floatToString() + bill.currency.components(separatedBy: "- ")[1]
    }

}
