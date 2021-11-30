//
//  TransactionCell.swift
//  Money Manager
//
//  Created by Oleh Falalieiev on 27.11.2021.
//

import UIKit
import RealmSwift

class TransactionCell: UITableViewCell {

    @IBOutlet weak var transactionColor: UILabel!
    @IBOutlet weak var transactionName: UILabel!
    @IBOutlet weak var transactionValue: UILabel!
    @IBOutlet weak var transactionType: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        // Configure the view for the selected state
    }
}
